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

    func testSubscript1() {
        struct TimesTable {
            let multiplier: Int
            subscript(index: Int) -> Int {
                return multiplier * index
            }
        }

        let threeTimesTable = TimesTable(multiplier: 3)
        print("six times three is \(threeTimesTable[6])")
        // Prints "six times three is 18"
    }

    func testSubscript2() {
        class MatrixStub {
            subscript(x: Int, y: Int) -> String {
                return "element [\(x), \(y)]"
            }
        }

        let matrixStub = MatrixStub()
        print(matrixStub[1, 2])

        struct Matrix {
            let rows: Int, columns: Int
            var grid: [Double]

            init(rows: Int, columns: Int) {
                self.rows = rows
                self.columns = columns
                grid = Array(repeating: 0.0, count: rows * columns)
            }

            func indexIsValid(row: Int, column: Int) -> Bool {
                return row >= 0 && row < rows && column >= 0 && column < columns
            }

            subscript(row: Int, column: Int) -> Double {
                get {
                    assert(indexIsValid(row: row, column: column), "Index out of range")
                    return grid[(row * columns) + column]
                }
                set {
                    assert(indexIsValid(row: row, column: column), "Index out of range")
                    grid[(row * columns) + column] = newValue
                }
            }
        }

        var matrix = Matrix(rows: 2, columns: 2)
        matrix[0, 1] = 1.5
//        let badIndex = matrix[2, 2]
    }

    func testStructInitializer() {
        struct Size {
            var width = 0.0, height = 0.0
        }

        Size(width: 2.0, height: 2.0)
        Size(height: 2.0)
    }

    func testPropertyInitializer() {
//        class SomeClass {
//            let someProperty: SomeType = {
//                // create a default value for someProperty inside this closure
//                // someValue must be of the same type as SomeType
//                return someValue
//            }()
//        }
        /**
         Note that the closure’s end curly brace is followed by an empty pair of parentheses.
         This tells Swift to execute the closure immediately.
         If you omit these parentheses, you are trying to assign the closure itself to the property,
         and not the return value of the closure.
         **/
        struct Chessboard {
            let boardColors: [Bool] = {
                var temporaryBoard: [Bool] = []
                var isBlack = false
                for i in 1...8 {
                    for j in 1...8 {
                        temporaryBoard.append(isBlack)
                        isBlack = !isBlack
                    }
                    isBlack = !isBlack
                }
                return temporaryBoard
            }()

            func squareIsBlackAt(row: Int, column: Int) -> Bool {
                return boardColors[(row * 8) + column]
            }
        }

        let board = Chessboard()
        print(board.squareIsBlackAt(row: 0, column: 1))
        // Prints "true"
        print(board.squareIsBlackAt(row: 7, column: 7))
        // Prints "false"
    }

    func testOptionalChain() {
        class Person {
            var residence: Residence?
        }

        class Residence {
            var numberOfRooms = 1
        }

        let john = Person()
        john.residence = Residence()
        if let roomCount = john.residence?.numberOfRooms /*let anotherVar=...*/ {
            print("John's residence has \(roomCount) room(s).")
        } else {
            print("Unable to retrieve the number of rooms.")
        }
        //If subscript john.residence?[0].name
    }

    func testArrayMutation() {
        var ints = [1]
        ints.append(2)
    }

    func testErrorHandling1() {
        enum MyError: Error {
            case Err1
        }

        func someThrowingFunction(_ letsThrow: Bool = true) throws -> Int {
            if (letsThrow) {
                throw MyError.Err1
                throw fatalError("Ooops")// If throws fatal error - program stops immediately, without catching. А Unit тест зависает¬
            }
            return 1
        }

        let x = try? someThrowingFunction()
        let y: Int?
        do {
            y = try someThrowingFunction()
        } catch {
            y = nil
        }
        print("x", x)
        print("y", y)
        //////////////////////////////////////////////////////
        if let data = try? someThrowingFunction(false) {
            print("use data+1: ", data + 1)
        } else {
            print("data not available inside else block")
        }

        let z = try! someThrowingFunction(false)
        print("z", z)
        //////////////////////////////////////////////////////
    }

    func testGuard1() {
        func someNullableFunc(_ success: Bool = true) -> String? {
            if (success) {
                return "value"
            } else {
                return nil
            }
        }

        guard let useLater = someNullableFunc(true) else {
            return
        }
        print("useLater", useLater)
    }

    func testLoop1() {
        for counter in 0...10 where counter % 2 == 0 { //also 0..<10
            print(counter)
        }
    }

    func testProtocolWithExt() {
        doTestProtocolWithExt()
    }

    func testEqualsSynthesizedStruct() {
        struct Vector3D: Equatable {
            var x = 0.0, y = 0.0, z = 0.0
        }

        let twoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
        let anotherTwoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
        if twoThreeFour == anotherTwoThreeFour {
            print("These two vectors are also equivalent.")
        }
        // Prints "These two vectors are also equivalent."
    }

    func testProtocolComposition() {
        doTestProtocolComposition()
    }

    func testTypeConvertions() {
        class Class1 {
        }

        let objects: [Any] = [123, "str", Class1()]
        for object in objects {
            if let str1 = object as? String {
                print("object is String \(str1)")
            } else if let anyObj = object as? AnyObject {
                print("object is AnyObject \(anyObj)")
            } else {
                print("another")
            }
        }
    }

    func testCollectionExtension() {
        doTestCollectionExtension()
    }

    func testGeneric1() {
        func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
            let temporaryA = a
            a = b
            b = temporaryA
        }

        var one = 1
        var two = 2
        swapTwoValues(&one, &two)
        print("one:", one)
        print("two:", two)

        var h = "hello"
        var w = "world"
        swapTwoValues(&h, &w)
        print("h:", h)
        print("w:", w)
    }

    func testGeneric2() {
        struct Stack<Element> {
            var items: [Element] = []

            mutating func push(_ item: Element) {
                items.append(item)
            }

            mutating func pop() -> Element {
                return items.removeLast()
            }
        }

        var stackOfStrings = Stack<String>()
        stackOfStrings.push("uno")
        stackOfStrings.push("dos")
        stackOfStrings.push("tres")
        stackOfStrings.push("cuatro")
        print(stackOfStrings)
//        extension Stack {
//            var topItem: Element? {
//                return items.isEmpty ? nil : items[items.count - 1]
    }

    func testGeneric3TypeConstrains() {
        func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
            for (index, value) in array.enumerated() {
                if value == valueToFind {
                    return index
                }
            }
            return nil
        }

        let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
        // doubleIndex is an optional Int with no value, because 9.3 isn't in the array
        let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
        // stringIndex is an optional Int containing a value of 2
    }

    func testGenericWhereClauses() {

    }

    func test() {

    }

}

// Kotlin and Swift comparsion
// https://habr.com/ru/post/350746/
/////////////////////////////////////////////////
protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Int: TextRepresentable {
    var textualDescription: String {
        get {
            return "number \(self)"
        }
    }
}

func doTestProtocolWithExt() {
    func printText(obj: TextRepresentable) {
        print(obj.textualDescription)
    }

    printText(obj: 123)
}

///////////////////////////////////////////////////////////////
private protocol Named {
    var name: String { get }
}

private protocol Aged {
    var age: Int { get }
}

func doTestProtocolComposition() {
    struct Person: Named, Aged {
        var name: String
        var age: Int
    }

    func wishHappyBirthday(to celebrator: Named & Aged) {
        print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
    }

    let birthdayPerson = Person(name: "Malcolm", age: 21)
    wishHappyBirthday(to: birthdayPerson)
    // Prints "Happy birthday, Malcolm, you're 21!"
}

////////////////////////////////////////////////////////////////////////////////////

extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}

func doTestCollectionExtension() {
    let equalNumbers = [100, 100, 100, 100, 100]
    let differentNumbers = [100, 100, 200, 100, 200]
    print(equalNumbers.allEqual())
// Prints "true"
    print(differentNumbers.allEqual())
// Prints "false"
}

////////////////////////////////////////////////////////////////////////////////////
fileprivate func funcWithFilePrivateAccess() {
    //do nothing
}
////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////

