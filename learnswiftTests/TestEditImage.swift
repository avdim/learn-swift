//
// Created by Dim on 21.06.2021.
//

import Foundation
import XCTest
@testable import learnswift

class TestEditImage: XCTestCase {

    func testEditPng() {
        editPng()
    }
}

func editPng() {
    let inputCGImage = getProjectDirImage(imagePath: "img.png")
    let pixelWrapper = PixelWrapper(cgImage: inputCGImage)
    pixelWrapper.mapEachPixel { old in
        if (old == .githubActionsSystemUiColorDiff) {
            return RGB.red
        } else {
            return old
        }
    }
    pixelWrapper.saveToFile(name: "changed-image.png")
}

