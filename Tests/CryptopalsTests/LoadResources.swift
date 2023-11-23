//
// Created by John Griffin on 11/11/23
//

import Foundation
import XCTest

extension XCTestCase {
    static func resourceURL(filename: String) -> URL? {
        Bundle.module.url(forResource: filename, withExtension: nil)
    }

    static func resourceData(_ filename: String) throws -> Data {
        try resourceURL(filename: filename).flatMap { try Data(contentsOf: $0) }.unwrapped
    }
}
