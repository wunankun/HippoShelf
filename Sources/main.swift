import AppKit
import Quartz

final class PreviewSource: NSObject, QLPreviewPanelDataSource {
    var url: URL?

    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        url == nil ? 0 : 1
    }

    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        url as NSURL?
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let store = ShelfStore()
    private var panel: HippoPanel!
    private var statusItem: NSStatusItem?
    private var toggleItem: NSMenuItem?
    private var clearItem: NSMenuItem?
    private var cartoonSkinItem: NSMenuItem?
    private var glassSkinItem: NSMenuItem?
    private var settingsItem: NSMenuItem?
    private var quitItem: NSMenuItem?
    private var settingsController: SettingsWindowController?
    private var watcher: Timer?
    private var lastDragChange = NSPasteboard(name: .drag).changeCount
    private var dragActive = false
    private var hideWork: DispatchWorkItem?
    private var shrinkWork: DispatchWorkItem?
    private var lastCount = 0
    private let previewSource = PreviewSource()
    private var selectedURL: URL?
    private var keyMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        panel = HippoPanel(store: store)
        panel.content.onOpen = { [weak self] url in self?.openFile(url) }
        panel.content.onRemove = { [weak self] url in self?.store.remove(url) }
        panel.content.onClear = { [weak self] in self?.store.clear() }
        panel.content.onSelectionChange = { [weak self] urls in self?.selectedURL = urls.last }
        panel.content.onDragInsideChange = { [weak self] inside in
            guard let self, !inside else { return }
            self.panel.flushPendingEnlargement()
        }
        panel.onUserDragBegan = { [weak self] in self?.cancelHide() }
        // Deliberately no hide on drag end: moving the shelf is a placement
        // decision, so an empty card must not vanish right after you set it down.

        store.onChange = { [weak self] in
            guard let self else { return }
            self.panel.content.refresh()
            let count = self.store.items.count
            if count < self.lastCount {
                // A shorter mouth waits 0.2s before closing.
                self.shrinkWork?.cancel()
                let work = DispatchWorkItem { [weak self] in
                    self?.panel.fitContent(anchorTop: true, animated: true)
                }
                self.shrinkWork = work
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: work)
            } else {
                self.shrinkWork?.cancel()
                self.panel.fitContent(anchorTop: true, animated: true)
            }
            self.lastCount = count

            if self.store.isEmpty {
                self.scheduleHide()
            } else if !self.panel.isShown {
                self.showShelf()
            }
        }

        buildStatusItem()
        startWatchingDrags()
        startKeyMonitor()
    }

    // MARK: Keyboard

    private func startKeyMonitor() {
        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self else { return event }
            switch event.keyCode {
            case 49: // space
                self.togglePreview()
                return nil
            case 36: // return
                if let selectedURL = self.selectedURL {
                    self.openFile(selectedURL)
                    return nil
                }
                return event
            default:
                return event
            }
        }
    }

    private func togglePreview() {
        let preview = QLPreviewPanel.shared()!
        if preview.isVisible {
            preview.orderOut(nil)
            return
        }
        guard let selectedURL else { return }
        previewSource.url = selectedURL
        preview.dataSource = previewSource
        preview.currentPreviewItemIndex = 0
        preview.reloadData()
        preview.makeKeyAndOrderFront(nil)
    }

    // MARK: Drag detection

    /// The system drag pasteboard changes as soon as a drag starts, so a light
    /// poll is enough to reveal the shelf before the pointer reaches the edge.
    private func startWatchingDrags() {
        let timer = Timer(timeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.main.add(timer, forMode: .common)
        watcher = timer
    }

    private func tick() {
        // Our own tile drags change the same pasteboard; ignore them or the
        // refresh would tear down the view that owns the drag session.
        if ShelfDragState.isDraggingOut {
            lastDragChange = NSPasteboard(name: .drag).changeCount
            if NSEvent.pressedMouseButtons == 0 {
                // Safety net: a cancelled session should have called endedAt.
                ShelfDragState.isDraggingOut = false
            }
            return
        }

        let pasteboard = NSPasteboard(name: .drag)
        let buttonsDown = NSEvent.pressedMouseButtons != 0

        if pasteboard.changeCount != lastDragChange {
            lastDragChange = pasteboard.changeCount
            let hasFiles = hippoAcceptsFileURLs(pasteboard)
            if hasFiles && !dragActive {
                dragActive = true
                cancelHide()
                // Coming from outside: the shelf grows while you aim; it also
                // opens one extra row plus 0.2 of a row to take the file. The
                // glass card follows the same rule as the cartoon mouth.
                panel.content.setAnticipation(store.isEmpty ? 0 : 1)
                panel.content.setOvershoot(panel.content.tileHeight * 0.2)
                panel.setEnlargement(1.15, animated: panel.isShown)
                panel.fitContent(anchorTop: true, animated: true)
                if !panel.isShown { showShelf() }
            } else if !hasFiles && dragActive && !buttonsDown {
                // A drag pasteboard that empties while the button is still down
                // is just the source updating promised data; do not drop the
                // destination in the middle of the drag.
                endDrag()
            }
        }

        if dragActive && !buttonsDown {
            endDrag()
        }
    }

    // MARK: Opening files

    private func openFile(_ url: URL) {
        NSApp.activate(ignoringOtherApps: true)

        guard FileManager.default.fileExists(atPath: url.path) else {
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = L10n.t("file.missingTitle")
            alert.informativeText = L10n.t("file.missingInfo", url.lastPathComponent)
            alert.addButton(withTitle: L10n.t("file.remove"))
            alert.addButton(withTitle: L10n.t("file.ok"))
            if alert.runModal() == .alertFirstButtonReturn {
                store.remove(url)
            }
            return
        }

        // Reading first also asks macOS for folder access while the app is active,
        // so a first-time permission prompt can actually appear and be answered.
        do {
            let handle = try FileHandle(forReadingFrom: url)
            try? handle.close()
        } catch {
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = L10n.t("file.permTitle")
            alert.informativeText = L10n.t("file.permInfo", url.path)
            alert.addButton(withTitle: L10n.t("file.openSettings"))
            alert.addButton(withTitle: L10n.t("file.ok"))
            if alert.runModal() == .alertFirstButtonReturn,
               let settings = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_FilesAndFolders") {
                NSWorkspace.shared.open(settings)
            }
            return
        }

        if !NSWorkspace.shared.open(url) {
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = L10n.t("file.cannotOpenTitle")
            alert.informativeText = L10n.t("file.cannotOpenInfo", url.lastPathComponent)
            alert.addButton(withTitle: L10n.t("file.ok"))
            alert.runModal()
        }
    }

    // MARK: Visibility

    private func screenUnderMouse() -> NSScreen? {
        let point = NSEvent.mouseLocation
        return NSScreen.screens.first { NSMouseInRect(point, $0.frame, false) } ?? NSScreen.main
    }

    private func endDrag() {
        guard dragActive else { return }
        dragActive = false
        panel.content.setAnticipation(0)
        panel.content.setOvershoot(0)
        panel.setEnlargement(1.0, animated: true)
        panel.fitContent(anchorTop: true, animated: true)
        if store.isEmpty { scheduleHide() }
    }

    private func showShelf() {
        guard let screen = screenUnderMouse() else { return }
        panel.show(on: screen)
        toggleItem?.title = L10n.t("menu.hide")
    }

    private func hideShelf() {
        dragActive = false
        panel.setEnlargement(1.0, animated: false)
        panel.hide()
        toggleItem?.title = L10n.t("menu.show")
    }

    private func scheduleHide() {
        cancelHide()
        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }
            guard self.store.isEmpty, !self.dragActive else { return }
            self.hideShelf()
        }
        hideWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45, execute: work)
    }

    private func cancelHide() {
        hideWork?.cancel()
        hideWork = nil
    }

    // MARK: Menu bar

    private func buildStatusItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = item.button {
            let image = HippoStatusIcon.make()
            image.isTemplate = true
            button.image = image
            button.toolTip = L10n.t("app.name")
        }

        let menu = NSMenu()
        let toggle = NSMenuItem(title: L10n.t("menu.show"), action: #selector(toggleShelf), keyEquivalent: "s")
        toggle.target = self
        menu.addItem(toggle)
        toggleItem = toggle

        let clear = NSMenuItem(title: L10n.t("menu.clear"), action: #selector(clearShelf), keyEquivalent: "")
        clear.target = self
        menu.addItem(clear)
        clearItem = clear

        menu.addItem(.separator())

        let cartoon = NSMenuItem(title: L10n.t("menu.cartoon"), action: #selector(chooseCartoonSkin), keyEquivalent: "")
        cartoon.target = self
        cartoon.state = Hippo.skin == .cartoon ? .on : .off
        menu.addItem(cartoon)
        cartoonSkinItem = cartoon

        let glass = NSMenuItem(title: L10n.t("menu.glass"), action: #selector(chooseGlassSkin), keyEquivalent: "")
        glass.target = self
        glass.state = Hippo.skin == .glass ? .on : .off
        menu.addItem(glass)
        glassSkinItem = glass

        menu.addItem(.separator())

        let settings = NSMenuItem(title: L10n.t("menu.settings"), action: #selector(openSettings), keyEquivalent: ",")
        settings.target = self
        menu.addItem(settings)
        settingsItem = settings

        let quit = NSMenuItem(title: L10n.t("menu.quit"), action: #selector(quit), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)
        quitItem = quit

        item.menu = menu
        statusItem = item
    }

    @objc private func toggleShelf() {
        if panel.isShown { hideShelf() } else { showShelf() }
    }

    @objc private func clearShelf() {
        store.clear()
    }

    @objc private func chooseCartoonSkin() {
        applySkin(.cartoon)
    }

    @objc private func chooseGlassSkin() {
        applySkin(.glass)
    }

    private func applySkin(_ skin: HippoSkin) {
        Hippo.skin = skin
        UserDefaults.standard.set(skin.rawValue, forKey: "shelfSkin")
        cartoonSkinItem?.state = skin == .cartoon ? .on : .off
        glassSkinItem?.state = skin == .glass ? .on : .off
        panel.content.refresh()
        panel.content.applySkin()
        panel.fitContent(anchorTop: true, animated: true)
    }

    // MARK: Settings

    @objc private func openSettings() {
        if settingsController == nil {
            settingsController = SettingsWindowController(onLanguageChange: { [weak self] in
                self?.languageDidChange()
            })
        }
        settingsController?.reload()
        NSApp.activate(ignoringOtherApps: true)
        settingsController?.showWindow(nil)
        settingsController?.window?.makeKeyAndOrderFront(nil)
    }

    private func languageDidChange() {
        rebuildMenuTitles()
        panel.content.updateLocalizedStrings()
        statusItem?.button?.toolTip = L10n.t("app.name")
        settingsController?.window?.title = L10n.t("settings.title")
    }

    private func rebuildMenuTitles() {
        toggleItem?.title = panel.isShown ? L10n.t("menu.hide") : L10n.t("menu.show")
        clearItem?.title = L10n.t("menu.clear")
        cartoonSkinItem?.title = L10n.t("menu.cartoon")
        glassSkinItem?.title = L10n.t("menu.glass")
        settingsItem?.title = L10n.t("menu.settings")
        quitItem?.title = L10n.t("menu.quit")
    }

    @objc private func quit() {
        watcher?.invalidate()
        if let keyMonitor { NSEvent.removeMonitor(keyMonitor) }
        NSApp.terminate(nil)
    }

    func applicationWillTerminate(_ notification: Notification) {
        watcher?.invalidate()
        if let keyMonitor { NSEvent.removeMonitor(keyMonitor) }
    }
}

let application = NSApplication.shared
let delegate = AppDelegate()
application.delegate = delegate
application.run()
