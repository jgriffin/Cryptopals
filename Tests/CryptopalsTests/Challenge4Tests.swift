//
// Created by John Griffin on 11/22/23
//

import Cryptopals
import EulerTools
import XCTest

final class Challenge4Tests: XCTestCase {
    func testChallenge4() throws {
        let wordlist = try Wordlist.mit_wordlist_10000.data.asAscii(.newlinesToSpace)
        let wordlistCounts = ElementCounts(wordlist)

        let asciiChunks = try dataFromResource("Challenge4Input.txt").asAsciiSplitNewlines()
        let chunks = try asciiChunks.map { chunk in try chunk.asHexValues }

        let cidScores = chunks.enumerated().flatMap { cid, chunk in
            CryptoTools.letterXoredScores(from: Ascii.asciiValues, in: chunk)
                .map { xScore in
                    let counts = ElementCounts(xScore.xored).map(.lowercasedOrPass)
                    let chi2 = TextEvaluator.chiSquaredDistance(
                        compare: counts,
                        withModel: wordlistCounts
                    )
                    return (chunkId: cid, xScore: xScore, chi2: chi2)
                }
        }

        cidScores.sorted(by: \.chi2)
            .prefix(.max).forEach { cidScore in
                print("\(cidScore.chunkId)\t\(cidScore.xScore)\t \(dotTwo: cidScore.chi2)")
            }
    }
}
