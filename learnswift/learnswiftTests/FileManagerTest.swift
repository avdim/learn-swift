//
// Created by Dim on 21.06.2021.
//

import Foundation
import XCTest

class FileManagerTest:XCTestCase {
    func testFileManager() {
        print("xCodeProjectDir: \(xCodeProjectDir)")

        let dir = FileManager.default.currentDirectoryPath
        do {
            let listFiles = try FileManager.default.contentsOfDirectory(atPath: xCodeProjectDir)
            print("listFiles: \(listFiles)")
        } catch {
        }
    }

}

let xCodeProjectDir: String = "/" + URL(fileURLWithPath: #file).pathComponents.dropLast(2).joined(separator: "/")


