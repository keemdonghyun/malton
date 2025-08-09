import Foundation

enum TextClean {
    static let email = try! NSRegularExpression(pattern: "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    static let phone = try! NSRegularExpression(pattern: "\\b(01[0-9]-?\\d{3,4}-?\\d{4})\\b")
    static let account = try! NSRegularExpression(pattern: "\\b\\d{2,3}-\\d{2,6}-\\d{2,6}\\b")
    static func clean(_ s: String) -> String {
        var out = s.trimmingCharacters(in: .whitespacesAndNewlines)
        out = out.replacingOccurrences(of: "\n+", with: "\n", options: .regularExpression)
        out = email.stringByReplacingMatches(in: out, options: [], range: NSRange(location: 0, length: out.utf16.count), withTemplate: "<email>")
        out = phone.stringByReplacingMatches(in: out, options: [], range: NSRange(location: 0, length: out.utf16.count), withTemplate: "<phone>")
        out = account.stringByReplacingMatches(in: out, options: [], range: NSRange(location: 0, length: out.utf16.count), withTemplate: "<account>")
        return out
    }
}