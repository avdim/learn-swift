import Foundation
import XCTest

class TestLearnSwift1: XCTestCase {

    func testGuardUsage() {
        // guard:
        func greet(person: [String: String]) {
            guard let name = person["name"] else {
                return
            }

            print("Hello \(name)!")

            guard let location = person["location"] else {
                print("I hope the weather is nice near you.")
                return
            }

            print("I hope the weather is nice in \(location).")
        }

        greet(person: ["name": "John"])
        // Prints "Hello John!"
        // Prints "I hope the weather is nice near you."
        greet(person: ["name": "Jane", "location": "Cupertino"])
        // Prints "Hello Jane!"
        // Prints "I hope the weather is nice in Cupertino."
    }

    func testXGraphicsCondition() {
        // X graphic
        let yetAnotherPoint = (1, -1)
        switch yetAnotherPoint {
        case let (x, y) where x == y:
            print("(\(x), \(y)) is on the line x == y")
        case let (x, y) where x == -y:
            print("(\(x), \(y)) is on the line x == -y")
        case let (x, y):
            print("(\(x), \(y)) is just some arbitrary point")
        }
        // Prints "(1, -1) is on the line x == -y"
        //https://docs.swift.org/swift-book/_images/coordinateGraphComplex_2x.png
    }

    func testInOutFuncParams() {
        // inout sample
        func swapTwoInts(_ a: inout Int, _ b: inout Int) {
            let temporaryA = a
            a = b
            b = temporaryA
        }

        var one = 1
        var two = 2
        swapTwoInts(&one, &two)
        print("one is now \(one), and two is now \(two)")
    }

}

// Kotlin and Swift comparsion
// https://habr.com/ru/post/350746/
