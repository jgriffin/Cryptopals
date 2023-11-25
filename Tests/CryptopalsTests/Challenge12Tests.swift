import Cryptopals
import CryptoSwift
import EulerTools
import XCTest

final class Challenge12Tests: XCTestCase {
    static let inputBase64 = """
    Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkg
    aGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBq
    dXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUg
    YnkK
    """

    let oracle = CryptoTools.EncryptionOracleInfo(
        isECB: true,
        prefix: [],
        suffix: Data(base64Encoded: inputBase64, options: .ignoreUnknownCharacters)!.bytes
    )
    let blockLength = 16

    func testCheckBlockLength() throws {
        let blockLengthCounts = try (0 ... 40)
            .map { i in
                let cyphertext = try oracle.encrypt(plaintext: .init(repeating: .init("A"), count: i))
                return cyphertext.count
            }
            .elementCounts
        XCTAssertEqual(blockLengthCounts.countOf.values.max()!, blockLength)
    }

    func testCheckECB() {
        let repeatingCyphertext = [UInt8].quickBrownFox16.cycled(times: 4).asArray
        XCTAssertTrue(CryptoTools.isProbablyECB(repeatingCyphertext))
    }

    func testOneShort() throws {
        var finder = ECBPrefixFinder(oracle: oracle)

        var prefix: [UInt8] = []
        while true {
            guard let next = try? finder.prefixAfter(prefix) else {
                break
            }
            prefix.append(next.last!)
        }
        print(prefix.asPrintable, prefix.count)
    }

    struct ECBPrefixFinder {
        let oracle: CryptoTools.EncryptionOracleInfo
        private var blockToPrefixMap: [[UInt8].SubSequence: [UInt8]] = [:]
        private var expandedPrefixes = Set<[UInt8]>()
        private let blockLength = 16

        init(oracle: CryptoTools.EncryptionOracleInfo) {
            self.oracle = oracle
        }

        mutating func prefixAfter(_ prefix: [UInt8]) throws -> [UInt8] {
            let paddingCount = blockLength - (prefix.count + 1) % blockLength
            let padding = (paddingCount == 0 ? [] : [UInt8](repeating: .A, count: paddingCount))
            let blockIndex = (prefix.count + 1) / blockLength

            if !expandedPrefixes.contains(prefix) {
                expandedPrefixes.insert(prefix)
                try expandPrefixesAfter(prefix: prefix)
            }

            let cypher = try oracle.encrypt(plaintext: padding)
            let block = cypher.dropFirst(blockIndex * blockLength).prefix(blockLength)

            guard let nextPrefix = blockToPrefixMap[block] else {
                throw CryptoError.expectedValueMissing
            }
            return nextPrefix
        }

        private mutating func expandPrefixesAfter(
            prefix: [UInt8]
        ) throws {
            var plaintext = prefix.count + 1 >= blockLength ?
                prefix.suffix(blockLength - 1) + [.dot] :
                [UInt8](repeating: .A, count: blockLength - prefix.count - 1) + prefix + [.dot]
            assert(plaintext.count == blockLength)
            
            for ch in Ascii.asciiValues {
                // update the plaintext (last char)
                plaintext[plaintext.count - 1] = ch

                let cypher = try oracle.encrypt(plaintext: plaintext)
                let block = cypher.prefix(blockLength)
                blockToPrefixMap[block] = plaintext.suffix(prefix.count + 1).asArray
            }
        }
    }
}
