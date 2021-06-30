//
// Created by Dim on 30.06.2021.
//

import Foundation
import XCTest

class TestXCTestCaseUsage: XCTestCase {
    func test1() {
//        continueAfterFailure = false
        print("before assert")
        XCTAssertEqual(1, 2)
        print("after assert")
    }

    override func perform(_ run: XCTestRun) {
        print("perform run")
        run.totalFailureCount
//        run.start()

        super.perform(run)
    }

    override func record(_ issue: XCTIssue) {
        print("record issue: \(issue)")
//        super.record(issue)
    }

    override func invokeTest() {
        super.invokeTest()
    }

}

