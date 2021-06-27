//
// Created by Dim on 27.06.2021.
//

import Foundation

extension Array {

    /**
     * Ищем первый элемент с condition(it) == true. Если все элементы false, вернём null.
     * List должен быть отсортирован по правилу: Слева contidion false, справа true.
     * Например [false, false, true, true] вернёт индекс 2
     * @see (https://medium.com/@elizarov/programming-binary-search-6e999783ba5d)
     */
    func binarySearchFirstIndex(condition: (Element) -> Bool) -> Int? {
        var l = -1
        var r = count
        while (l + 1 < r) {
            let m = (l + r) >> 1 // m = (l + r) / 2
            if (condition(self[m])) {
                r = m // Отличие
            } else {
                l = m // Отличие
            }
        }
        if (r == count) {
            return nil // Отличие
        }
        return r // Отличие
    }

    /**
     * Ищем последний элемент с condition(it) == true. Если все элементы false, вернём null.
     * List должен быть отсортирован по правилу: Слева contidion true, справа false.
     * Например [true, true, false, false] вернёт индекс 1
     * @see (https://medium.com/@elizarov/programming-binary-search-6e999783ba5d)
     */
    func binarySearchLastIndex(condition: (Element) -> Bool) -> Int? {
        var l = -1
        var r = count
        while (l + 1 < r) {
            let m = (l + r) >> 1 // m = (l + r) / 2
            if (condition(self[m])) {
                l = m // Отличие
            } else {
                r = m // Отличие
            }
        }
        if (l == -1) {
            return nil // Отличие
        }
        return l // Отличие
    }
}
