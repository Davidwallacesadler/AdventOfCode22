
import Foundation

let day9DataFileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let movesData = try String(contentsOf: day9DataFileURL!)
let moveLines = movesData.components(separatedBy: "\n")

struct Position: Hashable {
    var x: Int
    var y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

struct RopeMotion {
    let direction: Direction
    let magnitude: Int

    enum Direction: String {
        case right = "R",
             left = "L",
             up = "U",
             down = "D"

        var positionDelta: Position {
            switch self {
            case .right:
                return Position(1,0)
            case .left:
                return Position(-1,0)
            case .up:
                return Position(0,1)
            case .down:
                return Position(0,-1)
            }
        }
    }

    init?(textRepresentation: String) {
        guard !textRepresentation.isEmpty else { return nil }
        let components = textRepresentation.components(separatedBy: " ")
        self.direction = Direction(rawValue: components[0])!
        self.magnitude = Int(components[1])!
    }
}

let ropeMotions = moveLines.compactMap({ RopeMotion(textRepresentation: $0) })

func uniqueTailPositionCount(knotCount: Int) -> Int {

    var knotPositions = Array(repeating: Position(0,0), count: knotCount)
    var uniqueTailEndPositions: Set<Position> = [Position(0,0)] // Of the LAST knot

    for motion in ropeMotions {
        for _ in 0..<motion.magnitude {
            var lastIdx: Int? = nil
            for knotIdx in 0..<knotPositions.count {
                if let last = lastIdx {
                    let deltaX = knotPositions[knotIdx].x - knotPositions[last].x
                    let deltaY = knotPositions[knotIdx].y - knotPositions[last].y

                    if deltaX.magnitude > 1 || deltaY.magnitude > 1 {
                        if deltaX < 0 {
                            knotPositions[knotIdx].x += 1
                        } else if deltaX > 0 {
                            knotPositions[knotIdx].x -= 1
                        }

                        if deltaY < 0 {
                            knotPositions[knotIdx].y += 1
                        } else if deltaY > 0 {
                            knotPositions[knotIdx].y -= 1
                        }

                        if knotIdx == knotPositions.count - 1 {
                            uniqueTailEndPositions.insert(knotPositions[knotIdx])
                        }
                    }
                    lastIdx = knotIdx
                } else {
                    // HEAD
                    knotPositions[knotIdx].x += motion.direction.positionDelta.x
                    knotPositions[knotIdx].y += motion.direction.positionDelta.y
                    lastIdx = knotIdx
                }
            }
        }
    }

    return uniqueTailEndPositions.count
}

let part1 = uniqueTailPositionCount(knotCount: 2)
let part2 = uniqueTailPositionCount(knotCount: 10)
