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

    func filterByImageSize(_ arr: Array<Pt>) -> Array<Pt> {
        return arr
        arr.filter { it in
            it.x >= 0 && it.x < width && it.y >= 0 && it.y < height
        }
    }

    func calcNearPixels(_ x: Int, _ y: Int, _ distance: Int) -> Array<Pt> {
        let mapped = getNearZone(distance: distance).map { it in
            Pt(x: x + it.x, y: y + it.y)
        }
        return filterByImageSize(mapped)
    }

    var booleanResult = true

    for y in BRUSH_SIZE..<(height - BRUSH_SIZE) {
        for x in BRUSH_SIZE..<(width - BRUSH_SIZE) {
            let nearPixels: Array<Pt> = calcNearPixels(x, y, MATCH_DISTANCE)

            func expectedCursor() -> Bool {
                let cursorPixel = expect[x + y * width]
                // Сравниваем expected курсор с соседними ближайшими пикселями actual картинки
                return nearPixels.atLeast(count: 1) { it in
                    return comparePixel(cursorPixel, actual[it.x + it.y * width])
                }
            }

            func actualCursor() -> Bool {
                let cursorPixel = actual[x + y * width]
                // Сравниваем actual курсор с соседними ближайшими пикселями expected картинки
                return nearPixels.atLeast(count: 1) { it in
                    return comparePixel(expect[it.x + it.y * width], cursorPixel)
                }
            }

            func tryMoveCursor() -> Bool {
                // Пробегаем курсором по этим точкам от предыдущей позиации:
                let cursorPoints = filterByImageSize(
                        [
                            Pt(x: x + 1, y: y),
                            Pt(x: x - 1, y: y),
                            Pt(x: x, y: y + 1),
                            Pt(x: x, y: y - 1),
                            Pt(x: x + 1, y: y + 1), //Pt(x: x - 1,y:  y + 1), Pt(x: x + 1,y:  y - 1),
                            Pt(x: x - 1, y: y - 1),
                        ]
                )
                return cursorPoints.atLeast(count: 1) { cursor in
                    let nearPixels: Array<Pt> = calcNearPixels(cursor.x, cursor.y, MATCH_DISTANCE - 1)

                    func expectedCursor2() -> Bool {
                        // Сравниваем expected курсор с соседними ближайшими пикселями actual картинки
                        let pixelAtCursor = expect[cursor.x + cursor.y * width]
                        return nearPixels.atLeast(count: 1) { it in
                            return comparePixel(pixelAtCursor, actual[it.x + it.y * width])
                        }
                    }

                    func actualCursor2() -> Bool {
                        // Сравниваем actual курсор с соседними ближайшими пикселями expected картинки
                        let pixelAtCursor = actual[cursor.x + cursor.y * width]
                        return nearPixels.atLeast(count: 1) { it in
                            return comparePixel(expect[it.x + it.y * width], pixelAtCursor)
                        }
                    }

                    return expectedCursor2() && actualCursor2()
                }
            }

            let good = expectedCursor() && actualCursor() || tryMoveCursor()

            if (!good) {
                booleanResult = false
//                let brushSize = 6
                for py in (y - BRUSH_SIZE)...(y + BRUSH_SIZE) {
                    for px in (x - BRUSH_SIZE)...(x + BRUSH_SIZE) {
                        diffWrapper.pixelBuffer[px + py * width] = RGB.red
                    }
                }
            }

        }
    }
    //todo move up
    diffWrapper.saveToFile(name: "after.png")

    return booleanResult
//    return if (booleanResult) {
//        SnapshotResult.Success
//    } else {
//        SnapshotResult.Fail(diffPixels)
//    }
}

struct Pt {
    let x: Int
    let y: Int

    func size2() -> Int {
        x * x + y * y
    }
}

func comparePixel(_ expect: RGB, _ actual: RGB) -> Bool {
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

var nearZoneCache: [Int: Array<Pt>] = [:]

func getNearZone(distance: Int) -> [Pt] {
    if (nearZoneCache[distance] == nil) {
        var arr: Array<Pt> = []
        for dx in (-distance)...distance {
            for dy in (-distance)...distance {
                if (dx == dy || dx == -dy || dx == 0 || dy == 0) {
                    arr.append(Pt(x: dx, y: dy))
                }
            }
        }
        nearZoneCache[distance] = arr.sorted(by: { a, b in
            a.y.abs1 < b.y.abs1 || a.x.abs1 < b.x.abs1
        })
    }
    return nearZoneCache[distance]!
}


