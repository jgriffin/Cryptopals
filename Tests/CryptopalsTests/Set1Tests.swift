@testable import Cryptopals
import EulerTools
import XCTest

final class Set1Tests: XCTestCase {
    func testDataFromHex() throws {
        let testHex = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
        let check = "733910932107105108108105110103321211111171143298114971051103210810510710132973211211110511511111011111711532109117115104114111111109"

        let data = try testHex.asHexData
        let result = data.asStringJoined()
        XCTAssertEqual(result, check)

        let resultHex = data.asHexString
        XCTAssertEqual(resultHex, testHex)
    }

    func testChallenge1ConvertHexToBase64() throws {
        let testHex = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
        let check = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

        let data = try testHex.asHexData
        let base64 = data.base64EncodedString()
        XCTAssertEqual(base64, check)
    }

    func testChallenge2Xor() throws {
        let testHex = "1c0111001f010100061a024b53535009181c"
        let xorHex = "686974207468652062756c6c277320657965"
        let checkHex = "746865206b696420646f6e277420706c6179"

        let testData = try testHex.asHexData
        let xorData = try xorHex.asHexData
        let result = try testData.xor(xorData)

        XCTAssertEqual(result.asHexString, checkHex)
    }

    func testChallenge3SingleByteXor() throws {
        let cypher = try "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736".asHexData
        print(cypher.asStringJoined())
        let analysis = FrequencyAnalysis(cypher)
        print(analysis.frequenciesDesc)

        for letter in String.uppercaseLetters.utf8 {
            let xored = try cypher.xor(letter)
            let message = try xored.asASCIIString
            print(letter, UnicodeScalar(letter), message)
        }
        
        print("\nX", try cypher.xor(cycled: "X".utf8).asASCIIString)
    }

    func testChallenge3Message() throws {
        let message = "ETAOIN SHRDLU"
        let messageData = try message.asASCII
        for letter in String.uppercaseLetters {
            let xored = try messageData.xor(letter.asciiValue.unwrapped)
            print(letter, try xored.asASCIIString)
        }
    }
    
    func testChallenge4() {
        let input = dataFromResource("Set1Challenge4Input.txt")
        let chunks = input.chunks(ofCount: 60)
        for chunk in chunks {
            let analysis = FrequencyAnalysis(chunk)
            print(analysis.frequenciesDesc)
        }
    }
}
