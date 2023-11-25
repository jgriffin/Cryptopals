//
// Created by John Griffin on 11/21/23
//

import Cryptopals
import EulerTools
import XCTest

final class Challenge6Tests: XCTestCase {
    func testHammingDistance() throws {
        let source = try "this is a test".asAscii
        let destination = try "wokka wokka!!!".asAscii
        let check = 37

        let result = HammingDistance.bitsBetween(source, destination)
        XCTAssertEqual(result, check)
    }

    func testExample() throws {
        let plaintext = try String.preamble.asAscii
        let key = try "xor".asAscii
        let encoded = plaintext.xor(cycled: key)

        let blockScores = CryptoTools.blockLetterXoredScores(from: Ascii.lowercaseLetters, keysize: 3, input: encoded)
        print(blockScores.map(\.description).joinedByNewlines)

        let topLetters = blockScores.map(\.topLetters)

        let keyCandidates = CartesianProduct(topLetters).map { $0 }
        print(keyCandidates.map(\.asPrintable).joined(by: .space).asString)

//        let topKey = blockScores.map { $0.xorScores.first?.letter ?? .underscore }
//        XCTAssertEqual(topKey.asPrintableString, key.asPrintableString)
    }

    func testChallenge() throws {
        let cypherBase64Data = try Self.resourceData("Challenge6Input.txt")
        let cypher = Data(base64Encoded: cypherBase64Data, options: .ignoreUnknownCharacters)!.asArray
        // print("\ncypher prefix:", cypher.prefix(50).asPrintableString)

        let keysizes = CryptoTools.normHammingForKeysizes(cypher)
        // print("\nkey\tNorm Distance")
        // keysizes.prefix(5).forEach { print("\($0.keysize)\t\($0.meanNormDistance)") }

        let keysizeBlockScores = keysizes.prefix(3).map(\.keysize).map { keysize in
            let blockScores = CryptoTools.blockLetterXoredScores(
                from: Ascii.asciiValues,
                keysize: keysize,
                withMinTextualScore: 0.9,
                input: cypher
            )

            return (keysize: keysize, blockScores: blockScores)
        }

        for (keysize, blockScores) in keysizeBlockScores {
            print("keysize \(keysize)")
            let keyCandidates = CartesianProduct(blockScores.map(\.topLetters)).map { $0 }
            keyCandidates.prefix(5).forEach { key in
                print(key.asPrintable)
            }

            if let key = keyCandidates.first {
                print(cypher.xor(cycled: key).asCharacters.asString)
            }
        }
    }

    func testChallengeKeysize29() throws {
        let cypherBase64Data = try Self.resourceData("Challenge6Input.txt")
        let cypher = Data(base64Encoded: cypherBase64Data, options: .ignoreUnknownCharacters)!.asArray

        let keysize = 29
        let blockScores = CryptoTools.blockLetterXoredScores(
            from: Ascii.asciiValues,
            keysize: 29,
            withMinTextualScore: 0.9,
            input: cypher
        )

        print("keysize: \(keysize)\n\(blockScores.map(\.description).joinedByNewlines)\n")
    }
}
