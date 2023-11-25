import Cryptopals
import CryptoSwift
import EulerTools
import XCTest

final class Challenge8Tests: XCTestCase {
    let cyphertexts = try! resourceData("Challenge8Input.txt").asAsciiSplitNewlines()
        .map { try $0.asHexValues }

    func testLoadChallenge() throws {
        XCTAssertEqual(cyphertexts.count, 204)
        XCTAssertTrue(cyphertexts.allSatisfy { $0.count == 160 })
    }

    func testYellowSubmarine() throws {
        let key = try "YELLOW SUBMARINE".asAscii
        let aes = try AES(key: key, blockMode: ECB())

        let plaintexts = cyphertexts.enumerated()
            .compactMap { offset, cyphertext -> (offset: Int, plaintext: [UInt8], englishness: Englishness)? in
                guard let plaintext = try? aes.decrypt(cyphertext),
                      let englishness = Englishness(minTextual: 0, plaintext)
                else {
                    return nil
                }

                return (offset, plaintext, englishness)
            }

        plaintexts.sorted(by: \.englishness).prefix(5).forEach { x in
            print("\(x.offset)\t \(x.englishness)\t\(x.plaintext.asPrintable)")
        }
    }

    func testKeysizeDistances() {
        let distances = cyphertexts.enumerated().map { offset, cyphertext in
            (offset, CryptoTools.normHammingForKeysizes(cyphertext))
        }
        distances.forEach { offset, distances in
            print("\(offset)\t \(distances.prefix(5).map { "\($0.keysize) \(twoDotTwo: $0.meanNormDistance)" }.joined(separator: "\t"))")
        }
    }

    func testStacked() {
        let chunkPrefixes = cyphertexts.enumerated().map { offset, cyphertext in
            let prefixes = cyphertext.chunks(ofCount: 128 / 8).prefix(50).sorted(by: isSequenceOrderedBefore)
            let adjacents = prefixes.adjacentPairs().filter { $0.0 == $0.1 }.map(\.0)
            return (offset: offset, repeats: adjacents)
        }
        chunkPrefixes.filter { !$0.1.isEmpty }.forEach { offset, stacked in
            print("\(offset)\n\(stacked.map(\.asPrintable).joinedByNewlines)")
        }
    }
}
