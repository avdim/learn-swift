//
// Created by Dim on 23.06.2021.
//

import Foundation
import XCTest

class PixelWrapper {
    let cgContext: CGContext
    let pixelBufferWrapper: PixelBufferWrapper
    let width:Int
    let height:Int

    init(cgImage: CGImage) {
        self.cgContext = cgImageToCGContext(cgImage: cgImage)
        self.pixelBufferWrapper = cgContextToPixelBufferWrapper(cgContext: cgContext)
        self.width = cgContext.width
        self.height = cgContext.height
    }

    func getPixel(x: Int, y: Int) -> RGBA32 {
        return pixelBufferWrapper.getPixel(x: x, y: y)
    }

    func setPixel(x: Int, y: Int, value: RGBA32) {
        pixelBufferWrapper.setPixel(x: x, y: y, value: value)
    }

    func saveToFile(name: String) {
        cgContextSaveToFile(cgContext: cgContext, name: name)
    }

}
