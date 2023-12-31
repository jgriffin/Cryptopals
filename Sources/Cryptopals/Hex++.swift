//
// Created by John Griffin on 11/11/23
//

import Algorithms
import Foundation
import WordTools

public extension Sequence<UInt8> {
    var asAsciiString: String {
        map { $0.asAsciiCharacter ?? .tilde }.asString
    }

    var asHexString: String {
        map { String($0, radix: 16) }.joined()
    }

    var asDigitString: String {
        map { String($0) }.joined()
    }

    var asBase64String: String {
        Data(self).base64EncodedString()
    }
}

public extension Collection where Element: Letter {
    var asHexValues: [UInt8] {
        get throws {
            try map { ch in
                try ch.asHexDigitValue.unwrapped
            }
            .chunks(ofCount: 2).map { chunk in
                chunk.first! << 4 + chunk.last!
            }
        }
    }
}

public extension Collection where Element: BinaryInteger {
    func xor(_ other: some Collection<Element>) throws -> [Element] {
        guard count == other.count else { throw CryptoError.mismatchedLengths }
        return zip(self, other).map { pair in pair.0 ^ pair.1 }
    }

    func xor(cycled other: some Collection<Element>) throws -> [Element] {
        zip(self, other.cycled()).map { pair in pair.0 ^ pair.1 }
    }

    func xor(_ value: Element) throws -> [Element] {
        map { $0 ^ value }
    }
}
