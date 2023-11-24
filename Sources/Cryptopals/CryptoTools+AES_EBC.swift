//
// Created by John Griffin on 11/22/23
//

import CommonCrypto
import EulerTools


public extension CryptoTools {
    /// Encrypts data using AES with PKCS#7 padding in CBC mode.
    ///
    /// - note: PKCS#7 padding is also known as PKCS#5 padding.
    ///
    /// - Parameters:
    ///   - key: The key to encrypt with; must be a supported size (128, 192, 256).
    ///   - iv: The initialisation vector; must be of size 16.
    ///   - plaintext: The data to encrypt; the PKCS#7 padding means there are no
    ///     constraints on its length.
    /// - Returns: The encrypted data; it’s length with always be an even multiple of 16.

    private static func encryptAES_ECB(
        key: [UInt8],
        iv: [UInt8],
        plaintext: [UInt8]
    ) throws -> [UInt8] {
        guard [128, 192, 256].contains(key.count * 8) else { throw CryptoError.invalidKeyLength }
        guard iv.count == kCCBlockSizeAES128 else { throw CryptoError.invalidInitializationVector }

        var cyphertext = [UInt8](repeating: 0, count: plaintext.count + kCCBlockSizeAES128)
        var cyphertextCount = 0

        let err = CCCrypt(
            CCOperation(kCCEncrypt),
            CCAlgorithm(kCCAlgorithmAES),
            CCOptions(kCCOptionECBMode), // kCCOptionPKCS7Padding
            key, key.count,
            iv,
            plaintext, plaintext.count,
            &cyphertext, cyphertext.count,
            &cyphertextCount
        )

        guard err == kCCSuccess else {
            throw CryptoError.encryptionError(err)
        }

        // The cyphertext can expand by up to one block but it doesn’t always use the full block,
        // so trim off any unused bytes.
        assert(cyphertextCount <= cyphertext.count)
        cyphertext.removeLast(cyphertext.count - cyphertextCount)
        assert(cyphertext.count.isMultiple(of: kCCBlockSizeAES128))

        return cyphertext
    }

    private static func ensurePaddedForECB(_ plaintext: inout [UInt8]) {
        let paddingCount = kCCBlockSizeAES128 - plaintext.count % kCCBlockSizeAES128

        guard paddingCount != 0 else { return }
        plaintext += Array(repeating: UInt8(paddingCount), count: paddingCount)
    }

    private static func decryptAES_ECB(
        key: [UInt8],
        iv: [UInt8],
        cyphertext: [UInt8]
    ) throws -> [UInt8] {
        guard [128, 192, 256].contains(key.count * 8) else { throw CryptoError.invalidKeyLength        }
        guard iv.count == 16 else {throw CryptoError.invalidInitializationVector }

        // Padding can expand the data on encryption, but on decryption the data can
        // only shrink so we use the cyphertext size as our plaintext size.

        var plaintext = [UInt8](repeating: 0, count: cyphertext.count)
        var plaintextCount = 0

        let err = CCCrypt(
            CCOperation(kCCDecrypt),
            CCAlgorithm(kCCAlgorithmAES),
            CCOptions(kCCOptionECBMode), // kCCOptionPKCS7Padding
            key, key.count,
            iv,
            cyphertext, cyphertext.count,
            &plaintext, plaintext.count,
            &plaintextCount
        )

        guard err == kCCSuccess else {
            throw CryptoError.decryptionError(err)
        }

        assert(plaintextCount <= plaintext.count)
        plaintext.removeLast(plaintext.count - plaintextCount)

        return plaintext
    }
}

// MARK: - https://developer.apple.com/forums/thread/687212

///// Encrypts data using AES with PKCS#7 padding in CBC mode.
/////
///// - note: PKCS#7 padding is also known as PKCS#5 padding.
/////
///// - Parameters:
/////   - key: The key to encrypt with; must be a supported size (128, 192, 256).
/////   - iv: The initialisation vector; must be of size 16.
/////   - plaintext: The data to encrypt; the PKCS#7 padding means there are no
/////     constraints on its length.
///// - Returns: The encrypted data; it’s length with always be an even multiple of 16.
//
// func QCCAESPadCBCEncrypt(key: [UInt8], iv: [UInt8], plaintext: [UInt8]) throws -> [UInt8] {
//
//    // The key size must be 128, 192, or 256.
//    //
//    // The IV size must match the block size.
//
//    guard
//        [kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256].contains(key.count),
//        iv.count == kCCBlockSizeAES128
//    else {
//        throw QCCError(code: kCCParamError)
//    }
//
//    // Padding can expand the data, so we have to allocate space for that.  The
//    // rule for block cyphers, like AES, is that the padding only adds space on
//    // encryption (on decryption it can reduce space, obviously, but we don't
//    // need to account for that) and it will only add at most one block size
//    // worth of space.
//
//    var cyphertext = [UInt8](repeating: 0, count: plaintext.count + kCCBlockSizeAES128)
//    var cyphertextCount = 0
//    let err = CCCrypt(
//        CCOperation(kCCEncrypt),
//        CCAlgorithm(kCCAlgorithmAES),
//        CCOptions(kCCOptionPKCS7Padding),
//        key, key.count,
//        iv,
//        plaintext, plaintext.count,
//        &cyphertext, cyphertext.count,
//        &cyphertextCount
//    )
//    guard err == kCCSuccess else {
//        throw QCCError(code: err)
//    }
//
//    // The cyphertext can expand by up to one block but it doesn’t always use the full block,
//    // so trim off any unused bytes.
//
//    assert(cyphertextCount <= cyphertext.count)
//    cyphertext.removeLast(cyphertext.count - cyphertextCount)
//    assert(cyphertext.count.isMultiple(of: kCCBlockSizeAES128))
//
//    return cyphertext
// }
//
///// Decrypts data that was encrypted using AES with PKCS#7 padding in CBC mode.
/////
///// - note: PKCS#7 padding is also known as PKCS#5 padding.
/////
///// - Parameters:
/////   - key: The key to encrypt with; must be a supported size (128, 192, 256).
/////   - iv: The initialisation vector; must be of size 16.
/////   - cyphertext: The encrypted data; it’s length must be an even multiple of
/////     16.
///// - Returns: The decrypted data.
//
// func QCCAESPadCBCDecrypt(key: [UInt8], iv: [UInt8], cyphertext: [UInt8]) throws -> [UInt8] {
//
//    // The key size must be 128, 192, or 256.
//    //
//    // The IV size must match the block size.
//    //
//    // The ciphertext must be a multiple of the block size.
//
//    guard
//        [kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256].contains(key.count),
//        iv.count == kCCBlockSizeAES128,
//        cyphertext.count.isMultiple(of: kCCBlockSizeAES128)
//    else {
//        throw QCCError(code: kCCParamError)
//    }
//
//    // Padding can expand the data on encryption, but on decryption the data can
//    // only shrink so we use the cyphertext size as our plaintext size.
//
//    var plaintext = [UInt8](repeating: 0, count: cyphertext.count)
//    var plaintextCount = 0
//    let err = CCCrypt(
//        CCOperation(kCCDecrypt),
//        CCAlgorithm(kCCAlgorithmAES),
//        CCOptions(kCCOptionPKCS7Padding),
//        key, key.count,
//        iv,
//        cyphertext, cyphertext.count,
//        &plaintext, plaintext.count,
//        &plaintextCount
//    )
//    guard err == kCCSuccess else {
//        throw QCCError(code: err)
//    }
//
//    // Trim any unused bytes off the plaintext.
//
//    assert(plaintextCount <= plaintext.count)
//    plaintext.removeLast(plaintext.count - plaintextCount)
//
//    return plaintext
// }
//
///// Wraps `CCCryptorStatus` for use in Swift.
//
// struct QCCError: Error {
//    var code: CCCryptorStatus
// }
//
// extension QCCError {
//    init(code: Int) {
//        self.init(code: CCCryptorStatus(code))
//    }
// }
