import Foundation
/*
 Given a heightmap:
 - a = lowest, z = heighest
 - S = currentPosition (elevation a), E = best signal pos (elevation z)
 - destination square can be AT MOST one higher than the current
 - 1 move = 1 move left, right, up, down
 */

let inputData = try String(contentsOf: Bundle.main.url(forResource: "Input", withExtension: "txt")!)

typealias Point = (x: Int, y: Int)
typealias Path = [Point]

struct HeightMap {
    
    let map: [[Position]]
    var startPoint: Point = (0,0)
    var endPoint: Point = (0,0)
    
    init(textRepresentation: String) {
        let lines = textRepresentation.components(separatedBy: "\n").filter({ !$0.isEmpty })
        var map: [[Position]] = []
        for (y, line) in lines.enumerated() {
            var mapRow: [Position] = []
            for (x, char) in line.enumerated() {
                let position = Position(rawValue: char)!
                switch position {
                case .S:
                    startPoint = (x, y)
                case .E:
                    endPoint = (x, y)
                default:
                    break
                }
                mapRow.append(position)
            }
            map.append(mapRow)
        }
        self.map = map
    }
    
    enum Position: Character {
        case a = "a", b = "b", c = "c", d = "d", e = "e", f = "f", g = "g", h = "h", i = "i", j = "j", k = "k", l = "l", m = "m",
             n = "n", o = "o", p = "p", q = "q", r = "r", s = "s", t = "t", u = "u", v = "v", w = "w", x = "x", y = "y", z = "z", S = "S", E = "E"
        
        var heightValue: Int {
            switch self {
            case .a, .S:
                return 1
            case .b:
                return 2
            case .c:
                return 3
            case .d:
                return 4
            case .e:
                return 5
            case .f:
                return 6
            case .g:
                return 7
            case .h:
                return 8
            case .i:
                return 9
            case .j:
                return 10
            case .k:
                return 11
            case .l:
                return 12
            case .m:
                return 13
            case .n:
                return 14
            case .o:
                return 15
            case .p:
                return 16
            case .q:
                return 17
            case .r:
                return 18
            case .s:
                return 19
            case .t:
                return 20
            case .u:
                return 21
            case .v:
                return 22
            case .w:
                return 23
            case .x:
                return 24
            case .y:
                return 25
            case .z, .E:
                return 26
            }
        }
    }
    
    enum Direction: Hashable, CaseIterable, CustomStringConvertible {
        case up, down, left, right
        
        var delta: Point {
            switch self {
            case .up:
                return (0,-1)
            case .down:
                return (0,1)
            case .left:
                return (-1,0)
            case .right:
                return (1,0)
            }
        }
        
        var description: String {
            switch self {
            case .up:
                return "up"
            case .down:
                return "down"
            case .left:
                return "left"
            case .right:
                return "right"
            }
        }
    }
    
    func movesAtPosition(_ position: Point) -> [Direction: Int] {
        let maxY = map.count
        let maxX = map[0].count
        return Direction.allCases.reduce(into: [:], { partialResult, direction in
            let nextPosition: Point = (position.x + direction.delta.x, position.y + direction.delta.y)
            if (nextPosition.x < maxX && nextPosition.x >= 0) &&
               (nextPosition.y < maxY && nextPosition.y >= 0)
            {
                partialResult[direction] = map[nextPosition.y][nextPosition.x].heightValue
            }
        })
    }
    
    func pathFromStartToEnd() -> Path {
        var currentPoint = endPoint
        
        // How do we loop?
        var moves = movesAtPosition(currentPoint)
        while !moves.isEmpty {
            print("At \(currentPoint), we can move \(moves.debugDescription)")
            let currentPosition = map[currentPoint.y][currentPoint.x]
            if currentPosition == .E {
                break
            }
            for direction in Direction.allCases {
                if let moveHeight = moves[direction] {
                    if moveHeight == currentPosition.heightValue - 1 {
                        // Move this way
                        currentPoint = (currentPoint.x + direction.delta.x, currentPoint.y + direction.delta.y)
                        break
                    }
                    
                    
                }
            }
            moves = movesAtPosition(currentPoint)
            
        }
        
        
        return []
    }
}

let heightMap = HeightMap(textRepresentation: inputData)

print("Start \(heightMap.startPoint)")
print("End \(heightMap.endPoint)")

//for row in heightMap.map {
//    print(row.map({ $0.heightValue }))
//}

print("-------")

let path = heightMap.pathFromStartToEnd()

// How do we know we are going the right way? want a number that is one bigger!
// bias is for down?
