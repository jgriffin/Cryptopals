//
// Created by John Griffin on 11/11/23
//

import CommonCrypto
import Foundation

public enum CryptoError: Error {
    case notYetImplemented
    case invalidASCII
    case invalidHex
    case mismatchedLengths

    case invalidKeyLength
    case invalidInitializationVector
    case invalidPadding
    case encryptionError(CCCryptorStatus)
    case decryptionError(CCCryptorStatus)

    case expectedValueMissing
}
