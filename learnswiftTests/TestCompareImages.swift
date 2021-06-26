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

let COLOR_THRESHOLD: Int = 40
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

    func nearPixels(_ x: Int, _ y: Int, _ distance: Int) -> Array<Pt> {
        var arr: Array<Pt> = []
        for dx in (-distance)...distance {
            for dy in (-distance)...distance {
                if (dx == dy || dx == -dy || dx == 0 || dy == 0) {
                    arr.append(Pt(x: dx, y: dy))
                }
            }
        }
        let mapped = arr.sorted(by: { a, b in
            a.size2() < b.size2()
        }).map { it in
            Pt(x: x + it.x, y: y + it.y)
        }
        return filterByImageSize(mapped)
    }

    var booleanResult = true
    for x in 0..<width {
        for y in 0..<height {
            if (x % 20 == 0 && y % 20 == 0) {
                print(x, y)
            }
            let good = nearPixels(x, y, DISTANCE).any { p2 in
                comparePixel(&expectPixels[x, y], &actualPixels[p2.x, p2.y])
            } &&
                    nearPixels(x, y, DISTANCE).any { p2 in
                        comparePixel(&expectPixels[p2.x, p2.y], &actualPixels[x, y])
                    } ||
                    filterByImageSize(
                            [
                                Pt(x: x + 1, y: y),
                                Pt(x: x - 1, y: y),
                                Pt(x: x, y: y + 1),
                                Pt(x: x, y: y - 1),
                                Pt(x: x + 1, y: y + 1), //Pt(x: x - 1,y:  y + 1), Pt(x: x + 1,y:  y - 1),
                                Pt(x: x - 1, y: y - 1),
                            ]
                    ).atLeast(count: 1) { p1 in
                        nearPixels(p1.x, p1.y, DISTANCE - 1).any { p2 in
                            comparePixel(&expectPixels[p1.x, p1.y], &actualPixels[p2.x, p2.y])
                        } &&
                                nearPixels(p1.x, p1.y, DISTANCE - 1).any { p2 in
                                    comparePixel(&expectPixels[p2.x, p2.y], &actualPixels[p1.x, p1.y])
                                }
                    }

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

func comparePixel(_ expect: inout CacheRGB, _ actual: inout CacheRGB) -> Bool {
    let rAbs = (expect.rInt - actual.rInt).abs1
    let gAbs = (expect.gInt - actual.gInt).abs1
    let bAbs = (expect.bInt - actual.bInt).abs1
    if (rAbs + gAbs + bAbs < COLOR_THRESHOLD) {
        return true
    }

    if (true) { // В будующем этот код можно удалить
        // Workaround. На GitHub Actions системный диалог showAlert не правильно отображает цвета.
        // Этот код вносит дополнительную проверку.
        // Если смещение цветов (r g b), домноженное на коэффициенты workaround.r, g, b даёт сумму меньше чем threshold,
        // то считаем что пиксель валидный
//    val workaround3 = WorkaroundColorsMultipliers(r = -0.40f, g = -0.31f, b = 1.24f)
        if (abs(-0.69 * Double(rAbs) - 0.89 * Double(gAbs) + 1.16 * Double(bAbs)) < 18.0) {
            return true
        }
        if (abs(-0.46 * Double(rAbs) - 0.47 * Double(gAbs) + 2.05 * Double(bAbs)) < 10.0) {
            return true
        }
    }

    return false
}

extension Int {
    var absMask: Int {
        return self >> 31 //0x1F = 31 // 0 если >=0, -1 если <0
    }
    var abs1: Int {
//        return abs(self)
        return (absMask ^ self) - absMask
    }
}

