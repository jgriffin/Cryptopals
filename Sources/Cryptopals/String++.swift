//
// Created by John Griffin on 11/11/23
//

import Foundation

public extension String {
    var asHexData: Data {
        get throws {
            try chunks(ofCount: 2).reduce(into: Data()) { partialResult, chunk in
                let value = try UInt8(chunk, radix: 16).unwrapped
                partialResult.append(value)
            }
        }
    }

    var asASCII: Data {
        get throws {
            try Data(self.map { try $0.asciiValue.unwrapped })
        }
    }

    static let uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let lowerecaseLetters = "abcdefghijklmnopqrstuvwxyz"
}
