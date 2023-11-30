@testable import Cryptopals
import XCTest

final class ECBPrefixFinderTests: XCTestCase {
    typealias CT = CryptoTools

    func testShiftForPrefix() {
        let oracle = CT.EncryptionOracleInfo(
            isECB: true,
            prefix: [],
            suffix: []
        )
        let finder = CT.ECBPrefixFinder(oracle: oracle)

        let tests: [(prefix: Int, padding: Int, targetBlockIndex: Int)] = [
            (0, 15, 0),
            (1, 14, 0),
            (15, 0, 0),
            (16, 15, 1),
            (17, 14, 1),
        ]

        for test in tests {
            let shift = finder.shiftForPrefix(prefixOf(test.prefix))
            XCTAssertEqual(shift.padding, test.padding)
            XCTAssertEqual(shift.targetBlockIndex, test.targetBlockIndex)
        }
    }

    private func prefixOf(_ count: Int) -> [UInt8] {
        (0 ..< UInt8(count)).map { i in .A + i }.asArray
    }
}
