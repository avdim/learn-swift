//
// Created by Dim on 23.06.2021.
//

import Foundation

class PixelBufferWrapper {
    let pixelBuffer: UnsafeMutablePointer<RGBA32>
    let width: Int
    let height: Int

    init(pixelBuffer: UnsafeMutablePointer<RGBA32>, width: Int, height: Int) {
        self.pixelBuffer = pixelBuffer
        self.width = width
        self.height = height
    }

    func getPixel(x: Int, y: Int) -> RGBA32 {
        return pixelBuffer[y * width + x]
    }

    func setPixel(x: Int, y: Int, value: RGBA32) {
        pixelBuffer[y * width + x] = value
    }
}
