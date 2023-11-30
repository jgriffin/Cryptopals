import EulerTools

public extension CryptoTools {
    struct ECBPrefixFinder {
        let oracle: CryptoTools.EncryptionOracleInfo
        private var blockToPrefixMap: [[UInt8].SubSequence: [UInt8]] = [:]
        private let blockLength: Int
        private var alignmentLength: Int = 0 // when encryption prepends characters to plaintext
        private var alignmentBlocks: Int = 0 // when encryption prepends characters to plaintext

        private let possibleValues: [UInt8] = {
            let priority = UInt8.alphaNumericLetters + UInt8.punctuationLetters + UInt8.symbolLetters
            let prioritySet = priority.asSet
            return priority + (UInt8.min ... UInt8.max).filter { !prioritySet.contains($0) }
        }()

        public init(
            oracle: CryptoTools.EncryptionOracleInfo,
            blockLength: Int = 16
        ) {
            self.oracle = oracle
            self.blockLength = blockLength
        }

        // MARK: - updateAligmentInfo

        public private(set) lazy var updateAlignmentInfoOnce: Void = {
            try? updateAlignmentInfo()
        }()

        private mutating func updateAlignmentInfo() throws {
            let twoBlocks = [UInt8](repeating: .A, count: 2 * blockLength)

            for alignmentCount in 0 ..< blockLength {
                let cypher = try oracle.encrypt(plaintext: paddingOfCount(alignmentCount) + twoBlocks)
                let firstRepeatBlock =
                    zip(cypher.chunks(ofCount: blockLength),
                        cypher.chunks(ofCount: blockLength).dropFirst())
                    .enumerated()
                    .first(where: { _, pair in pair.0 == pair.1 })

                if let firstRepeatBlock {
                    alignmentLength = alignmentCount
                    alignmentBlocks = firstRepeatBlock.offset
                    return
                }
            }

            throw CryptoError.expectedValueMissing
        }

        // MARK: - prefixAfter

        public mutating func prefixAfter(_ prefix: [UInt8]) throws -> [UInt8] {
            _ = updateAlignmentInfoOnce
            let shift = shiftForPrefix(prefix)

            let plaintext = paddingOfCount(shift.alignment) + paddingOfCount(shift.padding)
            let cypher = try oracle.encrypt(plaintext: plaintext)
            let block = cypher.chunks(ofCount: blockLength).dropFirst(shift.alignmentBlocks +  shift.targetBlockIndex).first!

            return try findPrefixForBlock(block, afterPrefix: prefix)
        }

        private mutating func findPrefixForBlock(
            _ findBlock: [UInt8].SubSequence,
            afterPrefix prefix: [UInt8]
        ) throws -> [UInt8] {
            if let found = blockToPrefixMap[findBlock] {
                return found
            }

            // one full block that we control
            let knownBlock: [UInt8] = prefix.count + 1 < blockLength ?
                paddingOfCount(blockLength - prefix.count - 1) + prefix + [.dot] :
                prefix.suffix(blockLength - 1) + [.dot]

            // after any needed alignment padding
            var plaintext: [UInt8] = paddingOfCount(alignmentLength) + knownBlock

            // keep swapping out the last character
            for ch in possibleValues {
                // update the plaintext (last char)
                plaintext[plaintext.count - 1] = ch

                let cypher = try oracle.encrypt(plaintext: plaintext)
                let cypherBlock = cypher.chunks(ofCount: blockLength).dropFirst(alignmentBlocks).first!

                // cache it
                let newPrefix = plaintext.suffix(min(blockLength, prefix.count + 1)).asArray
                blockToPrefixMap[cypherBlock] = newPrefix

                if cypherBlock == findBlock {
                    return newPrefix
                }
            }

            throw CryptoError.expectedValueMissing
        }

        // MARK: - shiftForPrefix

        // returns the minimal plaintext block to pull in the next character and generate
        // a block found at cypherBlockIndex
        //
        // considers alignment and padding
        func shiftForPrefix(
            _ prefix: [UInt8]
        ) -> (alignment: Int, padding: Int, alignmentBlocks: Int, targetBlockIndex: Int) {
            let messageBlockCount = prefix.count / blockLength + 1
            let targetLength = messageBlockCount * blockLength
            let paddingCount = targetLength - (prefix.count + 1)

            return (
                alignment: alignmentLength,
                padding: paddingCount,
                alignmentBlocks: alignmentBlocks,
                targetBlockIndex: targetLength / blockLength - 1
            )
        }

        func paddingOfCount(_ paddingCount: Int) -> [UInt8] {
            (0 ..< UInt8(paddingCount)).asArray
        }
    }
}
