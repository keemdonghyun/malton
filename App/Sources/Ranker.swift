import Foundation
enum Ranker {
    static let banned = ["계좌","주민등록","카드번호"]
    static func rank(_ cands: [String]) -> [String] {
        let scored = cands.compactMap { t -> (String, Float)? in
            let len: Float = 1 - min(1, Float(abs(t.count - 24))/24)
            let ban: Float = banned.first(where: { t.contains($0) }) != nil ? -1 : 0
            let s = len + ban
            return s > 0 ? (t,s) : nil
        }.sorted { $0.1 > $1.1 }
        return scored.map { $0.0 }
    }
}