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

    func testClosure1() {
        let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 })
        names.sorted { s1, s2 -> Bool in
            return s1 > s2
        }
        names.sorted(by: { $0 > $1 })
        names.sorted(by: >)

    }

    func testGetSetProperties() {
        struct Point {
            var x = 0.0, y = 0.0
        }

        struct Size {
            var width = 0.0, height = 0.0
        }

        struct AlternativeRect {
            var origin = Point()
            var size = Size()
            var center: Point {
                get {
                    let centerX = origin.x + (size.width / 2)
                    let centerY = origin.y + (size.height / 2)
                    return Point(x: centerX, y: centerY)
                }
                set {
                    origin.x = newValue.x - (size.width / 2)
                    origin.y = newValue.y - (size.height / 2)
                }
            }
        }
    }

    func testStructReadOnlyPoperties() {
        struct Cuboid {
            var width = 0.0, height = 0.0, depth = 0.0
            var volume: Double {
                return width * height * depth
            }
        }
    }

    func testPropertyObserver() {
        class StepCounter {
            var totalSteps: Int = 0 {
                willSet(newTotalSteps) {
                    print("About to set totalSteps to \(newTotalSteps)")
                }
                didSet {
                    if totalSteps > oldValue {
                        print("Added \(totalSteps - oldValue) steps")
                    }
                }
            }
        }
        let stepCounter = StepCounter()
        stepCounter.totalSteps = 200
        // About to set totalSteps to 200
        // Added 200 steps
        stepCounter.totalSteps = 360
        // About to set totalSteps to 360
        // Added 160 steps
        stepCounter.totalSteps = 896
        // About to set totalSteps to 896
        // Added 536 steps
    }

}

// Kotlin and Swift comparsion
// https://habr.com/ru/post/350746/
