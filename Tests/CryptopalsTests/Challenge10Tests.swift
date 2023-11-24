import Cryptopals
import CryptoSwift
import EulerTools
import XCTest

final class Challenge10Tests: XCTestCase {
    func testChallenge9() {
        let block = "YELLOW SUBMARINE".bytes
        let check = "YELLOW SUBMARINE\u{04}\u{04}\u{04}\u{04}".bytes

        let pkcs7Padded = CryptoTools.paddedPKCS7(block, blockSize: 20)
        XCTAssertEqual(pkcs7Padded, check)
    }

    func testCBCEncodeDecode() throws {
        let plaintext = try String.preamble.asAscii
        let key = try "YELLOW SUBMARINE".asAscii
        let iv = [UInt8](repeating: 1, count: 16)

        let cyphertext = try CryptoTools.encryptAES_CBC(
            key: key,
            iv: iv,
            plaintext: plaintext
        )

        let roundtrip = try CryptoTools.decryptAES_CBC(
            key: key,
            iv: iv,
            cyphertext: cyphertext
        )

        XCTAssertEqual(roundtrip, plaintext)
    }

    func testCBCDecode() throws {
        let cyphertext = try Data(base64Encoded:
            Self.resourceData("Challenge10Input.txt"),
            options: .ignoreUnknownCharacters).unwrapped.bytes

        let key = try "YELLOW SUBMARINE".asAscii
        let iv = [UInt8](repeating: 0, count: 16)

        let plaintext = try CryptoTools.decryptAES_CBC(
            key: key,
            iv: iv,
            cyphertext: cyphertext
        )
        XCTAssertEqual(plaintext.prefix(30).asPrintableString, "I'm back and I'm ringin' the b")
    }
}
