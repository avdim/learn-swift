import Foundation
import XCTest

struct RGB/*: Equatable*/ {
    private var argbColor: UInt32

    var r: UInt8 {
        return UInt8((argbColor >> 16) & 0xFF)
    }

    var g: UInt8 {
        return UInt8((argbColor >> 8) & 0xFF)
    }

    var b: UInt8 {
        return UInt8((argbColor >> 0) & 0xFF)
    }

    init(_ red: UInt8, _ green: UInt8, _ blue: UInt8) {
        argbColor = 0xFF000000 | (UInt32(red) << 16) | (UInt32(green) << 8) | (UInt32(blue) << 0)
    }

    init(_ argb: UInt32) {
        argbColor = argb
    }

    static let red = RGB(0xFF0000)
    static let green = RGB(0x00FF00)
    static let blue = RGB(0x0000FF)
    static let white = RGB(0xFFffFF)
    static let black = RGB(0x000000)
    static let bitmapInfo = CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

//    static func ==(lhs: RGB, rhs: RGB) -> Bool {
//        return lhs.argbColor == rhs.argbColor
//    }
}
