import Cryptopals
import EulerTools
import XCTest

final class Challenge1Tests: XCTestCase {
    func testDataFromHex() throws {
        let testHexString = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
        let checkValues: [UInt8] = [73, 39, 109, 32, 107, 105, 108, 108, 105, 110, 103, 32, 121, 111, 117, 114, 32, 98, 114, 97, 105, 110, 32, 108, 105, 107, 101, 32, 97, 32, 112, 111, 105, 115, 111, 110, 111, 117, 115, 32, 109, 117, 115, 104, 114, 111, 111, 109]

        let hexValues = try testHexString.asHexValues

        XCTAssertEqual(try testHexString.asHexValues, checkValues)
        XCTAssertEqual(hexValues.asHexCharacters, testHexString.asCharacters)
    }

    func testChallenge1ConvertHexToBase64() throws {
        let testHex = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
        let check = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

        let hexValues = try testHex.asHexValues
        let base64 = hexValues.asBase64String
        XCTAssertEqual(base64, check)
    }

    func testChallenge2Xor() throws {
        let testHex = try "1c0111001f010100061a024b53535009181c".asAscii
        let xorHex = try "686974207468652062756c6c277320657965".asAscii
        let checkHex = try "746865206b696420646f6e277420706c6179".asAscii

        let testHexValues = try testHex.asHexValues
        let xorHexValues = try xorHex.asHexValues
        let result = testHexValues.xor(xorHexValues)

        XCTAssertEqual(result.asHexAscii, checkHex)
    }
}
