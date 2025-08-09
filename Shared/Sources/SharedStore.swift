import Foundation

public struct Message: Codable, Identifiable {
    public var id: UUID = UUID()
    public var threadId: String
    public var role: String   // "me" | "partner"
    public var text: String
    public var ts: TimeInterval
}

public final class SharedStore {
    public static let shared = SharedStore()
    private let key = "maltone.messages"

    private func loadAll() -> [Message] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([Message].self, from: data)) ?? []
    }
    private func saveAll(_ items: [Message]) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    public func append(_ m: Message) { var items = loadAll(); items.append(m); saveAll(items) }
    public func recent(threadId: String, limit: Int) -> [Message] {
        return loadAll()
            .filter { $0.threadId == threadId }
            .sorted { $0.ts > $1.ts }
            .prefix(limit).map{ $0 }
    }
}
