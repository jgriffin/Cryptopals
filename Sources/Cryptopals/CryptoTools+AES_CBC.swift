//
// Created by John Griffin on 11/23/23
//

import Algorithms
import CryptoSwift

public extension CryptoTools {
    static func encryptAES_CBC(
        key: [UInt8],
        iv: [UInt8],
        plaintext: [UInt8]
    ) throws -> [UInt8] {
        let blockSize = 128/8
        guard key.count == blockSize else { throw CryptoError.invalidKeyLength }
        guard iv.count == blockSize else { throw CryptoError.invalidInitializationVector }

        let plaintext = paddedPKCS7(plaintext, blockSize: blockSize)
        var encryptor = try AES(key: key, blockMode: ECB()).makeEncryptor()

        var prev = iv[...]
        let cypherText = try plaintext.chunks(ofCount: blockSize)
            .reduce(into: [UInt8]()) { result, plainBlock in
                let xoredBlock = zip(plainBlock, prev).map(^)
                let cypherBlock = try encryptor.update(withBytes: xoredBlock)
                prev = cypherBlock[...]
                result += cypherBlock
            }

        return cypherText
    }

    static func decryptAES_CBC(
        key: [UInt8],
        iv: [UInt8],
        cyphertext: [UInt8]
    ) throws -> [UInt8] {
        let blockSize = 128/8
        guard key.count == blockSize else { throw CryptoError.invalidKeyLength }
        guard iv.count == blockSize else { throw CryptoError.invalidInitializationVector }

        var decryptor = try AES(key: key, blockMode: ECB()).makeDecryptor()

        var prev = iv[...]
        let plaintext = try cyphertext.chunks(ofCount: blockSize)
            .reduce(into: [UInt8]()) { result, cypherBlock in
                assert(cypherBlock.count == prev.count)
                let xoredBlock = try decryptor.update(withBytes: cypherBlock)
                result += zip(xoredBlock, prev).map(^)
                prev = cypherBlock[...]
            }

        return unpaddedPKCS7(plaintext, blockSize: blockSize)
    }
}
