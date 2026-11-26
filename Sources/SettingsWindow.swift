import AppKit
import ServiceManagement

/// A small settings window: language, launch at login and update check.
final class SettingsWindowController: NSWindowController {
    private let onLanguageChange: () -> Void

    private var languagePopup: NSPopUpButton!
    private var loginSwitch: NSSwitch!
    private var loginStatusLabel: NSTextField!
    private var versionLabel: NSTextField!
    private var updateButton: NSButton!
    private var updateStatusLabel: NSTextField!
    private var localizable: [(NSTextField, String)] = []

    private enum CheckState {
        case idle
        case checking
        case upToDate
        case found(String)
        case failed
    }

    private var checkState: CheckState = .idle

    private var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    init(onLanguageChange: @escaping () -> Void) {
        self.onLanguageChange = onLanguageChange
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 460),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = L10n.t("settings.title")
        window.isReleasedWhenClosed = false
        window.center()
        super.init(window: window)
        buildUI()
        refreshStrings()
        refreshLoginStatus()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }

    // MARK: - UI

    private func buildUI() {
        guard let window, let content = window.contentView else { return }

        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: content.topAnchor, constant: 22),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: content.bottomAnchor, constant: -20),
        ])

        let rowWidth: CGFloat = 432

        // App identity.
        let icon = NSImageView()
        icon.image = NSApp.applicationIconImage
        icon.imageScaling = .scaleProportionallyUpOrDown
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 42),
            icon.heightAnchor.constraint(equalToConstant: 42),
        ])
        let title = NSTextField(labelWithString: "HippoShelf")
        title.font = .systemFont(ofSize: 15.5, weight: .semibold)
        versionLabel = NSTextField(labelWithString: "")
        versionLabel.font = .systemFont(ofSize: 11)
        versionLabel.textColor = .secondaryLabelColor
        let titleStack = NSStackView(views: [title, versionLabel])
        titleStack.orientation = .vertical
        titleStack.alignment = .leading
        titleStack.spacing = 2
        let titleRow = NSStackView(views: [icon, titleStack])
        titleRow.orientation = .horizontal
        titleRow.alignment = .centerY
        titleRow.spacing = 12
        titleRow.widthAnchor.constraint(equalToConstant: rowWidth).isActive = true
        stack.addArrangedSubview(titleRow)

        stack.setCustomSpacing(20, after: titleRow)

        // Language.
        stack.addArrangedSubview(header("settings.language"))
        languagePopup = NSPopUpButton(frame: .zero, pullsDown: false)
        languagePopup.addItems(withTitles: AppLanguage.allCases.map(\.nativeName))
        languagePopup.target = self
        languagePopup.action = #selector(languageChanged)
        languagePopup.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stack.addArrangedSubview(languagePopup)
        stack.addArrangedSubview(note("settings.language.note", width: rowWidth))
        if let last = stack.arrangedSubviews.last {
            stack.setCustomSpacing(18, after: last)
        }

        // Launch at login.
        stack.addArrangedSubview(header("settings.login"))
        loginSwitch = NSSwitch()
        loginSwitch.target = self
        loginSwitch.action = #selector(loginToggled)
        loginStatusLabel = NSTextField(labelWithString: "")
        loginStatusLabel.font = .systemFont(ofSize: 11)
        loginStatusLabel.textColor = .secondaryLabelColor
        let loginRow = NSStackView(views: [loginSwitch, loginStatusLabel])
        loginRow.orientation = .horizontal
        loginRow.alignment = .centerY
        loginRow.spacing = 10
        stack.addArrangedSubview(loginRow)
        stack.addArrangedSubview(note("settings.login.note", width: rowWidth))
        if let last = stack.arrangedSubviews.last {
            stack.setCustomSpacing(18, after: last)
        }

        // Updates.
        stack.addArrangedSubview(header("settings.updates"))
        updateButton = NSButton(title: "", target: self, action: #selector(checkUpdates))
        updateButton.bezelStyle = .rounded
        updateStatusLabel = NSTextField(labelWithString: "")
        updateStatusLabel.font = .systemFont(ofSize: 11)
        updateStatusLabel.textColor = .secondaryLabelColor
        updateStatusLabel.isHidden = true
        let updateRow = NSStackView(views: [updateButton, updateStatusLabel])
        updateRow.orientation = .horizontal
        updateRow.alignment = .centerY
        updateRow.spacing = 10
        stack.addArrangedSubview(updateRow)
        stack.addArrangedSubview(note("settings.updates.note", width: rowWidth))

        let separator = NSBox()
        separator.boxType = .separator
        separator.widthAnchor.constraint(equalToConstant: rowWidth).isActive = true
        stack.addArrangedSubview(separator)
        stack.addArrangedSubview(note("settings.networkNote", width: rowWidth))

        content.layoutSubtreeIfNeeded()
        let height = stack.fittingSize.height + 44
        window.setContentSize(NSSize(width: 480, height: max(height, 380)))
        window.center()
    }

    private func header(_ key: String) -> NSTextField {
        let label = NSTextField(labelWithString: "")
        label.font = .systemFont(ofSize: 12.5, weight: .semibold)
        label.textColor = .labelColor
        localizable.append((label, key))
        return label
    }

    private func note(_ key: String, width: CGFloat) -> NSTextField {
        let label = NSTextField(wrappingLabelWithString: "")
        label.font = .systemFont(ofSize: 11)
        label.textColor = .tertiaryLabelColor
        label.maximumNumberOfLines = 0
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        localizable.append((label, key))
        return label
    }

    // MARK: - State

    func reload() {
        refreshStrings()
        refreshLoginStatus()
    }

    private func refreshStrings() {
        window?.title = L10n.t("settings.title")
        for (label, key) in localizable {
            label.stringValue = L10n.t(key)
        }
        let index = AppLanguage.allCases.firstIndex(of: L10n.language) ?? 0
        languagePopup?.selectItem(at: index)
        versionLabel?.stringValue = L10n.t("settings.version", currentVersion)
        updateButton?.title = L10n.t("settings.check")
        renderCheckState()
        refreshLoginStatus()
    }

    private func renderCheckState() {
        switch checkState {
        case .idle:
            updateStatusLabel.isHidden = true
            updateButton.isEnabled = true
        case .checking:
            updateStatusLabel.isHidden = false
            updateStatusLabel.stringValue = L10n.t("settings.checking")
            updateButton.isEnabled = false
        case .upToDate:
            updateStatusLabel.isHidden = false
            updateStatusLabel.stringValue = L10n.t("settings.upToDate")
            updateButton.isEnabled = true
        case .found(let version):
            updateStatusLabel.isHidden = false
            updateStatusLabel.stringValue = L10n.t("settings.found", version)
            updateButton.isEnabled = true
        case .failed:
            updateStatusLabel.isHidden = false
            updateStatusLabel.stringValue = L10n.t("update.failed")
            updateButton.isEnabled = true
        }
    }

    private func refreshLoginStatus() {
        guard let loginSwitch else { return }
        switch SMAppService.mainApp.status {
        case .enabled:
            loginSwitch.state = .on
            loginStatusLabel.stringValue = L10n.t("login.on")
        case .requiresApproval:
            loginSwitch.state = .on
            loginStatusLabel.stringValue = L10n.t("login.pending")
        default:
            loginSwitch.state = .off
            loginStatusLabel.stringValue = L10n.t("login.off")
        }
    }

    // MARK: - Actions

    @objc private func languageChanged() {
        let index = max(0, languagePopup.indexOfSelectedItem)
        guard index < AppLanguage.allCases.count else { return }
        L10n.language = AppLanguage.allCases[index]
        refreshStrings()
        onLanguageChange()
    }

    @objc private func loginToggled() {
        let wantsOn = loginSwitch.state == .on
        do {
            if wantsOn {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = L10n.t("login.failedTitle")
            alert.informativeText = L10n.t("login.failedInfo", error.localizedDescription)
            alert.addButton(withTitle: L10n.t("file.ok"))
            alert.runModal()
        }
        refreshLoginStatus()
    }

    @objc private func checkUpdates() {
        if case .checking = checkState { return }
        checkState = .checking
        renderCheckState()
        UpdateChecker.check(currentVersion: currentVersion) { [weak self] result in
            DispatchQueue.main.async {
                self?.finishCheck(result)
            }
        }
    }

    private func finishCheck(_ result: Result<ReleaseInfo, Error>) {
        switch result {
        case .success(let release):
            if UpdateChecker.isNewer(release.version, than: currentVersion) {
                checkState = .found(release.version)
                renderCheckState()
                presentUpdate(release)
            } else {
                checkState = .upToDate
                renderCheckState()
            }
        case .failure:
            checkState = .failed
            renderCheckState()
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = L10n.t("update.failed")
            alert.informativeText = L10n.t("update.failedInfo")
            alert.addButton(withTitle: L10n.t("file.ok"))
            alert.runModal()
        }
    }

    private func presentUpdate(_ release: ReleaseInfo) {
        let alert = NSAlert()
        alert.messageText = L10n.t("update.title")
        alert.informativeText = L10n.t("update.body", currentVersion, release.version)
        alert.addButton(withTitle: L10n.t("update.download"))
        alert.addButton(withTitle: L10n.t("update.later"))
        if alert.runModal() == .alertFirstButtonReturn {
            NSWorkspace.shared.open(release.url)
        }
    }
}
