import Foundation
struct StyleProfile { var honorificRatio: Float; var avgLen: Int; var commonEndings: [String]; var emojiRate: Float }
enum StyleProfiler {
    static let ends = ["할게","같아","거야","일듯","합니다","해요","ㅎㅎ","ㅋㅋ"]
    static func build(threadIds: [String]) -> StyleProfile {
        let msgs = threadIds.flatMap { SharedStore.shared.recent(threadId: $0, limit: 500) }.filter{ $0.role == "me" }
        guard !msgs.isEmpty else { return .init(honorificRatio: 0.6, avgLen: 18, commonEndings: ["할게"], emojiRate: 0.1) }
        let honor = Float(msgs.filter{ $0.text.contains("요") || $0.text.contains("습니다") }.count)/Float(msgs.count)
        let avg = Int(msgs.map{ $0.text.count }.reduce(0,+)/max(1,msgs.count))
        let ends = Self.ends.map{ e in (e, msgs.filter{ $0.text.hasSuffix(e) }.count) }.sorted{ $0.1 > $1.1 }.prefix(3).map{ $0.0 }
        let emoji = Float(msgs.filter{ $0.text.unicodeScalars.contains{ $0.properties.isEmoji } }.count)/Float(msgs.count)
        return .init(honorificRatio: honor, avgLen: avg, commonEndings: ends, emojiRate: emoji)
    }
}