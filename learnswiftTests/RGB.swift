import Foundation
import XCTest

struct RGB/*: Equatable*/ {
    private var argbColor: Int32

    var r: Int32 {
        return (argbColor >> 16) & 0xFF
    }

    var g: Int32 {
        return (argbColor >> 8) & 0xFF
    }

    var b: Int32 {
        return (argbColor >> 0) & 0xFF
    }

    init(_ red: Int32, _ green: Int32, _ blue: Int32) {
        argbColor = (red << 16) | (green << 8) | (blue << 0)
    }

    init(_ argb: Int32) {
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
