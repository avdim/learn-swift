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
        return (absMask ^ self) &- absMask //todo maybe &- redundant
    }
}

extension UInt8 {
    var absMask: UInt8 {
        return self >> 7 // 0 если >=0, -1 если <0
    }
    var abs1: UInt8 {
//        return abs(self)
        return (absMask ^ self) &- absMask
    }
    func diff(_ other: UInt8) -> UInt8 {
        return UInt8(self.distance(to: other).abs1)
        return (self &- other).abs1
    }
}

