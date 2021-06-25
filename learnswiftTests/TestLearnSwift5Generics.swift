import Foundation
import XCTest

//Adding Constraints to an Associated Type
/**
 You can add type constraints to an associated type in a protocol to require that conforming types satisfy those constraints. For example, the following code defines a version of Container that requires the items in the container to be equatable.
 */
private protocol Container2 {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

/**
 To conform to this version of Container, the container’s Item type has to conform to the Equatable protocol.
 */
//Using a Protocol in Its Associated Type’s Constraints
/**
 A protocol can appear as part of its own requirements. For example, here’s a protocol that refines the Container protocol, adding the requirement of a suffix(_:) method. The suffix(_:) method returns a given number of elements from the end of the container, storing them in an instance of the Suffix type.
 */

private protocol SuffixableContainer: Container2 {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}

/**
 In this protocol, Suffix is an associated type, like the Item type in the Container example above. Suffix has two constraints: It must conform to the SuffixableContainer protocol (the protocol currently being defined), and its Item type must be the same as the container’s Item type. The constraint on Item is a generic where clause, which is discussed in Associated Types with a Generic Where Clause below.
 */
/**
 Here’s an extension of the Stack type from Generic Types above that adds conformance to the SuffixableContainer protocol:
 */

extension Stack: SuffixableContainer {
    func suffix(_ size: Int) -> Stack {
        var result = Stack()
        for index in (count - size)..<count {
            result.append(self[index])
        }
        return result
    }

    // Inferred that Suffix is Stack.
}

private func usageOfStack() {
    var stackOfInts = Stack<Int>()
    stackOfInts.append(10)
    stackOfInts.append(20)
    stackOfInts.append(30)
    let suffix = stackOfInts.suffix(2)
// suffix contains 20 and 30
}

/**
 In the example above, the Suffix associated type for Stack is also Stack, so the suffix operation on Stack returns another Stack. Alternatively, a type that conforms to SuffixableContainer can have a Suffix type that’s different from itself—meaning the suffix operation can return a different type. For example, here’s an extension to the nongeneric IntStack type that adds SuffixableContainer conformance, using Stack<Int> as its suffix type instead of IntStack:
 */
extension IntStack: SuffixableContainer {
    func suffix(_ size: Int) -> Stack<Int> {
        var result = Stack<Int>()
        for index in (count - size)..<count {
            result.append(self[index])
        }
        return result
    }

    // Inferred that Suffix is Stack<Int>.
}

//Такой же как в предыдущей главе, за исключение !!! <Element:Equatable> !!!
private struct Stack<Element: Equatable>: Container2 {
    // original Stack<Element> implementation
    var items: [Element] = []

    mutating func push(_ item: Element) {
        items.append(item)
    }

    mutating func pop() -> Element {
        return items.removeLast()
    }

    // conformance to the Container protocol
    mutating func append(_ item: Element) {
        self.push(item)
    }

    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}

//Такой же как в предыдущей главе
private struct IntStack: Container2 {
    // original IntStack implementation
    var items: [Int] = []

    mutating func push(_ item: Int) {
        items.append(item)
    }

    mutating func pop() -> Int {
        return items.removeLast()
    }

    // conformance to the Container protocol
    typealias Item = Int

    mutating func append(_ item: Int) {
        self.push(item)
    }

    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}
