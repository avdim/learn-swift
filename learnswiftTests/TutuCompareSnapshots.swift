//
// Created by Dim on 28.06.2021.
//

import Foundation
import XCTest

public let COLOR_THRESHOLD: Int32 = 40
let NEAR_DISTANCE: Int = 6
let MAX_BAD_POINTS_INSIDE_DISTANCE = 22
let BRUSH_SIZE = 4

enum SnapshotResult {
    case SUCCESS
    case FAIL(img: PixelWrapper)

    var success: Bool {
        switch (self) {
        case .SUCCESS:
            return true
        case .FAIL:
            return false
        }
    }

    var image: PixelWrapper? {
        switch (self) {
        case .SUCCESS:
            return nil
        case .FAIL(let img):
            return img
        }
    }
}

func compareTutuSnapshots(expectImg: CGImage, actualImg: CGImage) -> SnapshotResult { //todo return diff image ->(success:Bool, diff:CGImage?)
    print("execute", #function)
    let expectWrapper = PixelWrapper(cgImage: expectImg)
    let actualWrapper = PixelWrapper(cgImage: actualImg)
    let expect = expectWrapper.pixelBuffer
    let actual = actualWrapper.pixelBuffer

    let width = min(expectWrapper.width, actualWrapper.width)
    let height = Int(Double(min(expectWrapper.height, actualWrapper.height)) * 0.95)

    struct Helper {
        let cursor: XY
        let expect: UnsafeMutablePointer<RGB>
        let actual: UnsafeMutablePointer<RGB>
        let width: Int

        //todo optimize (less function calls) and array mappers
        func getNearPoints(_ point: XY, _ distance: Int) -> Array<XY> {
            return getZeroNearPoints(distance: distance).map { it in
                XY(point.x + it.x, point.y + it.y)
            }
            return [
                XY(point.x, point.y),
                XY(point.x, point.y),
                XY(point.x, point.y),
                XY(point.x, point.y),
                XY(point.x, point.y),
                XY(point.x, point.y),
                XY(point.x, point.y),
                XY(point.x, point.y),
                XY(point.x, point.y),
                XY(point.x, point.y),
            ]
            let squareSide = (2 * distance + 1)
            let square = squareSide * squareSide
            return Array<XY>(unsafeUninitializedCapacity: square) { buffer, initializedCount in
                for i in 0..<square {
                    buffer[i] = XY(point.x, point.y)
                }
                initializedCount = square
            }
        }

        @inlinable func comparePoints(_ expectedXY: XY, _ actualXY: XY) -> Bool {
            let expectedOffset = expectedXY.x + expectedXY.y * width
            let actualOffset = actualXY.x + actualXY.y * width
            return comparePixel(expect[expectedOffset], actual[actualOffset])
        }

        lazy var nearPoints: Array<XY> = {
            getNearPoints(cursor, NEAR_DISTANCE)
        }()

        lazy var expectedCursor: Bool = {
            // Сравниваем expected курсор с соседними ближайшими пикселями actual картинки
            //todo nearPoints drop first (cursor.x,cursor.y)
            comparePoints(cursor, cursor) || nearPoints.atLeast(count: 1) { it in
                comparePoints(cursor, it)
            }
        }()

        lazy var actualCursor: Bool = {
            // Сравниваем actual курсор с соседними ближайшими пикселями expected картинки
            return comparePoints(cursor, cursor) || nearPoints.atLeast(count: 1) { it in
                return comparePoints(it, cursor)
            }
        }()

        lazy var tryMoveCursor: Bool = {
            // Пробегаем курсором по этим точкам от предыдущей позиации:
            let cursorPoints =
                    [
                        XY(cursor.x + 1, cursor.y),
                        XY(cursor.x - 1, cursor.y),
                        XY(cursor.x, cursor.y + 1),
                        XY(cursor.x, cursor.y - 1),
                        XY(cursor.x + 1, cursor.y + 1), //Pt(x: x - 1,y:  y + 1), Pt(x: x + 1,y:  y - 1),
                        XY(cursor.x - 1, cursor.y - 1),
                    ]
            return cursorPoints.atLeast(count: 1) { cursor2 in
                let nearPoints: Array<XY> = [
                    XY(cursor2.x, cursor2.y),
                    XY(cursor2.x + 1, cursor2.y),
                    XY(cursor2.x - 1, cursor2.y),
                    XY(cursor2.x, cursor2.y + 1),
                    XY(cursor2.x + 1, cursor2.y + 1),
                    XY(cursor2.x - 1, cursor2.y + 1),
                    XY(cursor2.x, cursor2.y - 1),
                    XY(cursor2.x + 1, cursor2.y - 1),
                    XY(cursor2.x - 1, cursor2.y - 1),
                ]

                func expectedCursor2() -> Bool {
                    // Сравниваем expected курсор с соседними ближайшими пикселями actual картинки
                    return nearPoints.atLeast(count: 1) { it in
                        return comparePoints(cursor2, it)
                    }
                }

                func actualCursor2() -> Bool {
                    // Сравниваем actual курсор с соседними ближайшими пикселями expected картинки
                    return nearPoints.atLeast(count: 1) { it in
                        return comparePoints(it, cursor2)
                    }
                }

                return expectedCursor2() && actualCursor2()
            }
        }()
    }

    var badPointsSortedByY: Array<XY> = [] //Так как мы итерируем первый цикл по Y, то этот массив отсортирован по Y
    for y in NEAR_DISTANCE..<(height - NEAR_DISTANCE) {
        for x in NEAR_DISTANCE..<(width - NEAR_DISTANCE) {
            let xy = XY(x, y)
            var h = Helper(cursor: xy, expect: expect, actual: actual, width: width)
            let isGoodPoint = h.expectedCursor && h.actualCursor /*|| h.tryMoveCursor*/
            if (!isGoodPoint) {
                badPointsSortedByY.append(xy)
            }
        }
    }
    if (badPointsSortedByY.count > width * height / 4) {
        let diffWrapper = PixelWrapper(cgImage: actualImg)
        diffWrapper.mapEachPixel { rgb in
            RGB(rgb.r / 3, rgb.g / 3, rgb.b / 3)
        }
        for pt in badPointsSortedByY {
            diffWrapper[pt.x, pt.y] = RGB.red
        }
        return .FAIL(img: diffWrapper)
    }
    var visitedPoints: Set<XY> = []
    var failedPoints: Set<XY> = []
    for current in badPointsSortedByY {
        if (visitedPoints.contains(current)) {
            continue
        }

        let startIndex: Int
        if let it = badPointsSortedByY.binarySearchFirstIndex { p in
            p.y >= current.y - NEAR_DISTANCE
        } {
            startIndex = it
        } else {
            startIndex = 0
        }

        let endIndex: Int
        if let it = badPointsSortedByY.binarySearchLastIndex { p in
            p.y <= current.y + NEAR_DISTANCE
        } {
            endIndex = it
        } else {
            endIndex = badPointsSortedByY.count - 1
        }

        var badPointsNear: Set<XY> = []
        for i in startIndex...endIndex {
            let p = badPointsSortedByY[i]
            if (p != current && current.distance(p) <= NEAR_DISTANCE) {
                badPointsNear.insert(p)
            }
        }
        if (badPointsNear.count >= MAX_BAD_POINTS_INSIDE_DISTANCE) {
            failedPoints.insert(current)
            visitedPoints.insertAll(badPointsNear)
        }
    }

    if (!failedPoints.isEmpty) {
        let diffWrapper = PixelWrapper(cgImage: actualImg)
        diffWrapper.mapEachPixel { rgb in
            RGB(rgb.r / 3, rgb.g / 3, rgb.b / 3)
        }
        for pt in failedPoints {
            let brushSize = 0
            for y in (pt.y - BRUSH_SIZE)...(pt.y + BRUSH_SIZE) {
                for x in (pt.x - BRUSH_SIZE)...(pt.x + BRUSH_SIZE) {
                    if x >= 0 && y >= 0 && x < width && y < height {
                        diffWrapper[x, y] = RGB.red
                    }
                }
            }
        }
        return .FAIL(img: diffWrapper)
    } else {
        return .SUCCESS
    }
//    return if (booleanResult) {
//        SnapshotResult.Success
//    } else {
//        SnapshotResult.Fail(diffPixels)
//    }
}

public struct XY: Hashable {
    public let x: Int
    public let y: Int

    public init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    func distance(_ other: XY) -> Int {
        max(abs(x - other.x), abs(y - other.y))
    }
}

public var comparePixelsCache: [Int32: Bool] = [:]

@inlinable func comparePixel(_ expect: RGB, _ actual: RGB) -> Bool {
    //Это коммутативная функцния, порядок аргументов не имеет значения
    func comparePixelsLogic(_ expect: RGB, _ actual: RGB) -> Bool {
        let rAbs = abs(expect.r - actual.r)
        let gAbs = abs(expect.g - actual.g)
        let bAbs = abs(expect.b - actual.b)
        if rAbs + gAbs + bAbs < COLOR_THRESHOLD {
            return true
        }

        if true { // В будующем этот код можно удалить
            // Workaround. На GitHub Actions системный диалог showAlert не правильно отображает цвета.
            // Этот код вносит дополнительную проверку.
            // Если смещение цветов (r g b), домноженное на коэффициенты workaround.r, g, b даёт сумму меньше чем threshold,
            // то считаем что пиксель валидный
            // val workaround3 = WorkaroundColorsMultipliers(r = -0.40f, g = -0.31f, b = 1.24f)
            if (abs(-0.69 * Double(rAbs) - 0.89 * Double(gAbs) + 1.16 * Double(bAbs)) < 18.0) {
                return true
            }
            if (abs(-0.46 * Double(rAbs) - 0.47 * Double(gAbs) + 2.05 * Double(bAbs)) < 11.5) {
                return true
            }
        }
        return false
    }

    //Поскольку сама функция коммутативна, то и хэш функция тоже коммутативна:
    let cacheKey: Int32 = expect ^ actual
    let result: Bool
    if let value = comparePixelsCache[cacheKey] {
        result = value
    } else {
        result = comparePixelsLogic(expect, actual)
        comparePixelsCache[cacheKey] = result
    }
    return result
}

public var nearZoneCache: [Int: Array<XY>] = [:]

@inlinable func getZeroNearPoints(distance: Int) -> [XY] {
    if (nearZoneCache[distance] == nil) {
        nearZoneCache[distance] = getZeroNearPointsLogic(distance: distance)
    }
    return nearZoneCache[distance]!
}

@inlinable func getZeroNearPointsLogic(distance: Int) -> Array<XY> {
    var arr: Array<XY> = []
    for dx in (-distance)...distance {
        for dy in (-distance)...distance {
            if (dx == dy || dx == -dy || dx == 0 || dy == 0) {
                arr.append(XY(dx, dy))
            }
        }
    }
    return arr.sorted(by: { a, b in
        a.y.abs1 < b.y.abs1 || a.x.abs1 < b.x.abs1
    })
}
