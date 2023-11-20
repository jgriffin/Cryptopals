//
// Created by John Griffin on 11/11/23
//

import Algorithms
import Foundation
import WordTools

public typealias Hex = UInt8

public extension Collection<Letter> {
    var asHex: [Hex] {
        get throws {
            try chunks(ofCount: 2).map { chunk in try Hex(chunk, radix: 16).unwrapped }
        }
    }
}

public extension Data {
    var asHexString: String {
        map { String($0, radix: 16) }.joined()
    }

    func xor(_ other: Data) throws -> Data {
        guard count == other.count else { throw CryptoError.mismatchedLengths }
        return zip(self, other).reduce(into: Data()) { partialResult, pair in
            partialResult.append(pair.0 ^ pair.1)
        }
    }

    func xor(cycled other: some Collection<Element>) throws -> Data {
        zip(self, other.cycled()).reduce(into: Data()) { partialResult, pair in
            partialResult.append(pair.0 ^ pair.1)
        }
    }

    func xor(_ value: Element) throws -> Data {
        reduce(into: Data()) { partialResult, element in
            partialResult.append(element ^ value)
        }
    }
}
