import Foundation
import XCTest

func cgContextToPixelBufferWrapper(cgContext: CGContext) -> PixelBufferWrapper {
    return cgContext.toPixelBufferWrapper()
}

func cgContextSaveToFile(cgContext: CGContext, name: String) {
    cgContext.saveToFile(name: name)
}

private extension CGContext {
    func toPixelBufferWrapper() -> PixelBufferWrapper {
        let buffer = self.data!
        let pixelBuffer: UnsafeMutablePointer<RGBA32> = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        return PixelBufferWrapper(pixelBuffer: pixelBuffer, width: width, height: height)
    }

    func saveToFile(name: String) {
        cgImageSaveToFile(cgImage: self.makeImage()!, name: name)
    }
}
