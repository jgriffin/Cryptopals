//
// Created by John Griffin on 11/11/23
//

import EulerTools
import Foundation

public struct Analysis<Element: Hashable> {
    let frequencies: [Element: Float]

    init(_ frequencies: [Element: Float]) {
        self.frequencies = frequencies
    }

    init(_ characters: some Sequence<Element>) {
        let rawCounts = characters.elementCounts()
        let totalCount = rawCounts.map(\.value).reduce(0,+)
        self.init(rawCounts.mapValues { Float($0) / Float(totalCount) })
    }

    var descending: [Float] {
        frequencies.values.sorted().reversed()
    }

    var descendingPercent: String {
        descending.asString(\.asPercent)
    }

    /**
     returns an array of deltas between Frequencies
     if orderedByElements
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
                .map { with.frequencies[$0, default: 0] - frequencies[$0, default: 0] }
        case .elementsOfSortedValues:
            with.frequencies.sorted(by: \.value).reversed().map(\.key)
                .map { with.frequencies[$0, default: 0] - frequencies[$0, default: 0] }
        }
    }

    enum OrderedBy {
        case valuesDescending
        case elements([Element])
        case elementsOfSortedValues
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
        compareWith(.english, orderBy: .elementsOfSortedValues)
    }
}

public extension Analysis where Element == UInt8 {
    static let english = Analysis(.init(uniqueKeysWithValues:
        Analysis<Character>.english.frequencies.map { char, value in
            (char.asciiValue!, value)
        }
    ))

    func compareWithEnglish() -> [Float] {
        compareWith(.english, orderBy: .elementsOfSortedValues)
    }
}

public extension Sequence where Element: Hashable {
    func elementCounts() -> [Element: Int] {
        reduce(into: [Element: Int]()) { counts, element in
            counts[element, default: 0] += 1
        }
    }
}
