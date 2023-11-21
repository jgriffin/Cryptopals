import Cryptopals
import EulerTools
import WordTools
import XCTest

final class Set1Tests: XCTestCase {
    func testDataFromHex() throws {
        let testHexString = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
        let checkValues: [UInt8] = [73, 39, 109, 32, 107, 105, 108, 108, 105, 110, 103, 32, 121, 111, 117, 114, 32, 98, 114, 97, 105, 110, 32, 108, 105, 107, 101, 32, 97, 32, 112, 111, 105, 115, 111, 110, 111, 117, 115, 32, 109, 117, 115, 104, 114, 111, 111, 109]

        let hexValues = try testHexString.asHexValues

        XCTAssertEqual(try testHexString.asHexValues, checkValues)
        XCTAssertEqual(hexValues.asHexString, testHexString)
    }

    func testChallenge1ConvertHexToBase64() throws {
        let testHex = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
        let check = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

        let hexValues = try testHex.asHexValues
        let base64 = hexValues.asBase64String
        XCTAssertEqual(base64, check)
    }

    func testChallenge2Xor() throws {
        let testHex = "1c0111001f010100061a024b53535009181c"
        let xorHex = "686974207468652062756c6c277320657965"
        let checkHex = "746865206b696420646f6e277420706c6179"

        let testHexValues = try testHex.asHexValues
        let xorHexValues = try xorHex.asHexValues
        let result = try testHexValues.xor(xorHexValues)

        XCTAssertEqual(result.asHexString, checkHex)
    }

    func testChallenge3SingleByteXor() throws {
        let cypher = try "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736".asHexValues
        print(cypher)

        let counts = ElementCounts(cypher)
        print("\(asPercentages: counts)")

        for letter in Ascii.uppercaseLetters {
            let xored = try cypher.xor(letter)
            let message = xored.asAsciiString
            print(letter.asAsciiCharacter ?? "\(letter)", message)
        }

        try print("\nX", cypher.xor(cycled: "X".utf8).asAsciiString)
    }

    func testChallenge3Message() throws {
        let message = "ETAOIN SHRDLU"
        let messageAscii = try message.asAscii
        print(messageAscii)
        print(messageAscii.asAsciiString)

        for letter in Ascii(0) ... 126 {
            let xored = try messageAscii.xor(letter)
            print(letter.asCharacter, xored.asAsciiString)
        }
    }

    func testChallenge4() throws {
        let asciiChunks = dataFromResource("Set1Challenge4Input.txt").asAscii.split(separator: .newline)
        let chunks = try asciiChunks.map { chunk in try chunk.asHexValues }
        
        for chunk in chunks.enumerated() {
            let counts = ElementCounts(chunk.element)
            print("\(chunk.offset)\t\(chunk.element.asAsciiString)")
//            print("\(asPercentages: counts)")
        }
    }
}
