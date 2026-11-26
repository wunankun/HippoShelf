import AppKit
import QuickLookThumbnailing
import UniformTypeIdentifiers

// MARK: - Shared drop helpers

protocol HippoDropTarget: AnyObject {
    func dropAccepts(_ pasteboard: NSPasteboard) -> Bool
    func dropPerform(_ pasteboard: NSPasteboard) -> Bool
    func dropHighlight(_ active: Bool)
}

func hippoFileURLs(in pasteboard: NSPasteboard) -> [URL] {
    let objects = pasteboard.readObjects(forClasses: [NSURL.self], options: [.urlReadingFileURLsOnly: true]) as? [NSURL] ?? []
    return objects.map { $0 as URL }
}

func hippoAcceptsFileURLs(_ pasteboard: NSPasteboard) -> Bool {
    pasteboard.availableType(from: [.fileURL]) != nil
}

final class ShelfDragState {
    static var isDraggingOut = false
}

// MARK: - Palette

enum HippoSkin: String {
    /// The black cartoon hippo head.
    case cartoon
    /// A minimal frosted-glass card.
    case glass
}

enum Hippo {
    static var skin: HippoSkin = {
        if let raw = UserDefaults.standard.string(forKey: "shelfSkin"),
           let saved = HippoSkin(rawValue: raw) {
            return saved
        }
        return .cartoon
    }()

    private static var black: Bool { skin == .cartoon }

    static var body: NSColor {
        black ? NSColor(srgbRed: 0.13, green: 0.13, blue: 0.15, alpha: 1)
              : NSColor(srgbRed: 0.66, green: 0.62, blue: 0.74, alpha: 1)
    }

    static var bodyDark: NSColor {
        black ? NSColor(srgbRed: 0.09, green: 0.09, blue: 0.11, alpha: 1)
              : NSColor(srgbRed: 0.55, green: 0.51, blue: 0.64, alpha: 1)
    }

    static var snout: NSColor {
        black ? NSColor(srgbRed: 0.24, green: 0.23, blue: 0.27, alpha: 1)
              : NSColor(srgbRed: 0.77, green: 0.73, blue: 0.84, alpha: 1)
    }

    static var earInner: NSColor {
        black ? NSColor(srgbRed: 0.76, green: 0.42, blue: 0.50, alpha: 1)
              : NSColor(srgbRed: 0.93, green: 0.66, blue: 0.76, alpha: 1)
    }

    static var mouth: NSColor {
        black ? NSColor(srgbRed: 0.035, green: 0.03, blue: 0.045, alpha: 1)
              : NSColor(srgbRed: 0.27, green: 0.15, blue: 0.20, alpha: 1)
    }

    static var tongue: NSColor {
        black ? NSColor(srgbRed: 0.55, green: 0.27, blue: 0.33, alpha: 1)
              : NSColor(srgbRed: 0.90, green: 0.53, blue: 0.60, alpha: 1)
    }

    static var teeth: NSColor {
        black ? NSColor(srgbRed: 0.95, green: 0.92, blue: 0.86, alpha: 1)
              : NSColor(srgbRed: 1.0, green: 0.97, blue: 0.94, alpha: 1)
    }

    static var eyeWhite: NSColor {
        black ? NSColor(srgbRed: 0.97, green: 0.96, blue: 0.93, alpha: 1)
              : NSColor(srgbRed: 1.0, green: 0.99, blue: 0.97, alpha: 1)
    }

    static var pupil: NSColor {
        black ? NSColor(srgbRed: 0.05, green: 0.05, blue: 0.07, alpha: 1)
              : NSColor(srgbRed: 0.18, green: 0.14, blue: 0.22, alpha: 1)
    }

    static var nostril: NSColor {
        black ? NSColor(srgbRed: 0.07, green: 0.07, blue: 0.09, alpha: 1)
              : NSColor(srgbRed: 0.36, green: 0.28, blue: 0.40, alpha: 1)
    }

    static var cheek: NSColor {
        black ? NSColor(srgbRed: 0.76, green: 0.42, blue: 0.50, alpha: 0.35)
              : NSColor(srgbRed: 0.93, green: 0.62, blue: 0.70, alpha: 0.45)
    }
}

private extension NSTextField {
    static func label(_ text: String, size: CGFloat, weight: NSFont.Weight = .regular, color: NSColor) -> NSTextField {
        let field = NSTextField(labelWithString: text)
        field.font = NSFont.systemFont(ofSize: size, weight: weight)
        field.textColor = color
        field.lineBreakMode = .byTruncatingTail
        field.maximumNumberOfLines = 1
        field.cell?.usesSingleLineMode = true
        return field
    }
}

// Views inside a tile are purely visual: if one of them becomes the hit view,
// AppKit resolves the drop destination to that (unregistered) view and drops fail.
private class PassthroughView: NSView {
    override func hitTest(_ point: NSPoint) -> NSView? { nil }
}
private final class PassthroughImageView: NSImageView {
    override func hitTest(_ point: NSPoint) -> NSView? { nil }
}
private final class PassthroughButton: NSButton {
    override func hitTest(_ point: NSPoint) -> NSView? { nil }
}
private final class PassthroughLabel: NSTextField {
    override func hitTest(_ point: NSPoint) -> NSView? { nil }
    static func make(_ text: String, size: CGFloat, color: NSColor) -> PassthroughLabel {
        let field = PassthroughLabel(labelWithString: text)
        field.font = NSFont.systemFont(ofSize: size)
        field.textColor = color
        field.lineBreakMode = .byTruncatingTail
        field.maximumNumberOfLines = 1
        field.cell?.usesSingleLineMode = true
        return field
    }
}

// MARK: - Tile held inside the mouth

final class HippoTileView: NSView, NSDraggingSource {
    static let width: CGFloat = 84
    static let baseHeight: CGFloat = 84

    let url: URL
    var onOpen: ((URL) -> Void)?
    var onRemove: ((URL) -> Void)?
    var onSelect: ((URL, NSEvent.ModifierFlags) -> Void)?
    /// URLs to drag when this tile starts a drag (the whole selection).
    var urlsForDrag: ((URL) -> [URL])?
    var onDragBegan: (([URL]) -> Void)?
    /// Called when the drag ends; `outside` means it was dropped somewhere else.
    var onDragFinished: (([URL], Bool) -> Void)?
    weak var dropTarget: HippoDropTarget?

    private let tileHeight: CGFloat
    private let thumbContainer = PassthroughView()
    private let thumbView = PassthroughImageView()
    private let nameLabel: PassthroughLabel
    private let removeButton = PassthroughButton()
    private let dropOverlay = TileDropOverlay()
    private var trackingArea: NSTrackingArea?
    private var hovered = false {
        didSet { updateHover() }
    }
    private var pressedPoint = NSPoint.zero
    private var dragging = false
    private var draggingURLs: [URL] = []

    var isSelected = false {
        didSet { updateSelection() }
    }

    init(url: URL, height: CGFloat) {
        self.url = url
        self.tileHeight = height
        self.nameLabel = .make(url.lastPathComponent, size: 9, color: NSColor(white: 1, alpha: 0.82))
        super.init(frame: NSRect(x: 0, y: 0, width: Self.width, height: height))
        wantsLayer = true
        layer?.cornerRadius = 7
        layer?.backgroundColor = NSColor(white: 1, alpha: 0.08).cgColor
        layer?.borderWidth = 0
        layer?.borderColor = NSColor.clear.cgColor

        thumbContainer.wantsLayer = true
        thumbContainer.layer?.cornerRadius = 5
        thumbContainer.layer?.backgroundColor = NSColor(white: 1, alpha: 0.10).cgColor
        thumbContainer.layer?.masksToBounds = true
        addSubview(thumbContainer)

        thumbView.imageScaling = .scaleProportionallyUpOrDown
        thumbView.image = NSWorkspace.shared.icon(forFile: url.path)
        addSubview(thumbView)

        nameLabel.alignment = .center
        addSubview(nameLabel)

        removeButton.image = NSImage(systemSymbolName: "xmark.circle.fill", accessibilityDescription: "移除")
        removeButton.isBordered = false
        removeButton.imagePosition = .imageOnly
        removeButton.contentTintColor = NSColor(white: 1, alpha: 0.8)
        removeButton.target = self
        removeButton.action = #selector(removePressed)
        removeButton.alphaValue = 0
        addSubview(removeButton)

        toolTip = "空白处拖动框选 · ⌘ 点选 · 空格预览 · 双击打开 · 拖出去即拿走"
        registerForDraggedTypes([.fileURL])
        dropOverlay.tile = self
        dropOverlay.frame = bounds
        dropOverlay.autoresizingMask = [.width, .height]
        dropOverlay.registerForDraggedTypes([.fileURL])
        addSubview(dropOverlay)
        loadThumbnail()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }

    override func layout() {
        super.layout()
        let thumbHeight = max(40, tileHeight - 26)
        thumbContainer.frame = NSRect(x: 4, y: 20, width: Self.width - 8, height: thumbHeight)
        thumbView.frame = NSRect(x: 7, y: 23, width: Self.width - 14, height: thumbHeight - 6)
        nameLabel.frame = NSRect(x: 0, y: 3, width: Self.width, height: 13)
        removeButton.frame = NSRect(x: Self.width - 19, y: tileHeight - 19, width: 14, height: 14)
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if let trackingArea { removeTrackingArea(trackingArea) }
        let area = NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(area)
        trackingArea = area
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        let local = convert(point, from: superview)
        guard bounds.contains(local) else { return nil }
        if hovered && removeButton.frame.contains(local) { return removeButton }
        return self
    }

    private func updateHover() {
        guard !isSelected else { return }
        layer?.backgroundColor = hovered
            ? NSColor(white: 1, alpha: 0.16).cgColor
            : NSColor(white: 1, alpha: 0.08).cgColor
        removeButton.alphaValue = hovered ? 1 : 0
    }

    private func updateSelection() {
        if isSelected {
            layer?.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.28).cgColor
            layer?.borderWidth = 1.5
            layer?.borderColor = NSColor.controlAccentColor.withAlphaComponent(0.95).cgColor
        } else {
            layer?.borderWidth = 0
            layer?.borderColor = NSColor.clear.cgColor
            updateHover()
        }
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }

    override func mouseEntered(with event: NSEvent) { hovered = true }
    override func mouseExited(with event: NSEvent) { hovered = false }

    override func mouseDown(with event: NSEvent) {
        pressedPoint = convert(event.locationInWindow, from: nil)
        dragging = false
    }

    override func mouseDragged(with event: NSEvent) {
        guard !dragging else { return }
        let point = convert(event.locationInWindow, from: nil)
        guard hypot(point.x - pressedPoint.x, point.y - pressedPoint.y) > 4 else { return }
        dragging = true
        beginDrag(with: event)
    }

    override func mouseUp(with event: NSEvent) {
        guard !dragging else { return }
        if event.clickCount >= 2 {
            onOpen?(url)
        } else {
            onSelect?(url, event.modifierFlags)
        }
    }

    @objc private func removePressed() {
        onRemove?(url)
    }

    private func beginDrag(with event: NSEvent) {
        ShelfDragState.isDraggingOut = true
        let urls = urlsForDrag?(url) ?? [url]
        let center = convert(NSPoint(x: bounds.midX, y: bounds.midY), to: nil)
        var items: [NSDraggingItem] = []
        for (index, each) in urls.enumerated() {
            let item = NSDraggingItem(pasteboardWriter: each as NSURL)
            let base = (each.standardizedFileURL == url.standardizedFileURL)
                ? thumbView.image
                : NSWorkspace.shared.icon(forFile: each.path)
            let image = (base ?? NSWorkspace.shared.icon(forFile: each.path)).copy() as? NSImage
            image?.size = NSSize(width: 46, height: 46)
            let offset = CGFloat(index) * 14
            let frame = NSRect(x: center.x - 23 + offset, y: center.y - 23 - offset, width: 46, height: 46)
            item.setDraggingFrame(frame, contents: image)
            items.append(item)
        }
        let session = beginDraggingSession(with: items, event: event, source: self)
        session.animatesToStartingPositionsOnCancelOrFail = true
        draggingURLs = urls
        onDragBegan?(urls)
    }

    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        .copy
    }

    func draggingSession(_ session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        ShelfDragState.isDraggingOut = false
        dragging = false
        let droppedOnShelf = window?.frame.contains(screenPoint) ?? false
        let outside = !operation.isEmpty && !droppedOnShelf
        let urls = draggingURLs.isEmpty ? [url] : draggingURLs
        draggingURLs = []
        onDragFinished?(urls, outside)
    }

    private func loadThumbnail() {
        guard url.isFileURL else { return }
        let contentType = try? url.resourceValues(forKeys: [.contentTypeKey]).contentType
        guard let contentType,
              contentType.conforms(to: .image) || contentType.conforms(to: .pdf)
                || contentType.conforms(to: .audiovisualContent)
        else { return }
        let request = QLThumbnailGenerator.Request(
            fileAt: url,
            size: CGSize(width: 200, height: 140),
            scale: 2,
            representationTypes: [.thumbnail, .icon]
        )
        QLThumbnailGenerator.shared.generateBestRepresentation(for: request) { [weak self] representation, _ in
            guard let self, let representation else { return }
            let image = NSImage(cgImage: representation.cgImage, size: NSSize(width: 100, height: 70))
            DispatchQueue.main.async {
                self.thumbView.image = image
            }
        }
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard let dropTarget, dropTarget.dropAccepts(sender.draggingPasteboard) else { return [] }
        dropTarget.dropHighlight(true)
        return .copy
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard let dropTarget, dropTarget.dropAccepts(sender.draggingPasteboard) else { return [] }
        return .copy
    }

    override func draggingExited(_ sender: NSDraggingInfo?) { dropTarget?.dropHighlight(false) }
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        dropTarget?.dropAccepts(sender.draggingPasteboard) ?? false
    }
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        dropTarget?.dropPerform(sender.draggingPasteboard) ?? false
    }
    override func concludeDragOperation(_ sender: NSDraggingInfo?) { dropTarget?.dropHighlight(false) }
}

/// Sits on top of every tile and takes the drop instead of the tile's visual
/// subviews: AppKit resolves the destination to the deepest view under the
/// pointer and does not walk up to a registered parent, so a registered
/// overlay that ignores clicks keeps drops working anywhere on the tile.
final class TileDropOverlay: NSView {
    weak var tile: HippoTileView?

    override func hitTest(_ point: NSPoint) -> NSView? { nil }

    private var target: HippoDropTarget? { tile?.dropTarget }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard let target, target.dropAccepts(sender.draggingPasteboard) else { return [] }
        target.dropHighlight(true)
        return .copy
    }
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard let target, target.dropAccepts(sender.draggingPasteboard) else { return [] }
        return .copy
    }
    override func draggingExited(_ sender: NSDraggingInfo?) { target?.dropHighlight(false) }
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        target?.dropAccepts(sender.draggingPasteboard) ?? false
    }
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        target?.dropPerform(sender.draggingPasteboard) ?? false
    }
    override func concludeDragOperation(_ sender: NSDraggingInfo?) { target?.dropHighlight(false) }
}

// MARK: - Bird (clear button on the right ear)

final class HippoBirdView: NSView {
    var onClear: (() -> Void)?
    private var hovered = false {
        didSet { needsDisplay = true }
    }
    private var trackingArea: NSTrackingArea?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        toolTip = "清空嘴巴"
        focusRingType = .none
        registerTracking()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }

    private func registerTracking() {
        if let trackingArea { removeTrackingArea(trackingArea) }
        let area = NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(area)
        trackingArea = area
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        registerTracking()
    }

    override func mouseEntered(with event: NSEvent) {
        hovered = true
        NSCursor.pointingHand.set()
    }

    override func mouseExited(with event: NSEvent) {
        hovered = false
        NSCursor.arrow.set()
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }

    override func mouseDown(with event: NSEvent) {
        onClear?()
    }

    override func draw(_ dirtyRect: NSRect) {
        let w = bounds.width
        let h = bounds.height

        // Tail.
        let tail = NSBezierPath()
        tail.move(to: NSPoint(x: w * 0.16, y: h * 0.42))
        tail.line(to: NSPoint(x: w * 0.02, y: h * 0.30))
        tail.line(to: NSPoint(x: w * 0.14, y: h * 0.26))
        tail.close()
        NSColor(srgbRed: 0.80, green: 0.24, blue: 0.24, alpha: 1).setFill()
        tail.fill()

        // Body.
        let bodyRect = NSRect(x: w * 0.18, y: h * 0.18, width: w * 0.58, height: h * 0.62)
        NSColor(srgbRed: 1.0, green: 0.38, blue: 0.35, alpha: 1).setFill()
        NSBezierPath(ovalIn: bodyRect).fill()

        // Wing.
        let wingRect = NSRect(x: w * 0.28, y: h * 0.28, width: w * 0.34, height: h * 0.34)
        NSColor(srgbRed: 0.84, green: 0.26, blue: 0.25, alpha: 1).setFill()
        NSBezierPath(ovalIn: wingRect).fill()

        // Head.
        let headRect = NSRect(x: w * 0.50, y: h * 0.52, width: w * 0.42, height: h * 0.42)
        NSColor(srgbRed: 1.0, green: 0.43, blue: 0.40, alpha: 1).setFill()
        NSBezierPath(ovalIn: headRect).fill()

        // Beak.
        let beak = NSBezierPath()
        beak.move(to: NSPoint(x: w * 0.90, y: h * 0.78))
        beak.line(to: NSPoint(x: w * 0.99, y: h * 0.68))
        beak.line(to: NSPoint(x: w * 0.89, y: h * 0.60))
        beak.close()
        NSColor(srgbRed: 1.0, green: 0.69, blue: 0.24, alpha: 1).setFill()
        beak.fill()

        // Eye.
        NSColor(srgbRed: 0.16, green: 0.12, blue: 0.18, alpha: 1).setFill()
        NSBezierPath(ovalIn: NSRect(x: w * 0.72, y: h * 0.74, width: w * 0.10, height: h * 0.10)).fill()

        // Feet.
        NSColor(srgbRed: 0.98, green: 0.63, blue: 0.20, alpha: 1).setFill()
        NSBezierPath(ovalIn: NSRect(x: w * 0.34, y: h * 0.04, width: w * 0.12, height: h * 0.08)).fill()
        NSBezierPath(ovalIn: NSRect(x: w * 0.54, y: h * 0.04, width: w * 0.12, height: h * 0.08)).fill()

    }
}

// MARK: - Teeth overlay (drawn above the files)

final class HippoTeethOverlay: NSView {
    var marqueeRect: NSRect? {
        didSet { needsDisplay = true }
    }
    /// Cartoon only: the four tusks. The marquee is still drawn in both skins.
    var showsTeeth = true {
        didSet { needsDisplay = true }
    }
    /// Glass only: the empty card shows a small drop hint.
    var showsHint = false {
        didSet { needsDisplay = true }
    }
    var hintRect: NSRect = .zero {
        didSet { needsDisplay = true }
    }
    /// Glass only: the hairline between the header and the content area.
    var showsDivider = false {
        didSet { needsDisplay = true }
    }
    var dividerY: CGFloat = 0 {
        didSet { needsDisplay = true }
    }

    override var isOpaque: Bool { false }

    override func hitTest(_ point: NSPoint) -> NSView? { nil }

    private func fang(x: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat, pointsUp: Bool) -> NSBezierPath {
        let direction: CGFloat = pointsUp ? 1 : -1
        let tip = NSPoint(x: x + width / 2, y: top + direction * height)
        let path = NSBezierPath()
        path.move(to: NSPoint(x: x, y: top))
        path.line(to: NSPoint(x: x + width, y: top))
        // A blunt, rounded tip: hippo tusks are pegs, not fangs.
        path.curve(to: tip,
                   controlPoint1: NSPoint(x: x + width * 0.92, y: top + direction * height * 0.78),
                   controlPoint2: NSPoint(x: x + width * 0.70, y: top + direction * height))
        path.curve(to: NSPoint(x: x, y: top),
                   controlPoint1: NSPoint(x: x + width * 0.30, y: top + direction * height),
                   controlPoint2: NSPoint(x: x + width * 0.08, y: top + direction * height * 0.78))
        path.close()
        return path
    }

    override func draw(_ dirtyRect: NSRect) {
        let W = bounds.width
        let H = bounds.height
        let mouthTop = H - HippoContentView.headHeight
        let jaw = HippoContentView.jawHeight

        if showsTeeth {
            let shadow = NSShadow()
            shadow.shadowColor = NSColor(white: 0, alpha: 0.25)
            shadow.shadowBlurRadius = 2
            shadow.shadowOffset = NSSize(width: 0, height: -1)
            NSGraphicsContext.saveGraphicsState()
            shadow.set()

            let ivory = NSColor(srgbRed: 1.0, green: 0.97, blue: 0.90, alpha: 1)
            ivory.setFill()

            // Two upper tusks hanging into the mouth.
            fang(x: 24, top: mouthTop, width: 17, height: 16, pointsUp: false).fill()
            fang(x: W - 41, top: mouthTop, width: 17, height: 16, pointsUp: false).fill()

            // Two lower tusks rising from the jaw.
            fang(x: 34, top: jaw, width: 15, height: 14, pointsUp: true).fill()
            fang(x: W - 49, top: jaw, width: 15, height: 14, pointsUp: true).fill()

            NSGraphicsContext.restoreGraphicsState()
        }

        if showsHint, hintRect.height > 10 {
            let text = L10n.t("hint.drop")
            var fontSize: CGFloat = 10.5
            var attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: fontSize, weight: .medium),
                .foregroundColor: NSColor(white: 1, alpha: 0.55)
            ]
            // Longer translations shrink a little to stay inside the glass card.
            while fontSize > 8.0,
                  (text as NSString).size(withAttributes: attributes).width > hintRect.width - 8 {
                fontSize -= 0.5
                attributes[.font] = NSFont.systemFont(ofSize: fontSize, weight: .medium)
            }
            let textSize = (text as NSString).size(withAttributes: attributes)
            let point = NSPoint(
                x: hintRect.midX - textSize.width / 2,
                y: hintRect.midY - textSize.height / 2
            )
            (text as NSString).draw(at: point, withAttributes: attributes)
        }

        if let rect = marqueeRect, rect.width > 1 || rect.height > 1 {
            let path = NSBezierPath(roundedRect: rect, xRadius: 3, yRadius: 3)
            NSColor.controlAccentColor.withAlphaComponent(0.14).setFill()
            path.fill()
            NSColor.controlAccentColor.withAlphaComponent(0.85).setStroke()
            path.lineWidth = 1
            path.stroke()
        }

        if showsDivider {
            let line = NSBezierPath()
            line.move(to: NSPoint(x: 10, y: dividerY))
            line.line(to: NSPoint(x: W - 10, y: dividerY))
            NSColor(white: 1, alpha: 0.14).setStroke()
            line.lineWidth = 1
            line.stroke()
        }
    }
}

// MARK: - Glass skin parts

/// The frosted backdrop. Clicks fall through to the content view underneath.
final class GlassBackdrop: NSVisualEffectView {
    override func hitTest(_ point: NSPoint) -> NSView? { nil }
}

/// The small round "clear" button in the glass header.
final class GlassClearButton: NSView {
    var onClear: (() -> Void)?
    private var hovered = false {
        didSet { needsDisplay = true }
    }
    private var trackingArea: NSTrackingArea?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        toolTip = L10n.t("tip.clear")
        focusRingType = .none
        registerTracking()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }

    private func registerTracking() {
        if let trackingArea { removeTrackingArea(trackingArea) }
        let area = NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(area)
        trackingArea = area
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        registerTracking()
    }

    override func mouseEntered(with event: NSEvent) {
        hovered = true
        NSCursor.pointingHand.set()
    }

    override func mouseExited(with event: NSEvent) {
        hovered = false
        NSCursor.arrow.set()
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }

    override func mouseDown(with event: NSEvent) {
        onClear?()
    }

    override func draw(_ dirtyRect: NSRect) {
        if hovered {
            NSColor(white: 1, alpha: 0.14).setFill()
            NSBezierPath(ovalIn: bounds.insetBy(dx: 0.5, dy: 0.5)).fill()
        }
        let inset: CGFloat = 6.5
        let path = NSBezierPath()
        path.move(to: NSPoint(x: inset, y: inset))
        path.line(to: NSPoint(x: bounds.width - inset, y: bounds.height - inset))
        path.move(to: NSPoint(x: bounds.width - inset, y: inset))
        path.line(to: NSPoint(x: inset, y: bounds.height - inset))
        path.lineWidth = 1.6
        path.lineCapStyle = .round
        NSColor(white: 1, alpha: hovered ? 0.9 : 0.55).setStroke()
        path.stroke()
    }
}

// MARK: - Face content

final class HippoContentView: NSView, HippoDropTarget {
    static let baseWidth: CGFloat = 124
    static let headHeight: CGFloat = 104
    static let jawHeight: CGFloat = 16
    static let mouthPadTop: CGFloat = 26
    static let mouthPadBottom: CGFloat = 24
    static let rowGap: CGFloat = 6
    static let minRows = 1
    static let minTileHeight: CGFloat = 56

    // Glass skin geometry.
    static let glassHeaderHeight: CGFloat = 30
    static let glassTopGap: CGFloat = 6
    static let glassBottomPad: CGFloat = 10
    static let glassCornerRadius: CGFloat = 18

    let store: ShelfStore
    var onOpen: ((URL) -> Void)?
    var onRemove: ((URL) -> Void)?
    var onClear: (() -> Void)?
    var onSelectionChange: (([URL]) -> Void)?
    var onDrop: (() -> Void)?
    var onDragInsideChange: ((Bool) -> Void)?
    var onUserDragBegin: (() -> Void)?
    var onUserDragEnd: (() -> Void)?

    private(set) var enlargement: CGFloat = 1
    /// Extra height (points) used for the short "open a bit wider, then settle"
    /// bounce right after a file lands in the mouth.
    private(set) var overshoot: CGFloat = 0
    /// Extra rows shown while an external drag hovers, so the mouth opens to
    /// take the incoming file before it lands.
    private(set) var anticipation: CGFloat = 0
    private(set) var selectedURLs: [URL] = []
    private var selectionAnchor: URL?
    private var marqueeStart: NSPoint?
    private var marqueeBase: [URL] = []
    private var isMovingWindow = false
    private var dragStartScreen: NSPoint?
    private var dragStartOrigin: NSPoint?
    private(set) var dragInside = false {
        didSet {
            guard dragInside != oldValue else { return }
            onDragInsideChange?(dragInside)
        }
    }

    private(set) var tileHeight: CGFloat = HippoTileView.baseHeight
    private var tiles: [HippoTileView] = []
    private let bird = HippoBirdView(frame: .zero)
    private let teeth = HippoTeethOverlay(frame: .zero)
    private let glassBackdrop = GlassBackdrop(frame: .zero)
    private let clearButton = GlassClearButton(frame: .zero)

    private var isGlass: Bool { Hippo.skin == .glass }
    private var dropHighlight = false {
        didSet { needsDisplay = true }
    }
    private var animationTimer: Timer?
    private var nextBlinkAt = Date().addingTimeInterval(3)
    private var blinkStart: Date?
    private var nextWiggleAt = Date().addingTimeInterval(5)
    private var wiggleStart: Date?

    init(store: ShelfStore) {
        self.store = store
        super.init(frame: NSRect(x: 0, y: 0, width: Self.baseWidth, height: 320))
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
        registerForDraggedTypes([.fileURL])

        glassBackdrop.material = .hudWindow
        glassBackdrop.blendingMode = .behindWindow
        glassBackdrop.state = .active
        glassBackdrop.wantsLayer = true
        glassBackdrop.layer?.cornerRadius = Self.glassCornerRadius
        glassBackdrop.layer?.masksToBounds = true
        glassBackdrop.layer?.borderWidth = 1
        glassBackdrop.layer?.borderColor = NSColor(white: 1, alpha: 0.12).cgColor
        glassBackdrop.isHidden = !isGlass
        addSubview(glassBackdrop)

        addSubview(teeth)
        addSubview(bird)
        bird.onClear = { [weak self] in self?.onClear?() }
        addSubview(clearButton)
        clearButton.onClear = { [weak self] in self?.onClear?() }
        clearButton.isHidden = true

        refresh()
        startAnimating()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }

    deinit {
        animationTimer?.invalidate()
    }

    override var isFlipped: Bool { false }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }

    // MARK: Sizing

    private var rows: Int { max(Self.minRows, store.items.count) }

    private var availableHeight: CGFloat {
        let screen = NSScreen.main?.visibleFrame.height ?? 900
        return screen - 48
    }

    private func computeTileHeight() -> CGFloat {
        if isGlass && store.isEmpty {
            return Self.minTileHeight
        }
        let rowsCount = CGFloat(rows)
        let fixed: CGFloat
        if isGlass {
            fixed = Self.glassHeaderHeight + Self.glassTopGap + Self.glassBottomPad
                + CGFloat(rows - 1) * Self.rowGap
        } else {
            fixed = Self.headHeight + Self.jawHeight + Self.mouthPadTop + Self.mouthPadBottom
                + CGFloat(rows - 1) * Self.rowGap
        }
        let available = availableHeight - fixed
        let fit = available / rowsCount
        return max(Self.minTileHeight, min(HippoTileView.baseHeight, fit))
    }

    var preferredWidth: CGFloat { Self.baseWidth * enlargement }

    private var baseMouthHeight: CGFloat {
        Self.mouthPadTop + CGFloat(rows) * tileHeight + CGFloat(rows - 1) * Self.rowGap + Self.mouthPadBottom
    }

    private var basePanelHeight: CGFloat {
        if isGlass {
            return Self.glassHeaderHeight + Self.glassTopGap + Self.glassBottomPad
                + CGFloat(rows) * tileHeight + CGFloat(rows - 1) * Self.rowGap
        }
        return Self.headHeight + baseMouthHeight + Self.jawHeight
    }

    var preferredHeight: CGFloat {
        let extra = anticipation * tileHeight
        return (basePanelHeight + extra + overshoot) * enlargement
    }

    func setAnticipation(_ rows: CGFloat) {
        guard abs(rows - anticipation) > 0.01 else { return }
        anticipation = rows
        needsLayout = true
    }

    func setOvershoot(_ next: CGFloat) {
        guard abs(next - overshoot) > 0.01 else { return }
        overshoot = next
        needsLayout = true
    }

    func setEnlargement(_ next: CGFloat) {
        guard abs(next - enlargement) > 0.001 else { return }
        enlargement = next
        needsLayout = true
    }

    // MARK: Content

    func refresh() {
        for tile in tiles { tile.removeFromSuperview() }
        tiles.removeAll()

        tileHeight = computeTileHeight()
        for url in store.items {
            let tile = HippoTileView(url: url, height: tileHeight)
            tile.onOpen = { [weak self] url in self?.onOpen?(url) }
            tile.onRemove = { [weak self] url in self?.onRemove?(url) }
            tile.onSelect = { [weak self] url, flags in self?.handleClick(url, modifiers: flags) }
            tile.urlsForDrag = { [weak self] url in self?.urlsForDrag(url) ?? [url] }
            tile.onDragFinished = { [weak self] urls, outside in self?.handleDragFinished(urls, outside: outside) }
            tile.onDragBegan = { [weak self] urls in self?.handleDragBegan(urls) }

            tile.dropTarget = self
            tile.isSelected = self.selectedURLs.contains { $0.standardizedFileURL.path == url.standardizedFileURL.path }
            addSubview(tile, positioned: .below, relativeTo: bird)
            tiles.append(tile)
        }
        // Keep the bird and the teeth above the tiles.
        addSubview(bird, positioned: .above, relativeTo: nil)
        addSubview(teeth, positioned: .above, relativeTo: bird)
        addSubview(clearButton, positioned: .above, relativeTo: teeth)

        updateSkinVisibility()

        let alive = Set(store.items.map { $0.standardizedFileURL.path })
        let before = selectedURLs.count
        selectedURLs.removeAll { !alive.contains($0.standardizedFileURL.path) }
        if selectedURLs.count != before { onSelectionChange?(selectedURLs) }
        needsLayout = true
        needsDisplay = true
    }

    private func updateSkinVisibility() {
        glassBackdrop.isHidden = !isGlass
        bird.isHidden = isGlass || store.isEmpty
        clearButton.isHidden = !isGlass || store.isEmpty
        teeth.showsTeeth = !isGlass
        teeth.showsHint = isGlass && store.isEmpty
        teeth.showsDivider = isGlass
    }

    /// Called when the user picks another skin from the menu.
    func applySkin() {
        updateSkinVisibility()
        setAnticipation(0)
        setOvershoot(0)
        needsLayout = true
        needsDisplay = true
        window?.invalidateShadow()
    }

    /// Called after the interface language changes: the drop hint is redrawn
    /// in the new language and the clear button gets a fresh tooltip.
    func updateLocalizedStrings() {
        clearButton.toolTip = L10n.t("tip.clear")
        teeth.needsDisplay = true
        needsDisplay = true
    }

    private func pathIndex(_ url: URL) -> Int? {
        store.items.firstIndex { $0.standardizedFileURL.path == url.standardizedFileURL.path }
    }

    private func syncSelection() {
        for tile in tiles {
            tile.isSelected = selectedURLs.contains { $0.standardizedFileURL.path == tile.url.standardizedFileURL.path }
        }
    }

    private func handleClick(_ url: URL, modifiers: NSEvent.ModifierFlags) {
        if modifiers.contains(.command) {
            if let index = selectedURLs.firstIndex(where: { $0.standardizedFileURL.path == url.standardizedFileURL.path }) {
                selectedURLs.remove(at: index)
            } else {
                selectedURLs.append(url)
                selectionAnchor = url
            }
        } else if modifiers.contains(.shift),
                  let anchor = selectionAnchor,
                  let from = pathIndex(anchor),
                  let to = pathIndex(url) {
            let range = from <= to ? from...to : to...from
            selectedURLs = range.map { store.items[$0] }
        } else {
            selectedURLs = [url]
            selectionAnchor = url
        }
        syncSelection()
        onSelectionChange?(selectedURLs)
    }

    private func urlsForDrag(_ url: URL) -> [URL] {
        if selectedURLs.contains(where: { $0.standardizedFileURL.path == url.standardizedFileURL.path }) {
            return selectedURLs
        }
        selectedURLs = [url]
        selectionAnchor = url
        syncSelection()
        onSelectionChange?(selectedURLs)
        return [url]
    }

    private func handleDragBegan(_ urls: [URL]) {
        let paths = Set(urls.map { $0.standardizedFileURL.path })
        for tile in tiles where paths.contains(tile.url.standardizedFileURL.path) {
            tile.alphaValue = 0
        }
    }

    private func handleDragFinished(_ urls: [URL], outside: Bool) {
        let paths = Set(urls.map { $0.standardizedFileURL.path })
        if outside {
            store.remove(urls)
            selectedURLs.removeAll { paths.contains($0.standardizedFileURL.path) }
            syncSelection()
            onSelectionChange?(selectedURLs)
        } else {
            for tile in tiles where paths.contains(tile.url.standardizedFileURL.path) {
                tile.alphaValue = 1
            }
        }
    }

    override func mouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        let handleHeight: CGFloat = isGlass ? Self.glassHeaderHeight : Self.headHeight
        if point.y >= bounds.height - handleHeight, let window {
            // Move the window by hand: performDrag gives us no end callback, so
            // the saved position went stale and the shelf snapped back on show.
            dragStartScreen = window.convertPoint(toScreen: event.locationInWindow)
            dragStartOrigin = window.frame.origin
            isMovingWindow = true
            onUserDragBegin?()
            return
        }
        marqueeStart = point
        marqueeBase = (event.modifierFlags.contains(.shift) || event.modifierFlags.contains(.command))
            ? selectedURLs
            : []
        teeth.marqueeRect = nil
    }

    override func mouseDragged(with event: NSEvent) {
        if isMovingWindow, let startScreen = dragStartScreen, let startOrigin = dragStartOrigin, let window {
            let now = window.convertPoint(toScreen: event.locationInWindow)
            window.setFrameOrigin(NSPoint(
                x: startOrigin.x + now.x - startScreen.x,
                y: startOrigin.y + now.y - startScreen.y
            ))
            return
        }
        guard let start = marqueeStart else { return }
        let point = convert(event.locationInWindow, from: nil)
        let rect = NSRect(
            x: min(start.x, point.x),
            y: min(start.y, point.y),
            width: abs(point.x - start.x),
            height: abs(point.y - start.y)
        )
        teeth.marqueeRect = rect

        var next = marqueeBase
        for tile in tiles where tile.frame.intersects(rect) {
            if !next.contains(where: { $0.standardizedFileURL.path == tile.url.standardizedFileURL.path }) {
                next.append(tile.url)
            }
        }
        if next.map({ $0.standardizedFileURL.path }) != selectedURLs.map({ $0.standardizedFileURL.path }) {
            selectedURLs = next
            syncSelection()
            onSelectionChange?(selectedURLs)
        }
    }

    override func mouseUp(with event: NSEvent) {
        if isMovingWindow {
            isMovingWindow = false
            dragStartScreen = nil
            dragStartOrigin = nil
            onUserDragEnd?()
            return
        }
        guard let start = marqueeStart else { return }
        marqueeStart = nil
        teeth.marqueeRect = nil
        let point = convert(event.locationInWindow, from: nil)
        if hypot(point.x - start.x, point.y - start.y) < 3, !selectedURLs.isEmpty {
            selectedURLs.removeAll()
            selectionAnchor = nil
            syncSelection()
            onSelectionChange?([])
        }
    }

    override func layout() {
        super.layout()
        let H = bounds.height
        let W = bounds.width

        glassBackdrop.frame = bounds
        teeth.frame = bounds

        if isGlass {
            let tileTop = H - Self.glassHeaderHeight - Self.glassTopGap
            teeth.dividerY = H - Self.glassHeaderHeight
            for (index, tile) in tiles.enumerated() {
                let y = tileTop - CGFloat(index + 1) * tileHeight - CGFloat(index) * Self.rowGap
                tile.frame = NSRect(x: (W - HippoTileView.width) / 2, y: y, width: HippoTileView.width, height: tileHeight)
            }
            clearButton.frame = NSRect(x: W - 29, y: H - 29, width: 22, height: 22)
            teeth.hintRect = NSRect(x: 8, y: Self.glassBottomPad, width: W - 16, height: max(20, tileTop - Self.glassBottomPad))
            bird.frame = .zero
            bird.isHidden = true
            return
        }

        let mouthTop = H - Self.headHeight
        let tileTop = mouthTop - Self.mouthPadTop

        for (index, tile) in tiles.enumerated() {
            let y = tileTop - CGFloat(index + 1) * tileHeight - CGFloat(index) * Self.rowGap
            tile.frame = NSRect(x: (W - HippoTileView.width) / 2, y: y, width: HippoTileView.width, height: tileHeight)
        }
        bird.frame = NSRect(x: W - 38, y: H - 34, width: 30, height: 26)
        clearButton.frame = .zero
        bird.isHidden = store.isEmpty
    }

    // MARK: Drawing

    override func draw(_ dirtyRect: NSRect) {
        if isGlass { return }
        let W = bounds.width
        let H = bounds.height
        let mouthTop = H - Self.headHeight
        let now = Date()
        let wiggle = wiggleAngle(at: now)

        // Head + jaw body.
        let body = NSBezierPath(roundedRect: NSRect(x: 2, y: 2, width: W - 4, height: H - 40), xRadius: 26, yRadius: 26)
        Hippo.body.setFill()
        body.fill()
        if Hippo.skin == .cartoon {
            NSColor(white: 1, alpha: 0.10).setStroke()
            body.lineWidth = 1
            body.stroke()
        }

        // Ears sit on top of the head, clearly outside the silhouette.
        drawEar(center: NSPoint(x: W * 0.21, y: H - 33), angle: wiggle)
        drawEar(center: NSPoint(x: W * 0.79, y: H - 33), angle: -wiggle)

        // Eyes.
        let mouse = localMouseLocation()
        let blink = blinkFactor(at: now)
        for eye in [NSPoint(x: W * 0.30, y: H - 54), NSPoint(x: W * 0.70, y: H - 54)] {
            drawEye(center: eye, mouse: mouse, blink: blink)
        }

        // Blush.
        Hippo.cheek.setFill()
        NSBezierPath(ovalIn: NSRect(x: W * 0.06, y: H - 64, width: 17, height: 9)).fill()
        NSBezierPath(ovalIn: NSRect(x: W * 0.94 - 17, y: H - 64, width: 17, height: 9)).fill()

        // Muzzle with nostrils.
        let snout = NSBezierPath(roundedRect: NSRect(x: W * 0.13, y: H - 96, width: W * 0.74, height: 32), xRadius: 16, yRadius: 16)
        Hippo.snout.setFill()
        snout.fill()
        Hippo.nostril.setFill()
        NSBezierPath(ovalIn: NSRect(x: W * 0.30, y: H - 76, width: 10, height: 7)).fill()
        NSBezierPath(ovalIn: NSRect(x: W * 0.70 - 10, y: H - 76, width: 10, height: 7)).fill()

        // Mouth cavity: always hangs from under the head, jaw at the bottom.
        let mouthRect = NSRect(x: 8, y: Self.jawHeight, width: W - 16, height: max(4, mouthTop - Self.jawHeight))
        let mouthPath = NSBezierPath(roundedRect: mouthRect, xRadius: 13, yRadius: 13)
        if dropHighlight {
            NSColor.controlAccentColor.withAlphaComponent(0.28).setFill()
            mouthPath.fill()
        }
        Hippo.mouth.setFill()
        mouthPath.fill()

        // Lower lip line.
        NSColor(white: 1, alpha: 0.06).setFill()
        NSBezierPath(roundedRect: NSRect(x: 10, y: Self.jawHeight - 3, width: W - 20, height: 3), xRadius: 1.5, yRadius: 1.5).fill()
    }

    private func drawEar(center: NSPoint, angle: CGFloat) {
        NSGraphicsContext.saveGraphicsState()
        if let context = NSGraphicsContext.current?.cgContext {
            context.translateBy(x: center.x, y: center.y)
            context.rotate(by: angle)
        }
        let earRect = NSRect(x: -11, y: -14, width: 22, height: 28)
        Hippo.body.setFill()
        NSBezierPath(ovalIn: earRect).fill()
        Hippo.earInner.setFill()
        NSBezierPath(ovalIn: earRect.insetBy(dx: 6, dy: 6)).fill()
        NSGraphicsContext.restoreGraphicsState()
    }

    private func drawEye(center: NSPoint, mouse: NSPoint, blink: CGFloat) {
        let radius: CGFloat = 9.5
        let eyeRect = NSRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
        Hippo.eyeWhite.setFill()
        NSBezierPath(ovalIn: eyeRect).fill()

        let dx = max(-3.5, min(3.5, (mouse.x - center.x) / 40))
        let dy = max(-3, min(3, (mouse.y - center.y) / 40))
        Hippo.pupil.setFill()
        NSBezierPath(ovalIn: NSRect(x: center.x + dx - 4, y: center.y + dy - 4, width: 8, height: 8)).fill()
        NSColor(white: 1, alpha: 0.9).setFill()
        NSBezierPath(ovalIn: NSRect(x: center.x + dx + 0.6, y: center.y + dy + 1.4, width: 2.2, height: 2.2)).fill()

        if blink > 0.01 {
            NSGraphicsContext.saveGraphicsState()
            NSBezierPath(ovalIn: eyeRect).addClip()
            let lidHeight = radius * 2 * blink
            Hippo.body.setFill()
            NSBezierPath(rect: NSRect(x: center.x - radius, y: center.y + radius - lidHeight, width: radius * 2, height: lidHeight)).fill()
            NSGraphicsContext.restoreGraphicsState()
        }
    }

    private func localMouseLocation() -> NSPoint {
        guard let window else { return .zero }
        let screen = NSEvent.mouseLocation
        let windowPoint = window.convertPoint(fromScreen: screen)
        return convert(windowPoint, from: nil)
    }

    private func blinkFactor(at now: Date) -> CGFloat {
        if now >= nextBlinkAt {
            blinkStart = now
            nextBlinkAt = now.addingTimeInterval(Double.random(in: 3.0...6.5))
        }
        guard let blinkStart, now.timeIntervalSince(blinkStart) < 0.16 else { return 0 }
        let t = now.timeIntervalSince(blinkStart) / 0.16
        return CGFloat(sin(t * .pi))
    }

    private func wiggleAngle(at now: Date) -> CGFloat {
        if now >= nextWiggleAt {
            wiggleStart = now
            nextWiggleAt = now.addingTimeInterval(Double.random(in: 6.0...10.0))
        }
        guard let wiggleStart, now.timeIntervalSince(wiggleStart) < 0.7 else { return 0 }
        let t = now.timeIntervalSince(wiggleStart) / 0.7
        return CGFloat(sin(t * .pi * 3)) * 0.10
    }

    private func startAnimating() {
        let timer = Timer(timeInterval: 1.0 / 30.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            guard self.window?.isVisible == true else { return }
            self.needsDisplay = true
        }
        RunLoop.main.add(timer, forMode: .common)
        animationTimer = timer
    }

    // MARK: Drop

    func dropAccepts(_ pasteboard: NSPasteboard) -> Bool {
        hippoAcceptsFileURLs(pasteboard)
    }

    func dropPerform(_ pasteboard: NSPasteboard) -> Bool {
        dropHighlight = false
        let urls = hippoFileURLs(in: pasteboard)
        guard !urls.isEmpty else { return false }
        // Drop settles immediately: the anticipation row becomes a real row.
        setAnticipation(0)
        setOvershoot(0)
        store.add(urls)
        onDrop?()
        return true
    }

    func dropHighlight(_ active: Bool) {
        dropHighlight = active
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard dropAccepts(sender.draggingPasteboard) else { return [] }
        dragInside = true
        dropHighlight = true
        return .copy
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        dropAccepts(sender.draggingPasteboard) ? .copy : []
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
        dragInside = false
        dropHighlight = false
    }

    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        dropAccepts(sender.draggingPasteboard)
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let accepted = dropPerform(sender.draggingPasteboard)
        dragInside = false
        return accepted
    }

    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        dragInside = false
        dropHighlight = false
    }
}

// MARK: - Panel

final class HippoPanel: NSPanel {
    let content: HippoContentView
    private(set) var isShown = false
    private var hostScreen: NSScreen?
    private var pendingEnlargement: CGFloat?

    var onUserDragBegan: (() -> Void)?
    var onUserDragEnded: (() -> Void)?

    private let originXKey = "shelfOriginX"
    private let originYKey = "shelfOriginY"

    init(store: ShelfStore) {
        content = HippoContentView(store: store)
        let size = NSSize(width: content.preferredWidth, height: content.preferredHeight)
        super.init(
            contentRect: NSRect(origin: .zero, size: size),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        level = .floating
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
        isMovableByWindowBackground = false
        hidesOnDeactivate = false
        contentView = content

        content.onUserDragBegin = { [weak self] in self?.onUserDragBegan?() }
        content.onUserDragEnd = { [weak self] in
            self?.finishUserDragMove()
            self?.onUserDragEnded?()
        }
    }

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }

    var enlargement: CGFloat { content.enlargement }

    // MARK: - Placement

    private var savedOrigin: NSPoint? {
        let defaults = UserDefaults.standard
        guard defaults.object(forKey: originXKey) != nil, defaults.object(forKey: originYKey) != nil else {
            return nil
        }
        return NSPoint(x: defaults.double(forKey: originXKey), y: defaults.double(forKey: originYKey))
    }

    private func saveOrigin(_ origin: NSPoint) {
        let defaults = UserDefaults.standard
        defaults.set(Double(origin.x), forKey: originXKey)
        defaults.set(Double(origin.y), forKey: originYKey)
    }

    private func clampToScreen(_ origin: NSPoint, size: NSSize, screen: NSScreen) -> NSPoint {
        let visible = screen.visibleFrame
        let x = min(max(origin.x, visible.minX + 8), visible.maxX - size.width - 8)
        let y = min(max(origin.y, visible.minY + 8), visible.maxY - size.height - 8)
        return NSPoint(x: x, y: y)
    }

    /// The screen that currently holds the shelf, preferring the saved placement.
    private func placementScreen() -> NSScreen? {
        if let saved = savedOrigin,
           let screen = NSScreen.screens.first(where: { $0.frame.contains(saved) }) {
            return screen
        }
        if let hostScreen, frame.intersects(hostScreen.visibleFrame) { return hostScreen }
        return NSScreen.main
    }

    /// Keep the top edge and, for the default placement, pin the nearer side.
    /// Once the user has placed the shelf themselves, keep their x instead of
    /// snapping the card back to an edge whenever it grows.
    private func anchoredOrigin(size: NSSize, screen: NSScreen, top: CGFloat?) -> NSPoint {
        let visible = screen.visibleFrame
        let y = top ?? frame.maxY
        let x: CGFloat
        if savedOrigin != nil {
            x = frame.minX
        } else {
            let leftSide = frame.midX < visible.midX
            x = leftSide ? frame.minX : visible.maxX - size.width
        }
        return clampToScreen(NSPoint(x: x, y: y - size.height), size: size, screen: screen)
    }

    private func finishUserDragMove() {
        // The shelf may have been carried to another display: use the screen
        // that now contains it, not the saved (old) placement.
        let center = NSPoint(x: frame.midX, y: frame.midY)
        let screen = NSScreen.screens.first(where: { $0.frame.contains(center) })
            ?? placementScreen()
        guard let screen else { return }
        let origin = clampToScreen(frame.origin, size: frame.size, screen: screen)
        if origin != frame.origin {
            setFrame(NSRect(origin: origin, size: frame.size), display: true)
        }
        saveOrigin(origin)
        hostScreen = screen
    }

    func setEnlargement(_ requested: CGFloat, animated: Bool) {
        let next = requested
        guard abs(next - content.enlargement) > 0.001 else { return }
        if next < content.enlargement && content.dragInside {
            pendingEnlargement = next
            return
        }
        pendingEnlargement = nil
        content.setEnlargement(next)
        content.layoutSubtreeIfNeeded()
        let size = NSSize(width: content.preferredWidth, height: content.preferredHeight)
        guard let screen = placementScreen() else { return }
        let target = NSRect(origin: anchoredOrigin(size: size, screen: screen, top: frame.maxY), size: size)
        if animated, isShown {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.16
                context.timingFunction = CAMediaTimingFunction(name: .easeOut)
                animator().setFrame(target, display: true)
            }
        } else if isShown {
            setFrame(target, display: true)
        } else {
            setFrame(target, display: false)
        }
    }

    func flushPendingEnlargement() {
        guard let pending = pendingEnlargement else { return }
        pendingEnlargement = nil
        setEnlargement(pending, animated: true)
    }

    func fitContent(anchorTop: Bool, animated: Bool = false) {
        content.layoutSubtreeIfNeeded()
        let size = NSSize(width: content.preferredWidth, height: content.preferredHeight)
        guard abs(size.height - frame.height) > 0.5 || abs(size.width - frame.width) > 0.5 else { return }
        let top = frame.maxY
        var target = NSRect(origin: frame.origin, size: size)
        if anchorTop, let screen = placementScreen() {
            target.origin = anchoredOrigin(size: size, screen: screen, top: top)
        }
        if animated, isShown {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.16
                context.timingFunction = CAMediaTimingFunction(name: .easeOut)
                animator().setFrame(target, display: true)
            }
        } else {
            setFrame(target, display: true)
        }
    }

    /// Open a little wider than the new row needs, then settle: the extra is
    /// 0.2 of a file height.
    func openBounce() {
        content.setOvershoot(content.tileHeight * 0.2)
        fitContent(anchorTop: true, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) { [weak self] in
            guard let self else { return }
            self.content.setOvershoot(0)
            self.fitContent(anchorTop: true, animated: true)
        }
    }

    func show(on screen: NSScreen) {
        fitContent(anchorTop: false)
        let size = frame.size

        let target: NSRect
        var slidesIn = false
        if let saved = savedOrigin {
            let placement = NSScreen.screens.first(where: { $0.frame.contains(saved) }) ?? screen
            hostScreen = placement
            let origin = clampToScreen(saved, size: size, screen: placement)
            target = NSRect(origin: origin, size: size)
        } else {
            hostScreen = screen
            let visible = screen.visibleFrame
            let y = min(max(visible.midY - size.height / 2, visible.minY + 8), visible.maxY - size.height - 8)
            target = NSRect(x: visible.maxX - size.width, y: y, width: size.width, height: size.height)
            slidesIn = true
        }

        if !isShown {
            if slidesIn {
                setFrame(target.offsetBy(dx: 26, dy: 0), display: false)
            } else {
                setFrame(target, display: false)
            }
            alphaValue = 0
            orderFrontRegardless()
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.18
                context.timingFunction = CAMediaTimingFunction(name: .easeOut)
                animator().alphaValue = 1
                if slidesIn {
                    animator().setFrame(target, display: true)
                }
            }
        } else {
            setFrame(target, display: true)
            orderFrontRegardless()
        }
        isShown = true
    }

    func hide() {
        guard isShown else { return }
        pendingEnlargement = nil
        isShown = false
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.16
            animator().alphaValue = 0
        }, completionHandler: { [weak self] in
            guard let self, !self.isShown else { return }
            self.orderOut(nil)
            self.alphaValue = 1
        })
    }
}

// MARK: - Menu bar icon

enum HippoStatusIcon {
    static func make(size: CGFloat = 18) -> NSImage {
        let image = NSImage(size: NSSize(width: size, height: size))
        image.lockFocus()
        let bodyColor = NSColor.black
        bodyColor.setFill()
        let head = NSBezierPath(roundedRect: NSRect(x: size * 0.12, y: size * 0.10, width: size * 0.76, height: size * 0.66), xRadius: size * 0.24, yRadius: size * 0.24)
        head.fill()
        NSBezierPath(ovalIn: NSRect(x: size * 0.10, y: size * 0.62, width: size * 0.24, height: size * 0.28)).fill()
        NSBezierPath(ovalIn: NSRect(x: size * 0.66, y: size * 0.62, width: size * 0.24, height: size * 0.28)).fill()
        NSColor.white.setFill()
        NSBezierPath(ovalIn: NSRect(x: size * 0.28, y: size * 0.40, width: size * 0.12, height: size * 0.12)).fill()
        NSBezierPath(ovalIn: NSRect(x: size * 0.60, y: size * 0.40, width: size * 0.12, height: size * 0.12)).fill()
        NSBezierPath(roundedRect: NSRect(x: size * 0.26, y: size * 0.18, width: size * 0.48, height: size * 0.16), xRadius: size * 0.06, yRadius: size * 0.06).fill()
        image.unlockFocus()
        return image
    }
}
