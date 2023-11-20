//
// Created by John Griffin on 11/11/23
//

import Foundation

public extension Sequence where Element: CustomStringConvertible {
    func asStringJoined(separator: String = "") -> String {
        map(String.init).joined(separator: separator)
    }
}
