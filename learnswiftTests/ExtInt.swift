//
// Created by Dim on 26.06.2021.
//

import Foundation

extension Int {
    var absMask: Int {
        return self >> 31 //0x1F = 31 // 0 если >=0, -1 если <0
    }
    var abs1: Int {
//        return abs(self)
        return (absMask ^ self) - absMask
    }
}
