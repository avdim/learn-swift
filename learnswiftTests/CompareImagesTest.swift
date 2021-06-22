//
// Created by Dim on 22.06.2021.
//

import Foundation
import XCTest

class CompareImagesTest: XCTestCase {

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

func compareScreenshots(expect: CGImage, actual: CGImage) -> Bool { //todo return diff image
    return true
}
