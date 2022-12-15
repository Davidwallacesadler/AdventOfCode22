import Foundation

// Sand going into the abyss == we are passed the max X and maxY

let inputData = try String(contentsOf: Bundle.main.url(forResource: "Input", withExtension: "txt")!)

extension Int {
    var normalizedValue: Int {
        if self == 0 {
            return 0
        }
        if self < 0 {
            return -1
        }
        return 1
    }
}

struct Point: Hashable, Equatable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    init?(textRepresentation: String) {
        guard !textRepresentation.isEmpty else { return nil }
        let numbers: [Int] = textRepresentation.components(separatedBy: ",").compactMap({ Int($0) })
        guard numbers.count == 2 else { return nil }
        self.x = numbers[0]
        self.y = numbers[1]
    }
}

struct Rect {
    let topLeft: Point
    let topRight: Point
    let bottomLeft: Point
    let bottomRight: Point
}

var blockedPoints: Set<Point> = []

// Get the blocked points from the wall data
for line in inputData.components(separatedBy: "\n") {
    var lastPoint: Point? = nil
    for pointText in line.components(separatedBy: " -> ") {
        if let currentPoint = Point(textRepresentation: pointText) {
            if lastPoint != nil {
                let slopeY = currentPoint.y - lastPoint!.y
                let slopeX = currentPoint.x - lastPoint!.x
                if slopeY.magnitude > 1 || slopeX.magnitude > 1 {
                    let dy = slopeY.normalizedValue
                    let dx = slopeX.normalizedValue
                    var linePoints = [lastPoint!]
                    var linePoint = lastPoint!
                    while linePoint != currentPoint {
                        let next = Point(linePoint.x + dx, linePoint.y + dy)
                        linePoints.append(next)
                        linePoint = next
                    }
                    for point in linePoints {
                        blockedPoints.insert(point)
                    }
                } else {
                    blockedPoints.insert(currentPoint)
                }
                lastPoint = currentPoint
                continue
            }
            blockedPoints.insert(currentPoint)
            lastPoint = currentPoint
        }
    }
}

for point in blockedPoints {
    print(point.x, point.y)
}

let sandOrigin = Point(500, 0)
var aGrainHasLeftTheArea = false
var grainCount = 0

let outerBoundsPoint = blockedPoints.max(by: { $0.y < $1.y })!.y
let maxX = blockedPoints.max(by: { $0.x < $1.x })!.x

//print("lowest point \(outerBoundsPoint)")
while aGrainHasLeftTheArea == false {
    var nextPoint: Point? = Point(sandOrigin.x, sandOrigin.y)
    while nextPoint != nil {
        let next = nextPoint!
        print(next)
        // Fall first
        let down = Point(next.x, next.y + 1)
//        print("down \(down)")
        if !blockedPoints.contains(down) {
//            print("Sand moving down")
            if down.y > outerBoundsPoint {
                aGrainHasLeftTheArea = true
                break
            }
            nextPoint = down
            continue
        }
        // Then left
        let downLeft = Point(next.x - 1, next.y + 1)
        if !blockedPoints.contains(downLeft) {
//            print("Sand moving down left")
            if downLeft.y > outerBoundsPoint {
                aGrainHasLeftTheArea = true
                break
            }
            nextPoint = downLeft
            continue
        }
        // Then right
        let downRight = Point(next.x + 1, next.y + 1)
        if !blockedPoints.contains(downRight) {
//            print("Sand moving down right")
            if downRight.y > outerBoundsPoint {
                aGrainHasLeftTheArea = true
                break
            }
            nextPoint = downRight
            continue
        }
        // then rest
//        print("Sand at rest at \(next)")
        grainCount += 1
        blockedPoints.insert(next)
        nextPoint = nil
    }
}

print(grainCount)

//for y in 0...outerBoundsPoint {
//    var string = ""
//    for x in 0...maxX {
//        if blockedPoints.contains(Point(x, y)) {
//            string.append("#")
//        } else {
//            string.append(".")
//        }
//    }
//    print(string.suffix(10))
//    string = ""
//}

