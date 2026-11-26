import Foundation

struct ReleaseInfo {
    let version: String
    let url: URL
}

enum UpdateChecker {
    static let repository = "wunankun/HippoShelf"

    /// Compares dotted version strings ("1.10" > "1.9") without treating them as doubles.
    static func isNewer(_ candidate: String, than current: String) -> Bool {
        func components(_ value: String) -> [Int] {
            let trimmed = value.trimmingCharacters(in: CharacterSet(charactersIn: "vV").union(.whitespaces))
            return trimmed.split(separator: ".").map { part in
                Int(part.prefix { $0.isNumber }) ?? 0
            }
        }
        let a = components(candidate)
        let b = components(current)
        for index in 0..<max(a.count, b.count) {
            let x = index < a.count ? a[index] : 0
            let y = index < b.count ? b[index] : 0
            if x != y { return x > y }
        }
        return false
    }

    static func check(currentVersion: String, completion: @escaping (Result<ReleaseInfo, Error>) -> Void) {
        guard let url = URL(string: "https://api.github.com/repos/\(repository)/releases/latest") else {
            completion(.failure(NSError(domain: "HippoShelf.Update", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 12
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("HippoShelf/\(currentVersion)", forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard
                let data,
                let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let tag = object["tag_name"] as? String,
                let html = object["html_url"] as? String,
                let page = URL(string: html)
            else {
                completion(.failure(NSError(domain: "HippoShelf.Update", code: 1,
                                            userInfo: [NSLocalizedDescriptionKey: "Unexpected response"])))
                return
            }
            let version = tag.trimmingCharacters(in: CharacterSet(charactersIn: "vV").union(.whitespaces))
            completion(.success(ReleaseInfo(version: version, url: page)))
        }.resume()
    }
}
