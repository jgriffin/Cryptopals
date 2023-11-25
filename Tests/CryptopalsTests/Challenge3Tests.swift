//
// Created by John Griffin on 11/22/23
//

import Cryptopals
import EulerTools
import XCTest

final class Challenge3Tests: XCTestCase {
    func testChallenge3SingleByteXor() throws {
        let cypher = try "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736".asHexValues

        let xorScores = CryptoTools.letterXoredScores(from: Ascii.uppercaseLetters, in: cypher)
        xorScores.forEach { x in
            print("\(letter: x.letter)\t\(x.englishness)\t\(x.xored.asPrintable)")
        }

        print("\nX", cypher.xor(cycled: "X".utf8).asPrintable)
    }

    func testChallenge3Message() throws {
        let message = "ETAOIN SHRDLU"
        let messageAscii = try message.asAscii

        let xoredScores = CryptoTools.letterXoredScores(from: Ascii.asciiValues, in: messageAscii)
        xoredScores.forEach { score in
            print(score.letter.asCharacter, score.xored.asPrintable)
        }
    }
}
