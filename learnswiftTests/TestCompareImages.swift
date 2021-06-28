//
// Created by Dim on 22.06.2021.
//

import Foundation
import XCTest

class TestCompareImages: XCTestCase {

    func testCompareSuccessImages() {
        let imageGH: CGImage = getProjectDirImage(imagePath: "compare/github/MainScreenUITests/testEmptyArrivalStationAlert.1.png")
        let imageLocal = getProjectDirImage(imagePath: "compare/local/MainScreenUITests/testEmptyArrivalStationAlert.1.png")
        let result = compareTutuSnapshots(expectImg: imageLocal, actualImg: imageGH)
        result.image?.saveToFile(name: "compare_success.png")
        XCTAssertTrue(result.success)
    }

    func testCompareFailedImages() {
        let imageGH = getProjectDirImage(imagePath: "compare/github/InfoUITests/testSchedulePastDateActionSheet.1.png")
        let imageLocal = getProjectDirImage(imagePath: "compare/local/InfoUITests/testSchedulePastDateActionSheet.1.png")
        let result = compareTutuSnapshots(expectImg: imageLocal, actualImg: imageGH)
        result.image?.saveToFile(name: "compare_failed.png")
        XCTAssertFalse(result.success)
    }

    func testCompareDifferentFailedImages() {
        let imageGH = getProjectDirImage(imagePath: "compare/github/InfoUITests/testSchedulePastDateActionSheet.1.png")
        let imageLocal = getProjectDirImage(imagePath: "compare/local/TechSupportUITests/testDefaultView.1.png")
        let result = compareTutuSnapshots(expectImg: imageLocal, actualImg: imageGH)
        result.image?.saveToFile(name: "compare_different_fail")
        XCTAssertFalse(result.success)
    }

    func testHopeSuccessfullSubscription() {
        let imageGH = getProjectDirImage(imagePath: "compare/github/HopeUITests/testHopeSuccessfulSubscription.1.png")
        let imageLocal = getProjectDirImage(imagePath: "compare/local/HopeUITests/testHopeSuccessfulSubscription.1.png")
        let result = compareTutuSnapshots(expectImg: imageLocal, actualImg: imageGH)
        result.image?.saveToFile(name: "testHopeSuccessfullSubscription")
        XCTAssertTrue(result.success)
    }

    func testScheduleStationsNotFoundInMainScreenUITests() {
        let imageGH = getProjectDirImage(imagePath: "compare/github/MainScreenUITests/testScheduleStationsNotFound.1.png")
        let imageLocal = getProjectDirImage(imagePath: "compare/local/MainScreenUITests/testScheduleStationsNotFound.1.png")
        let result = compareTutuSnapshots(expectImg: imageLocal, actualImg: imageGH)
        result.image?.saveToFile(name: "testHopeSuccessfullSubscription")
        XCTAssertTrue(result.success)
    }

    func testCompareAllImages() {
        struct SnapshotDir {
                let clazz: String
                let pngNames: [String]
        }

        let snapshotDirs = [
                SnapshotDir(
                        clazz: "DetailsUITests",
                        pngNames: ["testCarrierInfo.1.png",
                        "testDefaultView.1.png", "testDetailsLink.1.png", "testWholeCoupeServicePackage.1.png"]
                ),
                SnapshotDir(
                        clazz: "MainScreenUITests",
                        pngNames: ["testDefaultView.1.png",
                        "testEmptyArrivalStationAlert.1.png",
                        "testEmptyStationsAlert.1.png",
                        "testSameStationsAlert.1.png",
                        "testScheduleDepartureStationNotFound.1.png",
                        "testScheduleStationsNotFound.1.png"]
                ),
                SnapshotDir(
                        clazz: "FareSelectionUITests",
                        pngNames: ["testNonRefundableTariffInfo.1.png"]
                ),
                SnapshotDir(
                        clazz: "FilterTagsViewUITests",
                        pngNames: ["testSorting.2.png"]
                ),
                SnapshotDir(
                        clazz: "HopeUITests",
                        pngNames: ["testHopeNecessaryElements.1.png", "testHopeSuccessfulSubscription.1.png"]
                ),
                SnapshotDir(
                        clazz: "InfoUITests",
                        pngNames: ["testScheduleFutureDateActionSheet.1.png",
                        "testSchedulePastDateActionSheet.1.png",
                        "testScheduleWithDateActionSheet.1.png",
                        "testScheduleWithoutDateActionSheet.1.png"]
                ),
                SnapshotDir(
                        clazz: "LaundryUITests",
                        pngNames: ["testLaundryExcludedNoChange.1.png", "testLaundryIncludedCanChange.1.png", "testLaundryIncludedNoChange.1.png"]
                ),
                SnapshotDir(
                        clazz: "PassengersCountUITests",
                        pngNames: ["testBabiesAdultsLimit.1.png", "testDefaultView_dontNeedTicketForBaby.1.png", "testDefaultView_needTicketForBaby.1.png", "testTotalLimit.1.png"]
                ),
                SnapshotDir(
                        clazz: "SeatsChoiceByParametersUITests",
                        pngNames: ["testDefaultView.1.png", "testGenderCarsAlerts.1.png", "testSeatsChoiceParametersSetUp.1.png"]
                ),
                SnapshotDir(
                        clazz: "SeatsChoiceOnSchemesUITests",
                        pngNames: ["testDefaultView.1.png", "testDirectionArrow.1.png", "testGenderCarsAlerts.1.png", "testNoLevelsSchemes.1.png"]
                ),
                SnapshotDir(
                        clazz: "TechSupportUITests",
                        pngNames: ["testDefaultView.1.png"]
                )
        ]

        for dir in snapshotDirs {
            for name in dir.pngNames {
                let imageGH: CGImage = getProjectDirImage(imagePath: "compare/github/\(dir.clazz)/\(name)")
                let imageLocal = getProjectDirImage(imagePath: "compare/local/\(dir.clazz)/\(name)")
                let result = compareTutuSnapshots(expectImg: imageLocal, actualImg: imageGH)
                result.image?.saveToFile(name: dir.clazz + "_" + name)
            }
        }
    }

}

