import Algorithms
import CryptoSwift
import EulerTools

public extension CryptoTools {
//    static func ecbBlockForPrefix(_ prefix: [[UInt8]], cryptor: ([Uint])) throws -> [UInt8]
    
    /**
     In the EBC encoding the order of the blocks shouldn't matter, so try it both ways and see
     */
    static func isProbablyECB(_ cyphertext: [UInt8]) -> Bool {
        let blockHashCounts = cyphertext.chunks(ofCount: 16).map(\.hashValue).elementCounts
        let isECB = blockHashCounts.countOf.values.max()! > 2
        return isECB
    }
}
