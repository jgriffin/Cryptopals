//
// Created by John Griffin on 11/11/23
//

import Foundation

public extension BinaryFloatingPoint {
    var asPercent: String {
        NumberFormatter.percent.string(for: self)!
    }

    var asOneDecimal: String {
        NumberFormatter.oneDecimal.string(for: self)!
    }

    var asTwoDecimals: String {
        NumberFormatter.twoDecimals.string(for: self)!
    }
}

public extension Sequence where Element: BinaryFloatingPoint {
    /**
     Sequence string mapping elements with supplied transform
     e.g. array.string(map: \.oneDecimal)
     */
    func asString(_ transform: (Self.Element) -> String) -> String {
        "[\(map(transform).joined(separator: ", "))]"
    }
}

public extension Collection where Element: BinaryFloatingPoint {
    /**
     Squares the elements and takes the mean - typically for mean squared error
     */
    var meanSquared: Element {
        map { $0 * $0 }.reduce(0, +) / Element(count)
    }
}
