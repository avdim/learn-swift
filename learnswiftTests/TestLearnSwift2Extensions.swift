import Foundation
import XCTest

private extension Double {
    var km: Double {
        return self * 1_000.0
    }
    var m: Double {
        return self
    }
    var cm: Double {
        return self / 100.0
    }
    var mm: Double {
        return self / 1_000.0
    }
    var ft: Double {
        return self / 3.28084
    }
}

private func useDoubleExtensions() {
    let oneInch = 25.4.mm
    print("One inch is \(oneInch) meters")
    // Prints "One inch is 0.0254 meters"
    let threeFeet = 3.ft
    print("Three feet is \(threeFeet) meters")
    // Prints "Three feet is 0.914399970739201 meters"
    let aMarathon = 42.km + 195.m
    print("A marathon is \(aMarathon) meters long")
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
private struct Size {
    var width = 0.0, height = 0.0
}

private struct Point {
    var x = 0.0, y = 0.0
}

private struct Rect {
    var origin = Point()
    var size = Size()
}

private extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
private func useInitExtension() {
    let centerRect = Rect( // use Rect.init extension
            center: Point(x: 4.0, y: 4.0),
            size: Size(width: 3.0, height: 3.0)
    )
}
//////////////////////////////////////////////////////////////////////////////////////////
private extension Int {
    mutating func square() {
        self = self * self
    }
}
private func useMutatingExtension() {
    var someInt = 3
    someInt.square() // someInt is now 9
}
///////////////////////////////////////////////////////////////////////////
private extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
private func useSubscriptExt() {
    746381295[0]
// returns 5
    746381295[1]
// returns 9
    746381295[2]
// returns 2
    746381295[8]
// returns 7
}
//////////////////////////////////////////////////////////////////////////////////////////
private extension Int {
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}
func useNestedTypeExt() {
    func printIntegerKinds(_ numbers: [Int]) {
        for number in numbers {
            switch number.kind {
            case .negative:
                print("- ", terminator: "")
            case .zero:
                print("0 ", terminator: "")
            case .positive:
                print("+ ", terminator: "")
            }
        }
        print("")
    }
    printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
    // Prints "+ + - 0 - 0 + "
}

