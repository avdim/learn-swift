//
// Created by Dim on 23.06.2021.
//

import Foundation
import XCTest

class PixelWrapper {
    let cgContext: CGContext
    let pixelBufferWrapper: PixelBufferWrapper
    let width: Int
    let height: Int
    private var cache: [CacheRGB]?

    init(cgImage: CGImage) {
        self.cgContext = cgImageToCGContext(cgImage: cgImage)
        self.pixelBufferWrapper = cgContextToPixelBufferWrapper(cgContext: cgContext)
        self.width = cgContext.width
        self.height = cgContext.height
    }

    func getPixel(x: Int, y: Int) -> RGB {
        return pixelBufferWrapper.getPixel(x: x, y: y)
    }

    func setPixel(_ x: Int, _ y: Int, _ value: RGB) {
        pixelBufferWrapper.setPixel(x: x, y: y, value: value)
    }

    func saveToFile(name: String) {
        cgContextSaveToFile(cgContext: cgContext, name: name)
    }

    func mapEachPixel(lambda: (RGB) -> RGB) {
        for x in 0..<width {
            for y in 0..<height {
                let newPixel = lambda(getPixel(x: x, y: y))
                setPixel(x, y, newPixel)
            }
        }
    }

    subscript(x: Int, y: Int) -> CacheRGB {
        get {
            if (cache == nil) {
                cache = Array<CacheRGB>(repeating: CacheRGB(r: 0, g: 0, b: 0), count: width * height)
                for y2 in 0..<height {
                    for x2 in 0..<width {
                        let p = getPixel(x: x2, y: y2)
                        cache![x2 * height + y2] = CacheRGB(r: p.rInt, g: p.gInt, b: p.bInt)
                    }
                }
            }
            return cache![x * height + y]
        }
        set {
            //do nothing
        }
    }

}

struct CacheRGB {
    let r: Int
    let g: Int
    let b: Int

//    init(rInt: Int, gInt: Int, bInt: Int) {
//        self.rInt = rInt
//        self.gInt = gInt
//        self.bInt = bInt
//    }
}
