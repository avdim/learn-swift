import Foundation
import XCTest

struct RGB: Equatable {
    private var color: UInt32

    var rInt: Int {
        return Int(r)
    }

    var gInt: Int {
        return Int(g)
    }

    var bInt: Int {
        return Int(b)
    }

    var r: UInt8 {
        return UInt8((color >> 24) & 0xFF)
    }

    var g: UInt8 {
        return UInt8((color >> 16) & 0xFF)
    }

    var b: UInt8 {
        return UInt8((color >> 8) & 0xFF)
    }

    var a: UInt8 {
        return UInt8((color >> 0) & 0xFF)
    }

    init(_ red: UInt8, _ green: UInt8, _ blue: UInt8) {
        color = (UInt32(red) << 24) | (UInt32(green) << 16) | (UInt32(blue) << 8) | 0xFF
    }

    init(_ rgb: UInt32) {
        color = (rgb << 8) | 0xFF
    }

    static let red = RGB(0xFF0000)
    static let green = RGB(0x00FF00)
    static let blue = RGB(0x0000FF)
    static let white = RGB(0xFFffFF)
    static let black = RGB(0x000000)
    static let githubActionsSystemUiColorDiff = RGB(0xADF2FF)
    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

    static func ==(lhs: RGB, rhs: RGB) -> Bool {
        return lhs.color == rhs.color
    }
}
