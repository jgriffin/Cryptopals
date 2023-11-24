import Cryptopals
import CryptoSwift
import EulerTools
import XCTest

final class Challenge11Tests: XCTestCase {
    func testIsECB() throws {
        let plaintext = try String.quickBrownFox.prefix(16).cycled(times: 4).asAscii
        let cyphertext = try AES(key: .yellowSubmarine, blockMode: ECB()).encrypt(plaintext)

        let blockHashCounts = cyphertext.chunks(ofCount: 16).map(\.hashValue).elementCounts
        let isECB = blockHashCounts.countOf.values.max()! > 2
        XCTAssertTrue(isECB)
    }

    func testIsNotECB() throws {
        let plaintext = try String.quickBrownFox.prefix(16).cycled(times: 4).asAscii
        let cyphertext = try CryptoTools.encryptAES_CBC(
            key: .yellowSubmarine,
            iv: .random(count: 16),
            plaintext: plaintext
        )

        let blockHashCounts = cyphertext.chunks(ofCount: 16).map(\.hashValue).elementCounts
        let isECB = blockHashCounts.countOf.values.max()! > 2
        XCTAssertFalse(isECB)
    }

    func testEncryptionOracle() throws {
        let plaintext = try String.quickBrownFox.prefix(16).cycled(times: 4).asAscii
        let cypherAndInfos = try encryptionOracle(plaintext: plaintext, count: 10)

        cypherAndInfos.forEach { x in
            let blockHashCounts = x.cyphertext.chunks(ofCount: 16).map(\.hashValue).elementCounts
            let isECB = blockHashCounts.countOf.values.max()! > 2
            XCTAssertEqual(isECB, x.info.isECB)
        }
    }
}

extension Challenge11Tests {
    func encryptionOracle(
        plaintext: [UInt8],
        count: Int
    ) throws -> [(cyphertext: [UInt8], info: (isECB: Bool, key: [UInt8], iv: [UInt8]))] {
        let plainPlusRandom = [UInt8].random(count: .random(in: 5...10)) + plaintext + [UInt8].random(count: .random(in: 5...10))
        
        let infos = (0 ..< count).map { _ in
            (
                isECB: Bool.random(),
                key: [UInt8].random(count: 16),
                iv: [UInt8].random(count: 16)
            )
        }

        let cyphertexts = try infos.map { x in
            x.isECB != false ?
                try AES(key: x.key, blockMode: ECB()).encrypt(plainPlusRandom) :
                try CryptoTools.encryptAES_CBC(key: x.key, iv: x.iv, plaintext: plainPlusRandom)
        }

        return zip(cyphertexts, infos).map { ($0, $1) }
    }
}
