//
// Created by John Griffin on 11/11/23
//

import CommonCrypto
import Foundation

enum CryptoError: Error {
    case invalidASCII
    case invalidHex
    case mismatchedLengths
    case invalidParameter(String)
    case encryptionError(CCCryptorStatus)
    case decryptionError(CCCryptorStatus)
}
