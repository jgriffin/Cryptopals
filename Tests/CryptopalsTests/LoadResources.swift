//
// Created by John Griffin on 11/11/23
//

import Foundation
import XCTest

extension XCTestCase {
    private func resourceURL(filename: String) -> URL? {
        Bundle.module.url(forResource: filename, withExtension: nil)
    }

    func dataFromResource(_ name: String) -> Data {
        guard let resourceURL = resourceURL(filename: name),
              let data = try? Data(contentsOf: resourceURL)
        else {
            fatalError()
        }
        return data
    }

    func stringFromResource(_ name: String) -> String {
        guard let resourceURL = resourceURL(filename: name),
              let string = try? String(contentsOf: resourceURL)
        else {
            fatalError()
        }
        return string
    }
}
