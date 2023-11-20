//
// Created by John Griffin on 11/11/23
//

import Foundation

public extension Optional {
    var unwrapped: Wrapped {
        get throws {
            guard let value = self else { throw OptionalError.unwrappedNil }
            return value
        }
    }

    enum OptionalError: Error {
        case unwrappedNil
    }
}
