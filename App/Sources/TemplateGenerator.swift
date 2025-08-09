import Foundation
enum Tone: String { case CASUAL, POLITE, FIRM, SWEET }
enum TemplateGenerator {
    static func generate(ctx: String, sims: [ScoredMessage], style: StyleProfile, n: Int = 6, tone: Tone) -> [String] {
        let end = style.commonEndings.first ?? (tone == .POLITE ? "할게요" : "할게")
        let honor = (tone == .POLITE) ? true : (tone == .FIRM ? false : style.honorificRatio > 0.5)
        let postfix = honor ? "할게요" : end
        let base = [
            "좋아요, \(extractAsk(ctx)) \(postfix)",
            "\(timeHint(ctx))에 \(actionHint(ctx)) \(postfix)",
            "지금은 어려워요. 대신 \(altHint(ctx)) \(postfix)",
            "확인했어요. \(shortAck(ctx)) \(postfix)",
            "고마워요. \(gratitudeHint(ctx)) \(postfix)",
            "그렇게 정리할게요. \(confirmHint(ctx)) \(postfix)"
        ]
        return Array(base.prefix(n))
    }
    private static func extractAsk(_ s: String) -> String { s.contains("시간") ? "그 시간 괜찮아요" : "그 방향으로 진행해요" }
    private static func timeHint(_ s: String) -> String { s.contains("8시") ? "8시 30분" : "내일 오전" }
    private static func actionHint(_ s: String) -> String { s.contains("보내") ? "자료 보내드릴게요" : "확인 드릴게요" }
    private static func altHint(_ s: String) -> String { s.contains("오늘") ? "내일로 변경해도 될까요?" : "다른 시간도 가능해요" }
    private static func shortAck(_ s: String) -> String { "요청 내용 반영할게요" }
    private static func gratitudeHint(_ s: String) -> String { "빠르게 알려줘서 도움이 됐어요" }
    private static func confirmHint(_ s: String) -> String { "약속은 캘린더에 적어둘게요" }
}