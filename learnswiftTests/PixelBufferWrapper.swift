//
// Created by Dim on 23.06.2021.
//

import Foundation

class PixelBufferWrapper {
    let pixelBuffer: UnsafeMutablePointer<RGB>
    let width: Int
    let height: Int

    init(pixelBuffer: UnsafeMutablePointer<RGB>, width: Int, height: Int) {
        self.pixelBuffer = pixelBuffer
        self.width = width
        self.height = height
    }

    func getPixel(x: Int, y: Int) -> RGB {
        return pixelBuffer[y * width + x]
    }

    func setPixel(x: Int, y: Int, value: RGB) {
        pixelBuffer[y * width + x] = value
    }
}
