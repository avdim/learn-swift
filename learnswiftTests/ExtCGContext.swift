import Foundation
import XCTest

func cgContextToPixelBufferWrapper(cgContext: CGContext) -> PixelBufferWrapper {
    return cgContext.toPixelBufferWrapper()
}

func cgContextToPixelBuffer(cgContext: CGContext) -> UnsafeMutablePointer<RGB> {
    return cgContext.toPixelBuffer()
}

func cgContextSaveToFile(cgContext: CGContext, name: String) {
    cgContext.saveToFile(name: name)
}

private extension CGContext {
    func toPixelBufferWrapper() -> PixelBufferWrapper {
        let buffer = self.data!
        let pixelBuffer: UnsafeMutablePointer<RGB> = buffer.bindMemory(to: RGB.self, capacity: width * height)
        return PixelBufferWrapper(pixelBuffer: pixelBuffer, width: width, height: height)
    }

    func toPixelBuffer() -> UnsafeMutablePointer<RGB> {
        let buffer = self.data!
        let pixelBuffer: UnsafeMutablePointer<RGB> = buffer.bindMemory(to: RGB.self, capacity: width * height)
        return pixelBuffer
    }

    func saveToFile(name: String) {
        cgImageSaveToFile(cgImage: self.makeImage()!, name: name)
    }
}

