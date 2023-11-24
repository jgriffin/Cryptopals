// 
// Created by John Griffin on 11/23/23
//

import Foundation

public extension CryptoTools {
    static func paddedPKCS7(_ block: [UInt8], blockSize: Int) -> [UInt8] {
        let padding = blockSize - (block.count % blockSize)
        if padding == 0 {
            return block + Array(repeating: UInt8(padding), count: blockSize)
        } else {
            return block + Array(repeating: UInt8(padding), count: padding)
        }
    }
    
    static func unpaddedPKCS7(_ block: [UInt8], blockSize: Int?) -> [UInt8] {
        guard let padding = block.last.map(Int.init),
              padding <= blockSize ?? padding else {
            return block
        }
        return block.dropLast(padding)
    }

}
