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

struct HeightMap {
    
    let map: [[Position]]
    var startPoint: Point = (0,0)
    var endPoint: Point = (0,0)
    
    init(textRepresentation: String) {
        let lines = textRepresentation.components(separatedBy: "\n").filter({ !$0.isEmpty })
        var map: [[Position]] = []
        for (x, line) in lines.enumerated() {
            var mapRow: [Position] = []
            for (y, char) in line.enumerated() {
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
}

let heightMap = HeightMap(textRepresentation: inputData)

print("Start \(heightMap.startPoint)")
print("End \(heightMap.endPoint)")

for row in heightMap.map {
    print(row.map({ $0.heightValue }))
}
