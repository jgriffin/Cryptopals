import Cryptopals
import EulerTools
import XCTest

final class Challenge7Tests: XCTestCase {
    func testAESEncrypt() throws {
        let key = try "YELLOW SUBMARINE".asAscii
        let iv = [UInt8](repeating: 0, count: 16)
        var plaintext = try String.quickBrownFox.asAscii
        CryptoTools.ensurePaddedForECB(&plaintext)
        XCTAssertEqual(plaintext.suffix(4), [4, 4, 4, 4])

        let cyphertext = try CryptoTools.encryptAES_ECB(
            key: key,
            iv: iv,
            plaintext: plaintext
        )

        print(cyphertext.asPrintableString)

        let roundtrip = try CryptoTools.decryptAES_ECB(
            key: key,
            iv: iv,
            cyphertext: cyphertext
        )

        XCTAssertEqual(roundtrip, plaintext)
        XCTAssertEqual(roundtrip.suffix(4), [4,4,4,4])
    }

    func testLoadChallenge() throws {
        let cypherBase64 = try Self.resourceData("Challenge7Input.txt")
        let cyphertext = try Data(base64Encoded: cypherBase64, options: .ignoreUnknownCharacters).unwrapped.asArray
        let key = try "YELLOW SUBMARINE".asAscii
        let iv = [UInt8](repeating: 0, count: 16)

        let plaintext = try CryptoTools.decryptAES_ECB(
            key: key,
            iv: iv,
            cyphertext: cyphertext
        )

        print(plaintext.prefix(20).asPrintableString, "I'm back and I'm rin")
        print(plaintext.suffix(20).asPrintableString, "at funky music ␤····")
    }
}
