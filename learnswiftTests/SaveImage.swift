//
// Created by Dim on 22.06.2021.
//

import Foundation
import XCTest

extension CGImage {
    public func saveToFile(name: String) {
//        let outputImage = UIImage(cgImage: self, scale: image.scale, orientation: image.imageOrientation)
        UIImage(cgImage: self).saveToFile(name: name)
    }
}

extension CGContext {
    public func saveToFile(name: String) {
        self.makeImage()!.saveToFile(name: name)
    }
}

extension UIImage {
    public func saveToFile(name: String) -> Bool {
        guard let data = /*self.jpegData(compressionQuality: 1) ?? */self.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            let fileUrl = directory.appendingPathComponent(name)
            print("save to file: \(fileUrl)")
            try data.write(to: fileUrl!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
