import Foundation
final class EmbedderTF {
    static let shared = EmbedderTF()
    func embed(_ text: String) -> [Float] { // hash fallback
        var v = [Float](repeating: 0, count: 256)
        for b in text.utf8 { v[Int(b) % 256] += 1 }
        var norm: Float = 0; for x in v { norm += x*x }
        norm = max(1e-6, sqrt(norm))
        for i in 0..<v.count { v[i] /= norm }
        return v
    }
}