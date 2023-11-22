//
// Created by John Griffin on 11/22/23
//

import EulerTools

public enum CryptoTools {
    // MARK: normalizedHammingDisance

    public static func normalizedDistanceForKeysizes(
        keysizes: [Int] = (1 ... 40).asArray,
        _ input: [Ascii]
    ) -> [(keysize: Int, meanNormDistance: Float)] {
        keysizes
            .map { keysize in
                let chunks = input.chunks(ofCount: keysize)
                let distances = chunks.windows(ofCount: 2)
                    .prefix(4)
                    .map { window in
                        HammingDistance.bitsBetween(window.first!, window.last!)
                    }
                let meanDistance = Float(distances.reduce(0,+)) / Float(keysize)
                return (keysize: keysize, meanNormDistance: meanDistance)
            }
            .sorted(by: \.meanNormDistance)
    }

    // MARK: XOR block score

    public struct LetterXoredScore: CustomStringConvertible {
        public let letter: Ascii
        public let score: Float
        public let xored: [Ascii]

        public var description: String {
            "\(letter: letter)  \(dotOne: score)  \(xored.prefix(20).asPrintableString)"
        }
    }

    public static func letterXoredScores(
        from letters: [Ascii],
        withMinTextualScore: Float = 0.9,
        in sample: some Collection<Ascii>
    ) -> [LetterXoredScore] {
        letters.lazy
            .map { letter in
                let xored = sample.map { $0 ^ letter }
                let score = TextEvaluator.textualLettersScore(xored)
                return LetterXoredScore(letter: letter, score: score, xored: xored)
            }
            .filter { $0.score >= withMinTextualScore }
            .sorted(by: \.score).reversed()
    }

    public struct BlockLetterXoredScores: CustomStringConvertible {
        public let keysize: Int
        public let blockId: Int
        public let xorScores: [LetterXoredScore]

        public init(keysize: Int, blockId: Int, xoredScores: [LetterXoredScore]) {
            self.keysize = keysize
            self.blockId = blockId
            self.xorScores = xoredScores
        }

        public var topLetters: [Ascii] {
            xorScores.map(\.letter)
        }
        
        public var description: String {
            "block \(blockId):\t \(xorScores.prefix(5).map(\.description).joined(separator: "\t"))"
        }
    }

    public static func blockLetterXoredScores(
        from values: [Ascii],
        keysize: Int,
        withMinTextualScore: Float = 0.9,
        input: [Ascii]
    ) -> [BlockLetterXoredScores] {
        let transposedBlocks = CryptoTools.transposedBlocks(keysize: keysize, input: input)

        return transposedBlocks.enumerated().map { blockId, block -> BlockLetterXoredScores in
            let xoredScores = letterXoredScores(
                from: values,
                withMinTextualScore: withMinTextualScore,
                in: block
            )

            return BlockLetterXoredScores(
                keysize: keysize,
                blockId: blockId,
                xoredScores: xoredScores
            )
        }
    }

    public static func transposedBlocks(keysize: Int, input: [UInt8]) -> [[UInt8]] {
        let transposedIndices = transposedBlockIndices(keysize: keysize, inputLength: input.count)
        return transposedIndices.map { $0.map { input[$0] } }
    }

    static func transposedBlockIndices(keysize: Int, inputLength: Int) -> [[Int]] {
        (0 ..< keysize).map { i in
            stride(from: i, to: inputLength, by: keysize).map { $0 }
        }
    }
}
