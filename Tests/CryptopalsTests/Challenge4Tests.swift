//
// Created by John Griffin on 11/22/23
//

import Cryptopals
import EulerTools
import XCTest

final class Challenge4Tests: XCTestCase {
    func testChallenge4() throws {
        let wordlist = try Wordlist.mit_wordlist_10000.data.asAscii(.newlinesToSpace)
        let wordlistCounts = ElementCounts(wordlist.windows(ofCount: 2))

        let asciiChunks = try dataFromResource("Challenge4Input.txt").asAsciiSplitNewlines()
        let chunks = try asciiChunks.map { chunk in try chunk.asHexValues }

        let cidScores = chunks.enumerated().flatMap { cid, chunk in
            CryptoTools.letterXoredScores(from: Ascii.asciiValues, in: chunk)
                .map { xScore in
                    let counts = ElementCounts(xScore.xored.windows(ofCount: 2))
                    let mse = TextEvaluator.mseExpectedScore(compare: counts, withModel: wordlistCounts)
                    return (chunkId: cid, xScore: xScore, mse: mse)
                }
        }

        cidScores.sorted(by: \.xScore.score, then: \.mse).reversed()
            .prefix(5).forEach { cidScore in
                print("\(cidScore.chunkId)\t\(cidScore.xScore)\t \(dotTwo: cidScore.mse)")
            }
    }
}
