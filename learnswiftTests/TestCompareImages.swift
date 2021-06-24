//
// Created by Dim on 22.06.2021.
//

import Foundation
import XCTest

class TestCompareImages: XCTestCase {

    func testCompareSuccessImages() {
        let imageGH: CGImage = getProjectDirImage(imagePath: "compare/github/MainScreenUITests/testEmptyArrivalStationAlert.1.png")
        let imageLocal = getProjectDirImage(imagePath: "compare/local/MainScreenUITests/testEmptyArrivalStationAlert.1.png")
        XCTAssertTrue(compareScreenshots(expect: imageLocal, actual: imageGH))
    }

    func testCompareFailedImages() {
        let imageGH = getProjectDirImage(imagePath: "compare/github/InfoUITests/testSchedulePastDateActionSheet.1.png")
        let imageLocal = getProjectDirImage(imagePath: "compare/local/InfoUITests/testSchedulePastDateActionSheet.1.png")
        XCTAssertFalse(compareScreenshots(expect: imageLocal, actual: imageGH))
    }

}

let COLOR_THRESHOLD: Int = 40
let DISTANCE: Int = 2

func compareScreenshots(expect: CGImage, actual: CGImage) -> Bool { //todo return diff image ->(success:Bool, diff:CGImage?)
    let expectPixels = PixelWrapper(cgImage: expect)
    let actualPixels = PixelWrapper(cgImage: actual)
    let diffPixels = PixelWrapper(cgImage: actual)
    diffPixels.mapEachPixel { rgb in
        RGB(rgb.r / 3, rgb.g / 3, rgb.b / 3)
    }
    diffPixels.saveToFile(name: "diff.png")

    /**
     fun Sequence<Pt>.filterByImgSize() =
    filter { it.x >= 0 && it.x < width && it.y >= 0 && it.y < height }
     */

    func nearPixels(x:Int, y:Int, distance:Int)->Array<Int> {
        return []
    }

    return true
}
