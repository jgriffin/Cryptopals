//
// Created by John Griffin on 11/22/23
//

import Cryptopals
import EulerTools
import XCTest

final class Challenge3Tests: XCTestCase {
    func testChallenge3SingleByteXor() throws {
        let wordlist = try Wordlist.mit_wordlist_10000.data.asAscii(.dropNewlines)
        let wordlistCounts = ElementCounts(wordlist.windows(ofCount: 2))

        let cypher = try "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736".asHexValues

        let letterXoredScores = CryptoTools.letterXoredScores(from: Ascii.uppercaseLetters, in: cypher)

        let mseScoreds = letterXoredScores.map { xoredScore in
            let xoredCounts = ElementCounts(xoredScore.xored.windows(ofCount: 2))
            let mse = TextEvaluator.mseExpectedScore(compare: xoredCounts, withModel: wordlistCounts)
            return (xoredScore: xoredScore, mse: mse)
        }

        mseScoreds.sorted(by: \.xoredScore.score, thenDesc: \.mse).reversed().forEach {
            print("\(letter: $0.xoredScore.letter)\t\(dotOne: $0.xoredScore.score)  \($0.mse)  \($0.xoredScore.xored.asPrintableString)")
        }

        print("\nX", cypher.xor(cycled: "X".utf8).asPrintableString)
    }

    func testChallenge3Message() throws {
        let message = "ETAOIN SHRDLU"
        let messageAscii = try message.asAscii

        let xoredScores = CryptoTools.letterXoredScores(from: Ascii.asciiValues, in: messageAscii)
        xoredScores.forEach { score in
            print(score.letter.asCharacter, score.xored.asPrintableString)
        }
    }
}
