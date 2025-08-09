import Foundation

public struct ScoredMessage { public let msg: Message; public let score: Float }

public enum RagEngine {
    static func cosine(_ a: [Float], _ b: [Float]) -> Float {
        var s: Float = 0; let n = min(a.count, b.count)
        for i in 0..<n { s += a[i]*b[i] }
        return s
    }
    public static func topK(threadId: String, query: String, k: Int) -> [ScoredMessage] {
        let qv = EmbedderTF.shared.embed(query)
        let candidates = SharedStore.shared.recent(threadId: threadId, limit: 200)
        return candidates.map { m in
            ScoredMessage(msg: m, score: cosine(qv, EmbedderTF.shared.embed(m.text)))
        }.sorted { $0.score > $1.score }.prefix(k).map{ $0 }
    }
}
