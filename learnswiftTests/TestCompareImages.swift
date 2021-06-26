//
// Created by Dim on 22.06.2021.
//

import Foundation
import XCTest

class TestCompareImages: XCTestCase {

    func testCompareSuccessImages() {
        let imageGH: CGImage = getProjectDirImage(imagePath: "compare/github/MainScreenUITests/testEmptyArrivalStationAlert.1.png")
        let imageLocal = getProjectDirImage(imagePath: "compare/local/MainScreenUITests/testEmptyArrivalStationAlert.1.png")
        XCTAssertTrue(compareTutuSnapshots(expectImg: imageLocal, actualImg: imageGH))
    }

    func testCompareFailedImages() {
        let imageGH = getProjectDirImage(imagePath: "compare/github/InfoUITests/testSchedulePastDateActionSheet.1.png")
        let imageLocal = getProjectDirImage(imagePath: "compare/local/InfoUITests/testSchedulePastDateActionSheet.1.png")
        XCTAssertFalse(compareTutuSnapshots(expectImg: imageLocal, actualImg: imageGH))
    }

}

let COLOR_THRESHOLD: Int32 = 40
let MATCH_DISTANCE: Int = 2
let BRUSH_SIZE = MATCH_DISTANCE + 1 //BRUSH_SIZE must me >= DISTANCE

func compareTutuSnapshots(expectImg: CGImage, actualImg: CGImage) -> Bool { //todo return diff image ->(success:Bool, diff:CGImage?)
    let expectWrapper = PixelWrapper(cgImage: expectImg)
    let actualWrapper = PixelWrapper(cgImage: actualImg)
    let diffWrapper = PixelWrapper(cgImage: actualImg)
    let expect = expectWrapper.pixelBuffer
    let actual = actualWrapper.pixelBuffer

    //todo optimize
    diffWrapper.mapEachPixel { rgb in
        RGB(rgb.r / 3, rgb.g / 3, rgb.b / 3)
    }
//    diffWrapper.saveToFile(name: "before.png")

    let width = min(expectWrapper.width, actualWrapper.width)
    let height = Int(Double(min(expectWrapper.height, actualWrapper.height)) * 0.95)

    func getNearPoints(_ x: Int, _ y: Int, _ distance: Int) -> Array<XY> {
        return getZeroNearPoints(distance: distance).map { it in
            XY(x: x + it.x, y: y + it.y)
        }
    }

    func goodPoint(_ x: Int, _ y: Int) -> Bool {
        let nearPoints: Array<XY> = getNearPoints(x, y, MATCH_DISTANCE)

        func expectedCursor() -> Bool {
            let cursorPixel = expect[x + y * width]
            // Сравниваем expected курсор с соседними ближайшими пикселями actual картинки
            return nearPoints.atLeast(count: 1) { it in
                return comparePixel(cursorPixel, actual[it.x + it.y * width])
            }
        }

        func actualCursor() -> Bool {
            let cursorPixel = actual[x + y * width]
            // Сравниваем actual курсор с соседними ближайшими пикселями expected картинки
            return nearPoints.atLeast(count: 1) { it in
                return comparePixel(expect[it.x + it.y * width], cursorPixel)
            }
        }

        func tryMoveCursor() -> Bool {
            // Пробегаем курсором по этим точкам от предыдущей позиации:
            let cursorPoints =
                    [
                        XY(x: x + 1, y: y),
                        XY(x: x - 1, y: y),
                        XY(x: x, y: y + 1),
                        XY(x: x, y: y - 1),
                        XY(x: x + 1, y: y + 1), //Pt(x: x - 1,y:  y + 1), Pt(x: x + 1,y:  y - 1),
                        XY(x: x - 1, y: y - 1),
                    ]
            return cursorPoints.atLeast(count: 1) { cursor in
                let nearPoints: Array<XY> = getNearPoints(cursor.x, cursor.y, MATCH_DISTANCE - 1)

                func expectedCursor2() -> Bool {
                    // Сравниваем expected курсор с соседними ближайшими пикселями actual картинки
                    let pixelAtCursor = expect[cursor.x + cursor.y * width]
                    return nearPoints.atLeast(count: 1) { it in
                        return comparePixel(pixelAtCursor, actual[it.x + it.y * width])
                    }
                }

                func actualCursor2() -> Bool {
                    // Сравниваем actual курсор с соседними ближайшими пикселями expected картинки
                    let pixelAtCursor = actual[cursor.x + cursor.y * width]
                    return nearPoints.atLeast(count: 1) { it in
                        return comparePixel(expect[it.x + it.y * width], pixelAtCursor)
                    }
                }

                return expectedCursor2() && actualCursor2()
            }
        }

        return expectedCursor() && actualCursor() || tryMoveCursor()
    }

    var badPoints: Array<XY> = []
    for y in BRUSH_SIZE..<(height - BRUSH_SIZE) {
        for x in BRUSH_SIZE..<(width - BRUSH_SIZE) {
            if (!goodPoint(x, y)) {
                badPoints.append(XY(x: x, y: y))
            }
        }
    }

    for pt in badPoints {
        for y in (pt.y - BRUSH_SIZE)...(pt.y + BRUSH_SIZE) {
            for x in (pt.x - BRUSH_SIZE)...(pt.x + BRUSH_SIZE) {
                diffWrapper.pixelBuffer[x + y * width] = RGB.red
            }
        }
    }

    //todo move up
    diffWrapper.saveToFile(name: "diff.png")

    return badPoints.isEmpty
//    return if (booleanResult) {
//        SnapshotResult.Success
//    } else {
//        SnapshotResult.Fail(diffPixels)
//    }
}

struct XY {
    let x: Int
    let y: Int
}

var comparePixelsCache: [Int32: Bool] = [:]

func comparePixel(_ expect: RGB, _ actual: RGB) -> Bool {
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
            if (abs(-0.46 * Double(rAbs) - 0.47 * Double(gAbs) + 2.05 * Double(bAbs)) < 10.0) {
                return true
            }
        }
        return false
    }

    //Поскольку сама функция коммутативна, то и хэш функция тоже коммутативна:
    let hashKey: Int32 = expect ^ actual
    let result: Bool
    if let value = comparePixelsCache[hashKey] {
        result = value
    } else {
        result = comparePixelsLogic(expect, actual)
        comparePixelsCache[hashKey] = result
    }
    return result
}

var nearZoneCache: [Int: Array<XY>] = [:]

func getZeroNearPoints(distance: Int) -> [XY] {
    if (nearZoneCache[distance] == nil) {
        var arr: Array<XY> = []
        for dx in (-distance)...distance {
            for dy in (-distance)...distance {
                if (dx == dy || dx == -dy || dx == 0 || dy == 0) {
                    arr.append(XY(x: dx, y: dy))
                }
            }
        }
        nearZoneCache[distance] = arr.sorted(by: { a, b in
            a.y.abs1 < b.y.abs1 || a.x.abs1 < b.x.abs1
        })
    }
    return nearZoneCache[distance]!
}


