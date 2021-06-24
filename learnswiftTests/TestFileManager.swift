//
// Created by Dim on 21.06.2021.
//

import Foundation
import XCTest

class TestFileManager:XCTestCase {
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

public func getProjectDirImage(imagePath: String) -> CGImage {
    let filePath = "\(xCodeProjectDir)/\(imagePath)"
//    let filePath = "/tmp/test/input.png"
    let fileExists = FileManager.default.fileExists(atPath: filePath)
    let img = UIImage(contentsOfFile: filePath)
    let inputCGImage2: CGImage = img!.cgImage!
    return inputCGImage2
}

