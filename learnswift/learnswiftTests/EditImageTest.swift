//
// Created by Dim on 21.06.2021.
//

import Foundation
import XCTest
@testable import learnswift

class EditImageTest: XCTestCase {

    func testEditPng() {
        editPng()
    }
}

func editPng() -> CGImage? {
    let filePath = "/Users/dim/github/avdim/kotlin-screenshot-test/desktop/src/jvmMain/resources/github/MainScreenUITests/testEmptyArrivalStationAlert.1.png"
//    let filePath = "/tmp/test/input.png"
    let fileExists = FileManager.default.fileExists(atPath: filePath)
    print("fileExists: \(fileExists)")
    let img = UIImage(contentsOfFile: filePath)
    guard let inputCGImage: CGImage = img?.cgImage else {
        print("can't get img?.cgImage")
        return nil
    }

    /**
    guard let inputCGImage = image.cgImage else {
        print("unable to get cgImage")
        return nil
    }
    */

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let width = inputCGImage.width
    let height = inputCGImage.height
    let bytesPerPixel = 4
    let bitsPerComponent = 8
    let bytesPerRow = bytesPerPixel * width
    let bitmapInfo = RGBA32.bitmapInfo

    guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
        print("unable to create context")
        return nil
    }

    context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
    guard let buffer = context.data else {
        print("unable to get context data")
        return nil
    }
    let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
    for row in 0..<Int(height) {
        for column in 0..<Int(width) {
            let offset = row * width + column
            if pixelBuffer[offset] == .githubActionsSystemUiColorDiff {
                pixelBuffer[offset] = .white
            }
        }
    }

    let outputCGImage: CGImage = context.makeImage()!
//        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
    let destination = "/tmp/test/changed-image.png"
    print("outputCGImage.width: \(outputCGImage.width)")
    saveImage(image: UIImage(cgImage: outputCGImage))
    inputCGImage.bitmapInfo
    print("return outputCGImage")
    return outputCGImage
}

func saveImage(image: UIImage) -> Bool {
    guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
        return false
    }
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
        return false
    }
    do {
        let fileUrl = directory.appendingPathComponent("img.png")
        print("save file to file: \(fileUrl)")
        try data.write(to: fileUrl!)
        return true
    } catch {
        print(error.localizedDescription)
        return false
    }
}

func fixGitHubActionsColorDifference2(in image: UIImage) -> UIImage? {
    guard let inputCGImage = image.cgImage else {
        print("unable to get cgImage")
        return nil
    }
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let width = inputCGImage.width
    let height = inputCGImage.height
    let bytesPerPixel = 4
    let bitsPerComponent = 8
    let bytesPerRow = bytesPerPixel * width
    let bitmapInfo = RGBA32.bitmapInfo

    guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
        print("unable to create context")
        return nil
    }
    context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

    guard let buffer = context.data else {
        print("unable to get context data")
        return nil
    }

    let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)

    for row in 0..<Int(height) {
        for column in 0..<Int(width) {
            let offset = row * width + column
            if pixelBuffer[offset] == .githubActionsSystemUiColorDiff {
                pixelBuffer[offset] = .white
            }
        }
    }

    let outputCGImage = context.makeImage()!
    let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)

    return outputImage
}

struct RGBA32: Equatable {
    private var color: UInt32

    var redComponent: UInt8 {
        return UInt8((color >> 24) & 255)
    }

    var greenComponent: UInt8 {
        return UInt8((color >> 16) & 255)
    }

    var blueComponent: UInt8 {
        return UInt8((color >> 8) & 255)
    }

    var alphaComponent: UInt8 {
        return UInt8((color >> 0) & 255)
    }

    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let red = UInt32(red)
        let green = UInt32(green)
        let blue = UInt32(blue)
        let alpha = UInt32(alpha)
        color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
    }

    static let red = RGBA32(red: 255, green: 0, blue: 0, alpha: 255)
    static let green = RGBA32(red: 0, green: 255, blue: 0, alpha: 255)
    static let blue = RGBA32(red: 0, green: 0, blue: 255, alpha: 255)
    static let white = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
    static let black = RGBA32(red: 0, green: 0, blue: 0, alpha: 255)
    static let magenta = RGBA32(red: 255, green: 0, blue: 255, alpha: 255)
    static let yellow = RGBA32(red: 255, green: 255, blue: 0, alpha: 255)
    static let cyan = RGBA32(red: 0, green: 255, blue: 255, alpha: 255)
    static let githubActionsSystemUiColorDiff = RGBA32(red: 0xAD, green: 0xF2, blue: 0xFF, alpha: 0xFF)
    //D4D2C9 macos15
    //99FAFF github
    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

    static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
        return lhs.color == rhs.color
    }
}
