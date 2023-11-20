//
// Created by John Griffin on 11/11/23
//

import EulerTools
import Foundation

public struct Analysis<Element: Hashable> {
    /**
     Ratios get too small, especially when squared, so let's work in percentages
     */
    public typealias Percentages = [Element: Float]
    let percentages: Percentages

    init(_ percentages: Percentages) {
        self.percentages = percentages
    }

    init(_ characters: some Sequence<Element>) {
        let rawCounts = characters.elementCounts()
        let totalCount = rawCounts.map(\.value).reduce(0,+)
        self.init(rawCounts.mapValues { Float($0) / Float(totalCount) * 100 })
    }

    var descending: [Float] {
        percentages.values.sorted().reversed()
    }

    var descendingPercent: String {
        descending.asString(\.asPercent)
    }

    /**
     returns an array of deltas between percentages, orderedBy in different ways
     */
    func compareWith(
        _ with: Analysis,
        orderBy: OrderedBy
    ) -> [Float] {
        switch orderBy {
        case .valuesDescending:
            zip(with.descending, descending)
                .map { $1 - $0 }
        case let .elements(elements):
            elements
                .map { with.percentages[$0, default: 0] - percentages[$0, default: 0] }
        case .elementsOfSortedWithValues:
            with.percentages.sorted(by: \.value).reversed().map(\.key)
                .map { with.percentages[$0, default: 0] - percentages[$0, default: 0] }
        }
    }

    enum OrderedBy {
        // sort both sets of values and compare them
        case valuesDescending
        // ordered according to sequence of elements (e.g. a-z)
        case elements([Element])
        // ordered according to the elements corresponding to sorted with values
        // interesting for english letter frequency order
        case elementsOfSortedWithValues
    }
}

public extension Analysis where Element == Character {
    static let english = Analysis([
        "E": 0.111607, "A": 0.084966, "R": 0.075809, "I": 0.075448, "O": 0.071635,
        "T": 0.069509, "N": 0.066544, "S": 0.057351, "L": 0.054893, "C": 0.045388,
        "U": 0.036308, "D": 0.033844, "P": 0.031671, "M": 0.030129, "H": 0.030034,
        "G": 0.024705, "B": 0.020720, "F": 0.018121, "Y": 0.017779, "W": 0.012899,
        "K": 0.011016, "V": 0.010074, "X": 0.002902, "Z": 0.002722, "J": 0.001965,
        "Q": 0.001962,
    ])

    func compareWithEnglish() -> [Float] {
        compareWith(.english, orderBy: .elementsOfSortedWithValues)
    }
}

public extension Analysis where Element == UInt8 {
    static let english = Analysis(.init(uniqueKeysWithValues:
        Analysis<Character>.english.percentages.map { char, value in
            (char.asciiValue!, value)
        }
    ))

    func compareWithEnglish() -> [Float] {
        compareWith(.english, orderBy: .elementsOfSortedWithValues)
    }
}

public extension Sequence where Element: Hashable {
    func elementCounts() -> [Element: Int] {
        reduce(into: [Element: Int]()) { counts, element in
            counts[element, default: 0] += 1
        }
    }
}
