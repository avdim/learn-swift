import Foundation
import XCTest

struct RGB: Equatable {
    private var color: UInt32

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

    init(red: UInt8, green: UInt8, blue: UInt8) {
        color = (UInt32(red) << 24) | (UInt32(green) << 16) | (UInt32(blue) << 8) | 0xFF
    }

    init(rgb: UInt32) {
        color = (rgb << 8) | 0xFF
    }

    static let red = RGB(rgb: 0xFF0000)
    static let green = RGB(rgb: 0x00FF00)
    static let blue = RGB(rgb: 0x0000FF)
    static let white = RGB(rgb: 0xFFffFF)
    static let black = RGB(rgb: 0x000000)
    static let githubActionsSystemUiColorDiff = RGB(red: 0xAD, green: 0xF2, blue: 0xFF)
    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

    static func ==(lhs: RGB, rhs: RGB) -> Bool {
        return lhs.color == rhs.color
    }
}
