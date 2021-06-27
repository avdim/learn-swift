//
// Created by Dim on 27.06.2021.
//

import Foundation
import XCTest

class TestLearnSwift7: XCTestCase {
    func testDynamicCall() {
        @dynamicCallable
        struct TelephoneExchange {
            func dynamicallyCall(withArguments phoneNumber: [Int]) {
                if phoneNumber == [4, 1, 1] {
                    print("Get Swift help on forums.swift.org")
                } else {
                    print("Unrecognized number")
                }
            }
        }

        let dial = TelephoneExchange()

        // Use a dynamic method call.
        dial(4, 1, 1)
        // Prints "Get Swift help on forums.swift.org"
        dial(8, 6, 7, 5, 3, 0, 9)
        // Prints "Unrecognized number"
        // Call the underlying method directly.
        dial.dynamicallyCall(withArguments: [4, 1, 1])
    }

    func testDynamicMemberLookup() {
        struct Point { var x, y: Int }

        @dynamicMemberLookup
        struct PassthroughWrapper<Value> {
            var value: Value
            subscript<T>(dynamicMember member: KeyPath<Value, T>) -> T {
                get { return value[keyPath: member] }
            }
        }

        let point = Point(x: 381, y: 431)
        let wrapper = PassthroughWrapper(value: point)
        print(wrapper.x)
    }

    func test() {
        inlineMe()
    }

}

@inlinable
func inlineMe() {

}
