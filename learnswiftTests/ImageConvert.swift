import Foundation
import XCTest

func toCGContext(cgImage:CGImage)->CGContext? {
    cgImage.toCGContext()
}

private extension CGImage {
    func toCGContext() -> CGContext? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bitsPerComponent = 8
        let bytesPerRow = bytesPerPixel * width
        let bitmapInfo = RGBA32.bitmapInfo

        guard let context: CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }

        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        return context
    }
}
