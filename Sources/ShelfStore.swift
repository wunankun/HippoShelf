import Foundation

/// Files parked on the shelf for a short while.
final class ShelfStore {
    private(set) var items: [URL] = []
    var onChange: (() -> Void)?

    var isEmpty: Bool { items.isEmpty }

    /// Add dropped files, skipping ones already parked.
    func add(_ urls: [URL]) {
        var added = false
        for url in urls where url.isFileURL {
            let path = url.standardizedFileURL.path
            if items.contains(where: { $0.standardizedFileURL.path == path }) { continue }
            items.append(url)
            added = true
        }
        if added { onChange?() }
    }

    func remove(_ urls: [URL]) {
        let paths = Set(urls.map { $0.standardizedFileURL.path })
        let before = items.count
        items.removeAll { paths.contains($0.standardizedFileURL.path) }
        if items.count != before { onChange?() }
    }

    func remove(_ url: URL) {
        let path = url.standardizedFileURL.path
        guard items.contains(where: { $0.standardizedFileURL.path == path }) else { return }
        items.removeAll { $0.standardizedFileURL.path == path }
        onChange?()
    }

    func clear() {
        guard !items.isEmpty else { return }
        items.removeAll()
        onChange?()
    }
}
