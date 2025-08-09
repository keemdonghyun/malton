import Foundation

struct Message: Codable, Identifiable {
    var id: UUID = UUID()
    var threadId: String
    var role: String // "me" | "partner"
    var text: String
    var ts: TimeInterval
}

final class SharedStore {
    static let shared = SharedStore()
    private let fm = FileManager.default
    private let appGroup = "group.com.aahut.chatstyle"
    private var url: URL {
        let container = fm.containerURL(forSecurityApplicationGroupIdentifier: appGroup)!
        return container.appendingPathComponent("messages.json")
    }
    func load() -> [Message] {
        guard let data = try? Data(contentsOf: url) else { return [] }
        return (try? JSONDecoder().decode([Message].self, from: data)) ?? []
    }
    func save(_ items: [Message]) {
        let data = try? JSONEncoder().encode(items)
        try? data?.write(to: url, options: [.atomic])
    }
    func append(_ m: Message) { var items = load(); items.append(m); save(items) }
    func recent(threadId: String, limit: Int) -> [Message] {
        return load().filter { $0.threadId == threadId }.sorted{ $0.ts > $1.ts }.prefix(limit).map{ $0 }
    }
}