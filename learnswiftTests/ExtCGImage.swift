import Foundation
import XCTest

func cgImageToCGContext(cgImage: CGImage) -> CGContext {
    return cgImage.toCGContext()
}

func cgImageSaveToFile(cgImage: CGImage, name: String) {
    cgImage.saveToFile(name: name)
}

private extension CGImage {
    func toCGContext() -> CGContext {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bitsPerComponent = 8
        let bytesPerRow = bytesPerPixel * width
        let bitmapInfo = RGBA32.bitmapInfo

        let context: CGContext = CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo
        )!

        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        return context
    }

    func saveToFile(name: String) {
//        let outputImage = UIImage(cgImage: self, scale: image.scale, orientation: image.imageOrientation)
        uiImageSaveToFile(uiImage: UIImage(cgImage: self), name: name)
    }
}
