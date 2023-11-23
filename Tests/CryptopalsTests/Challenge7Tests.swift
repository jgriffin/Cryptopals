import Cryptopals
import EulerTools
import CryptoSwift
import XCTest

final class Challenge7Tests: XCTestCase {
    func testAESEncrypt() throws {
        let key = try "YELLOW SUBMARINE".asAscii
        let plaintext = try String.quickBrownFox.asAscii

        let aes = try AES(key: key, blockMode: ECB())
        let cyphertext = try aes.encrypt(plaintext)
        print(cyphertext.asPrintableString)

        let roundtrip = try aes.decrypt(cyphertext)

        XCTAssertEqual(roundtrip, plaintext)
    }

    func testLoadChallenge() throws {
        let cypherBase64 = try Self.resourceData("Challenge7Input.txt")
        let cyphertext = try Data(base64Encoded: cypherBase64, options: .ignoreUnknownCharacters).unwrapped.asArray
        let key = try "YELLOW SUBMARINE".asAscii

        let aes = try AES(key: key, blockMode: ECB())
        let plaintext = try aes.decrypt(cyphertext)

        print(plaintext.prefix(20).asPrintableString, "I'm back and I'm rin")
        print(plaintext.suffix(20).asPrintableString, "at funky music ␤····")
    }
}
