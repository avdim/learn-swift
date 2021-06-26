//
// Created by Dim on 26.06.2021.
//

import Foundation

extension Array {
    /**
     If any element match predicate
     */
    func any(predicate: (Element) -> Bool) -> Bool {
        for e in self {
            if (predicate(e)) {
                return true
            }
        }
        return false
    }

    func atLeast(count: Int = 1, predicate: (Element) -> Bool) -> Bool {
        var match = 0
        for element in self {
            if (predicate(element)) {
                match += 1
                if (match >= count) {
                    return true
                }
            }
        }
        return false
    }
}

