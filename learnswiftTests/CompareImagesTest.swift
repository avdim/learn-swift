//
// Created by Dim on 22.06.2021.
//

import Foundation
import XCTest

class CompareImagesTest: XCTestCase {

    func testCompareSuccessImages() {
        let imageGH = getProjectDirImage(imagePath: "compare/github/MainScreenUITests/testEmptyArrivalStationAlert.1.png")
        let imageLocal = getProjectDirImage(imagePath: "compare/local/MainScreenUITests/testEmptyArrivalStationAlert.1.png")
        print("imageGH.width: ", imageGH.width)
        print("imageLocal.width: ", imageLocal.width)
    }

    func testCompareFailedImages() {

    }

}
