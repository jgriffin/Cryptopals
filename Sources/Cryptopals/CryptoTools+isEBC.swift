import Algorithms
import CryptoSwift
import EulerTools

public extension CryptoTools {
    /**
     In the EBC encoding the order of the blocks shouldn't matter, so try it both ways and see
     */
    static func isProbablyEBCEncrypted(_ cyphertext: [UInt8]) throws -> Bool? {
        let blockSize = 128 / 8
        guard cyphertext.count >= 2 * blockSize else {
            // too short to know anything
            return nil
        }

        let twoBlocks = cyphertext.chunks(ofCount: blockSize).prefix(2).map(\.asArray)
        var decryptor = try AES(key: .yellowSubmarine, blockMode: ECB()).makeDecryptor()

        let decodedForward = try twoBlocks.map { block in
            try decryptor.update(withBytes: block)
        }
        // print(decodedBlocks.map(\.asPrintableString).joined(by: .space))

        let decodedBackward = try twoBlocks.reversed().map { block in
            try decryptor.update(withBytes: block)
        }
        // print(decodedReversed.map(\.asPrintableString).joined(by: .space))

        return decodedForward.first == decodedBackward.last &&
            decodedForward.last == decodedBackward.first
    }
}
