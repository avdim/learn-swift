import Foundation
import XCTest

/**
 Here’s an example of a protocol called Container, which declares an associated type called Item:
 */
private protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

/**
 The Container protocol defines three required capabilities that any container must provide:

It must be possible to add a new item to the container with an append(_:) method.
It must be possible to access a count of the items in the container through a count property that returns an Int value.
It must be possible to retrieve each item in the container with a subscript that takes an Int index value.
This protocol doesn’t specify how the items in the container should be stored or what type they’re allowed to be. The protocol only specifies the three bits of functionality that any type must provide in order to be considered a Container. A conforming type can provide additional functionality, as long as it satisfies these three requirements.

Any type that conforms to the Container protocol must be able to specify the type of values it stores. Specifically, it must ensure that only items of the right type are added to the container, and it must be clear about the type of the items returned by its subscript.

To define these requirements, the Container protocol needs a way to refer to the type of the elements that a container will hold, without knowing what that type is for a specific container. The Container protocol needs to specify that any value passed to the append(_:) method must have the same type as the container’s element type, and that the value returned by the container’s subscript will be of the same type as the container’s element type.

To achieve this, the Container protocol declares an associated type called Item, written as associatedtype Item. The protocol doesn’t define what Item is—that information is left for any conforming type to provide. Nonetheless, the Item alias provides a way to refer to the type of the items in a Container, and to define a type for use with the append(_:) method and subscript, to ensure that the expected behavior of any Container is enforced.

Here’s a version of the nongeneric IntStack type from Generic Types above, adapted to conform to the Container protocol:
 */

private struct IntStack: Container {
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

/**
 The IntStack type implements all three of the Container protocol’s requirements, and in each case wraps part of the IntStack type’s existing functionality to satisfy these requirements.

Moreover, IntStack specifies that for this implementation of Container, the appropriate Item to use is a type of Int. The definition of typealias Item = Int turns the abstract type of Item into a concrete type of Int for this implementation of the Container protocol.

Thanks to Swift’s type inference, you don’t actually need to declare a concrete Item of Int as part of the definition of IntStack. Because IntStack conforms to all of the requirements of the Container protocol, Swift can infer the appropriate Item to use, simply by looking at the type of the append(_:) method’s item parameter and the return type of the subscript. Indeed, if you delete the typealias Item = Int line from the code above, everything still works, because it’s clear what type should be used for Item.

You can also make the generic Stack type conform to the Container protocol:
 */

private struct Stack<Element>: Container {
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

/**
 This time, the type parameter Element is used as the type of the append(_:) method’s item parameter and the return type of the subscript. Swift can therefore infer that Element is the appropriate type to use as the Item for this particular container.
 */

//Extending an Existing Type to Specify an Associated Type:
/**
 You can extend an existing type to add conformance to a protocol, as described in Adding Protocol Conformance with an Extension. This includes a protocol with an associated type.

Swift’s Array type already provides an append(_:) method, a count property, and a subscript with an Int index to retrieve its elements. These three capabilities match the requirements of the Container protocol. This means that you can extend Array to conform to the Container protocol simply by declaring that Array adopts the protocol. You do this with an empty extension, as described in Declaring Protocol Adoption with an Extension:
 */
extension Array: Container {
}

/**
 Array’s existing append(_:) method and subscript enable Swift to infer the appropriate type to use for Item, just as for the generic Stack type above. After defining this extension, you can use any Array as a Container.
 */


//Generic Where Clauses
/**
 Type constraints, as described in Type Constraints, enable you to define requirements on the type parameters associated with a generic function, subscript, or type.

It can also be useful to define requirements for associated types. You do this by defining a generic where clause. A generic where clause enables you to require that an associated type must conform to a certain protocol, or that certain type parameters and associated types must be the same. A generic where clause starts with the where keyword, followed by constraints for associated types or equality relationships between types and associated types. You write a generic where clause right before the opening curly brace of a type or function’s body.

The example below defines a generic function called allItemsMatch, which checks to see if two Container instances contain the same items in the same order. The function returns a Boolean value of true if all items match and a value of false if they don’t.

The two containers to be checked don’t have to be the same type of container (although they can be), but they do have to hold the same type of items. This requirement is expressed through a combination of type constraints and a generic where clause:
 */

private func allItemsMatch<C1: Container, C2: Container>
        (_ someContainer: C1, _ anotherContainer: C2) -> Bool
        where C1.Item == C2.Item, C1.Item: Equatable {

    // Check that both containers contain the same number of items.
    if someContainer.count != anotherContainer.count {
        return false
    }

    // Check each pair of items to see if they're equivalent.
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }

    // All items match, so return true.
    return true
}
/**
 This function takes two arguments called someContainer and anotherContainer. The someContainer argument is of type C1, and the anotherContainer argument is of type C2. Both C1 and C2 are type parameters for two container types to be determined when the function is called.

The following requirements are placed on the function’s two type parameters:

C1 must conform to the Container protocol (written as C1: Container).
C2 must also conform to the Container protocol (written as C2: Container).
The Item for C1 must be the same as the Item for C2 (written as C1.Item == C2.Item).
The Item for C1 must conform to the Equatable protocol (written as C1.Item: Equatable).
The first and second requirements are defined in the function’s type parameter list, and the third and fourth requirements are defined in the function’s generic where clause.

These requirements mean:

someContainer is a container of type C1.
anotherContainer is a container of type C2.
someContainer and anotherContainer contain the same type of items.
The items in someContainer can be checked with the not equal operator (!=) to see if they’re different from each other.
The third and fourth requirements combine to mean that the items in anotherContainer can also be checked with the != operator, because they’re exactly the same type as the items in someContainer.

These requirements enable the allItemsMatch(_:_:) function to compare the two containers, even if they’re of a different container type.

The allItemsMatch(_:_:) function starts by checking that both containers contain the same number of items. If they contain a different number of items, there’s no way that they can match, and the function returns false.

After making this check, the function iterates over all of the items in someContainer with a for-in loop and the half-open range operator (..<). For each item, the function checks whether the item from someContainer isn’t equal to the corresponding item in anotherContainer. If the two items aren’t equal, then the two containers don’t match, and the function returns false.

If the loop finishes without finding a mismatch, the two containers match, and the function returns true.

Here’s how the allItemsMatch(_:_:) function looks in action:
 */

private func usage3() {
    var stackOfStrings = Stack<String>()
    stackOfStrings.push("uno")
    stackOfStrings.push("dos")
    stackOfStrings.push("tres")

    var arrayOfStrings = ["uno", "dos", "tres"]

    if allItemsMatch(stackOfStrings, arrayOfStrings) {
        print("All items match.")
    } else {
        print("Not all items match.")
    }
// Prints "All items match."
}
/**
 The example above creates a Stack instance to store String values, and pushes three strings onto the stack. The example also creates an Array instance initialized with an array literal containing the same three strings as the stack. Even though the stack and the array are of a different type, they both conform to the Container protocol, and both contain the same type of values. You can therefore call the allItemsMatch(_:_:) function with these two containers as its arguments. In the example above, the allItemsMatch(_:_:) function correctly reports that all of the items in the two containers match.
 */
