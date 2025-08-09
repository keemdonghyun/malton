import Foundation

public enum TemplateGenerator {
    public static func generate(ctx: String, sims: [ScoredMessage], style: StyleProfile, n: Int = 6, tone: Tone) -> [String] {
        let honor = (tone == .POLITE) ? true : (tone == .FIRM ? false : style.honorificRatio > 0.5)
        let end = honor ? "할게요" : (style.commonEndings.first ?? "할게")
        let base = [
            "좋아요, \(extractAsk(ctx)) \(end)",
            "\(timeHint(ctx))에 \(actionHint(ctx)) \(end)",
            "지금은 어려워요. 대신 \(altHint(ctx)) \(end)",
            "확인했어요. \(shortAck(ctx)) \(end)",
            "고마워요. \(gratitudeHint(ctx)) \(end)",
            "그렇게 정리할게요. \(confirmHint(ctx)) \(end)"
        ]
        return Array(base.prefix(n))
    }
    static func extractAsk(_ s: String) -> String { s.contains("시간") ? "그 시간 괜찮아요" : "그 방향으로 진행해요" }
    static func timeHint(_ s: String) -> String { s.contains("8시") ? "8시 30분" : "내일 오전" }
    static func actionHint(_ s: String) -> String { s.contains("보내") ? "자료 보내드릴게요" : "확인 드릴게요" }
    static func altHint(_ s: String) -> String { s.contains("오늘") ? "내일로 변경해도 될까요?" : "다른 시간도 가능해요" }
    static func shortAck(_ s: String) -> String { "요청 내용 반영할게요" }
    static func gratitudeHint(_ s: String) -> String { "빠르게 알려줘서 도움이 됐어요" }
    static func confirmHint(_ s: String) -> String { "약속은 캘린더에 적어둘게요" }
}
