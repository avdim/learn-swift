//
// Created by Dim on 22.06.2021.
//

import Foundation
import XCTest

class TestCompareImages: XCTestCase {

    func testCompareSuccessImages() {
        let imageGH: CGImage = getProjectDirImage(imagePath: "compare/github/MainScreenUITests/testEmptyArrivalStationAlert.1.png")
        let imageLocal = getProjectDirImage(imagePath: "compare/local/MainScreenUITests/testEmptyArrivalStationAlert.1.png")
        XCTAssertTrue(compareTutuSnapshots(expect: imageLocal, actual: imageGH))
    }

    func testCompareFailedImages() {
        let imageGH = getProjectDirImage(imagePath: "compare/github/InfoUITests/testSchedulePastDateActionSheet.1.png")
        let imageLocal = getProjectDirImage(imagePath: "compare/local/InfoUITests/testSchedulePastDateActionSheet.1.png")
        XCTAssertFalse(compareTutuSnapshots(expect: imageLocal, actual: imageGH))
    }

}

let COLOR_THRESHOLD: UInt8 = 40
let DISTANCE: Int = 2

func compareTutuSnapshots(expect: CGImage, actual: CGImage) -> Bool { //todo return diff image ->(success:Bool, diff:CGImage?)
    let expectPixels = PixelWrapper(cgImage: expect)
    let actualPixels = PixelWrapper(cgImage: actual)
    let diffPixels = PixelWrapper(cgImage: actual)
    diffPixels.mapEachPixel { rgb in
        RGB(rgb.r / 3, rgb.g / 3, rgb.b / 3)
    }
    diffPixels.saveToFile(name: "before.png")

    let width = min(expectPixels.width, actualPixels.width)
    let height = Int(Double(min(expectPixels.height, actualPixels.height)) * 0.95)

    func filterByImageSize(_ arr: Array<Pt>) -> Array<Pt> {
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
    for x in 0..<width {
        for y in 0..<height {
            let nearPixels: Array<Pt> = calcNearPixels(x, y, DISTANCE)

            func actualNearExpectedMatch() -> Bool {
                return nearPixels.atLeast(count: 1) { it in
                    comparePixel(expectPixels[x, y], actualPixels[it.x, it.y])
                }
            }

            func expectedNearActualMatch() -> Bool {
                return nearPixels.atLeast(count: 1) { it in
                    comparePixel(expectPixels[it.x, it.y], actualPixels[x, y])
                }
            }

            func cursorPointsMatch() -> Bool {
                // Пробегаем курсором по этим точкам:
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
                    let nearCursor: Array<Pt> = calcNearPixels(cursor.x, cursor.y, DISTANCE - 1)

                    func actualNearCursorMatch() -> Bool {
                        return nearCursor.atLeast(count: 1) { it in
                            comparePixel(expectPixels[cursor.x, cursor.y], actualPixels[it.x, it.y])
                        }
                    }

                    func expectedNearCursorMatch() -> Bool {
                        return nearCursor.atLeast(count: 1) { it in
                            comparePixel(expectPixels[it.x, it.y], actualPixels[cursor.x, cursor.y])
                        }
                    }

                    return actualNearCursorMatch() && expectedNearCursorMatch()
                }
            }

            let good = actualNearExpectedMatch() && expectedNearActualMatch() || cursorPointsMatch()

            if (!good) {
                booleanResult = false
                let brushSize = 6
                for px in (x - brushSize)...(x + brushSize) {
                    for py in (y - brushSize)...(y + brushSize) {
                        if (px > 0 && py > 0 && px < width && py < height) {
                            diffPixels.setPixel(px, py, RGB.red)
                        }
                    }
                }
            }

        }
    }
    //todo move up
    diffPixels.saveToFile(name: "after.png")

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
    let rAbs = expect.r.diff(actual.r)
    let gAbs = expect.g.diff(actual.g)
    let bAbs = expect.b.diff(actual.b)
    let sum: UInt8 = rAbs / 3 + gAbs / 3 + bAbs / 3
    let condition: UInt8 = COLOR_THRESHOLD / 3
    if sum < condition {
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
            a.size2() < b.size2()
        })
    }
    return nearZoneCache[distance]!
}


