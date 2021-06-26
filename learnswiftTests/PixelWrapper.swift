//
// Created by Dim on 23.06.2021.
//

import Foundation
import XCTest

class PixelWrapper {
    let cgContext: CGContext
    let pixelBuffer: UnsafeMutablePointer<RGB>
    let width: Int
    let height: Int

    init(cgImage: CGImage) {
        self.cgContext = cgImageToCGContext(cgImage: cgImage)
        self.pixelBuffer = cgContextToPixelBuffer(cgContext: cgContext)
        self.width = cgContext.width
        self.height = cgContext.height
    }

    func saveToFile(name: String) {
        cgContextSaveToFile(cgContext: cgContext, name: name)
    }

    func mapEachPixel(lambda: (RGB) -> RGB) {
        for y in 0..<height {
            for x in 0..<width {
                let newPixel = lambda(self[x, y])
                self[x, y] = newPixel
            }
        }
    }

    subscript(x: Int, y: Int) -> RGB {
        get {
            return pixelBuffer[y * width + x]
        }
        set {
            pixelBuffer[y * width + x] = newValue
        }
    }

}
