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

extension Int32 {
    var absMask: Int32 {
        return self >> 31 //0x1F = 31 // 0 если >=0, -1 если <0
    }
    var abs1: Int32 {
//        return abs(self)
        return (absMask ^ self) &- absMask //todo maybe &- redundant
    }
}

extension UInt8 {
    /**
     Приблизительная разница между двумя UInt по модулю
     */
    func diffAbs(_ other: UInt8) -> UInt8 {
        if self > other {
            return self - other
        }
        else {
            return other - self
        }
    }
}

var counter:Int = 0
