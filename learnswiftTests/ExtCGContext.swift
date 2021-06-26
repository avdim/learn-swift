import Foundation
import XCTest

func cgContextToPixelBuffer(cgContext: CGContext) -> UnsafeMutablePointer<RGB> {
    return cgContext.toPixelBuffer()
}

func cgContextSaveToFile(cgContext: CGContext, name: String) {
    cgContext.saveToFile(name: name)
}

private extension CGContext {
    func toPixelBuffer() -> UnsafeMutablePointer<RGB> {
        let buffer = self.data!
        let pixelBuffer: UnsafeMutablePointer<RGB> = buffer.bindMemory(to: RGB.self, capacity: width * height)
        return pixelBuffer
    }

    func saveToFile(name: String) {
        cgImageSaveToFile(cgImage: self.makeImage()!, name: name)
    }
}

