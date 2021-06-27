import Foundation
import XCTest


//struct RGB/*: Equatable*/ {
//    private var argbColor: Int32

public typealias RGB = Int32

extension RGB {
    @inlinable public var r: Int32 {
        return (self >> 16) & 0xFF
    }

    @inlinable public var g: Int32 {
        return (self >> 8) & 0xFF
    }

    @inlinable public var b: Int32 {
        return (self >> 0) & 0xFF
    }

    init(_ red: Int32, _ green: Int32, _ blue: Int32) {
        self = (red << 16) | (green << 8) | (blue << 0)
    }

    static let red = RGB(0xFF0000)
    static let green = RGB(0x00FF00)
    static let blue = RGB(0x0000FF)
    static let white = RGB(0xFFffFF)
    static let black = RGB(0x000000)
    static let bitmapInfo = CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
}
