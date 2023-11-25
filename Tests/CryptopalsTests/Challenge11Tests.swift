import Cryptopals
import CryptoSwift
import EulerTools
import XCTest

final class Challenge11Tests: XCTestCase {
    func testIsECB() throws {
        let plaintext = try String.quickBrownFox.prefix(16).cycled(times: 4).asAscii
        let cyphertext = try AES(key: .yellowSubmarine, blockMode: ECB()).encrypt(plaintext)

        XCTAssertTrue(CryptoTools.isProbablyECB(cyphertext))
    }

    func testIsNotECB() throws {
        let plaintext = try String.quickBrownFox.prefix(16).cycled(times: 4).asAscii
        let cyphertext = try CryptoTools.encryptAES_CBC(
            key: .yellowSubmarine,
            iv: .random(count: 16),
            plaintext: plaintext
        )

        XCTAssertFalse(CryptoTools.isProbablyECB(cyphertext))
    }

    func testEncryptionOracle() throws {
        let plaintext = try String.quickBrownFox.prefix(16).cycled(times: 4).asAscii
        let cypherAndInfos = try CryptoTools.encryptionOracle(plaintext: plaintext, count: 10)

        cypherAndInfos.forEach { x in
            let isECB = CryptoTools.isProbablyECB(x.cyphertext)
            XCTAssertEqual(isECB, x.info.isECB)
        }
    }
}

