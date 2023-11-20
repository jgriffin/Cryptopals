//
// Created by John Griffin on 11/11/23
//

import Algorithms
import Foundation

public extension Sequence<UInt8> {
    var asHexString: String {
        map { String($0, radix: 16) }.joined()
    }
}

public extension Data {

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
