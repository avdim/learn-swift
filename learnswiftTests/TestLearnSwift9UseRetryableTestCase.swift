//
// Created by Dim on 30.06.2021.
//

import Foundation
import XCTest

var globalCounter = 0

class TestLearnSwift9UseRetryableTestCase : RetryableTestCase {
    //https://github.com/KaneCheshire/Retryable
    func testNotFixable() {
        flaky(.notFixable(reason: "There's a race condition here!", maxRetryCount: 3)) {
            globalCounter += 1
            print("globalCounter: \(globalCounter)")
            XCTAssertEqual(2, globalCounter)
//            XCTAssert(somethingToAssert)
        }
    }
}

