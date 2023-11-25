//
// Created by John Griffin on 11/24/23
//

import CryptoSwift

public extension CryptoTools {
    struct EncryptionOracleInfo {
        public let isECB: Bool
        public let key: [UInt8]
        public let iv: [UInt8]
        public let prefix: [UInt8]
        public let suffix: [UInt8]

        public init(
            isECB: Bool = .random(),
            key: [UInt8] = .random(count: 16),
            iv: [UInt8] = .random(count: 16),
            prefix: [UInt8] = .random(count: .random(in: 5...10)),
            suffix: [UInt8] = .random(count: .random(in: 5...10))
        ) {
            self.isECB = isECB
            self.key = key
            self.iv = iv
            self.prefix = prefix
            self.suffix = suffix
        }

        public func encrypt(plaintext: [UInt8]) throws -> [UInt8] {
            let plainPlusRandom = prefix + plaintext + suffix
            if isECB {
                return try AES(key: key, blockMode: ECB()).encrypt(plainPlusRandom)
            } else {
                return try CryptoTools.encryptAES_CBC(key: key, iv: iv, plaintext: plainPlusRandom)
            }
        }
    }

    static func encryptionOracle(
        plaintext: [UInt8],
        count: Int
    ) throws -> [(cyphertext: [UInt8], info: EncryptionOracleInfo)] {
        try (0 ..< count).map { _ in
            let info = EncryptionOracleInfo()
            let cyphertext = try info.encrypt(plaintext: plaintext)
            return (cyphertext, info)
        }
    }
}
