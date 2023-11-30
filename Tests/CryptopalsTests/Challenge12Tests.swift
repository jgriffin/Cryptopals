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

    static let inputByes = Data(base64Encoded: inputBase64, options: .ignoreUnknownCharacters)!.bytes

    let oracle = CryptoTools.EncryptionOracleInfo(
        isECB: true,
        prefix: [],
        suffix: inputByes
    )

    let blockLength = 16

    func testCheckBlockLength() throws {
        let blockLengthCounts = try (0 ... 40)
            .map { i in
                let cyphertext = try oracle.encrypt(plaintext: .init(repeating: .init("A"), count: i))
                return cyphertext.count
            }
            .elementCounts
        // print(blockLengthCounts)
        XCTAssertEqual(blockLengthCounts.countOf.values.max()!, blockLength)
    }

    func testPrefixFinder() throws {
        var finder = CryptoTools.ECBPrefixFinder(oracle: oracle)

        var prefix: [UInt8] = []
        while let next = try? finder.prefixAfter(prefix) {
            prefix.append(next.last!)
        }
        print(prefix.asPrintable, "Rollin' in my 5.0␤With my rag-top down so my hair can blow␤The girlies on standby waving just to say hi␤Did you stop? No, I just drove by␤")
    }
}
