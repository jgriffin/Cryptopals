import Algorithms

public extension [UInt8] {
    static let preamble = String.preamble.bytes
    static let quickBrownFox = String.quickBrownFox.bytes

    // Common AES key since it's 16 bytes - 128 bits long
    static let yellowSubmarine = "YELLOW SUBMARINE".bytes
    static let preamble16 = preamble.prefix(16).asArray
    static let quickBrownFox16 = quickBrownFox.prefix(16).asArray

    static func random(count: Int) -> [UInt8] {
        (0 ..< count).map { _ in UInt8.random(in: .min ... .max) }
    }

    func asPrintableChunks(of count: Int = 16) -> String {
        chunks(ofCount: count).map(\.asPrintable).joined(separator: "  ")
    }

    func asChunkHashes(of count: Int = 16) -> String {
        "\(chunks(ofCount: count).map(\.hashValue))"
    }
}
