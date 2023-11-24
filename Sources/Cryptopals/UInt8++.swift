import Algorithms

public extension [UInt8] {
    // Common AES key since it's 16 bytes - 128 bits long
    static let yellowSubmarine = "YELLOW SUBMARINE".bytes

    static func random(count: Int) -> [UInt8] {
        (0 ..< count).map { _ in UInt8.random(in: .min ... .max) }
    }
    
    func asPrintableChunks(of count: Int = 16) -> String {
        chunks(ofCount: count).map(\.asPrintableString).joined(separator: "  ")
    }
}
