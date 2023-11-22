//
// Created by John Griffin on 11/22/23
//

import Cryptopals
import EulerTools
import XCTest

final class Challenge5Tests: XCTestCase {
    func testChallenge5RepeatingXor() throws {
        let key = try "ICE".asAscii

        let message = try """
        Burning 'em, if you ain't quick and nimble
        I go crazy when I hear a cymbal
        """.asAscii

        let check = try """
        0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272
        a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f
        """.asAscii

        let encoded = message.xor(cycled: key).asHexAscii
        print(encoded.asPrintableString)
        print(check.asPrintableString)

        XCTAssertEqual(encoded, check.filter { $0 != .newline })
    }
}
