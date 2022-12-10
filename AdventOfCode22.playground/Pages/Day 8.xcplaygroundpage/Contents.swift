
import Foundation

let day8DataFileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let heightData = try String(contentsOf: day8DataFileURL!)
let lines = heightData.components(separatedBy: "\n")

let heightMatrix: [[Int]] = lines.compactMap { line in
    var heights: [Int] = []
    for char in line {
        if let heightValue = Int("\(char)") {
            heights.append(heightValue)
        }
    }
    if heights.isEmpty {
        return nil
    }
    return heights
}
let maxRowIdx = heightMatrix.count - 1


// Part 1:
// How many "visible" trees are there?
// visible == on the edge || higher than any tree to the edge in up, down, left, right
var visibleTreeCount = 0

for (rowIdx, row) in heightMatrix.enumerated() {
    if rowIdx == 0 || (rowIdx == maxRowIdx) {
        visibleTreeCount += row.count
        continue
    }
    let maxColIdx = row.count - 1
    var col = 0
    while col < row.count {
        if col == 0 || col == maxColIdx {
            visibleTreeCount += 1
        } else {
            let height = row[col]

            // Check Horizontal:
            let rightRange = (col + 1)..<row.count
            let leftRange = 0..<col
            let rightSlice = row[rightRange]
            let leftSlice = row[leftRange]

            if (leftSlice.max()! < height) || (rightSlice.max()! < height) {
                visibleTreeCount += 1
            } else {
                // Horizontal failed - check Vertical:
                let topRange = 0..<rowIdx
                let bottomRange = (rowIdx + 1)..<heightMatrix.count

                let topSlice: [Int] = heightMatrix[topRange].map({ $0[col] })
                let bottomSlice: [Int] = heightMatrix[bottomRange].map({ $0[col] })

                if (topSlice.max()! < height || bottomSlice.max()! < height) {
                    visibleTreeCount += 1
                }
            }
        }
        col += 1
    }
}

print(visibleTreeCount)

// Part 2:
// What is the highest possible "scenic score" in the forest?
// score determined by distance to tree that is at or bigger than itself, for each cardinal direction
// finalScore == leftScore * rightScore * topScore * bottomScore

func score(slice: [Int], height: Int) -> Int {
    var currentScore = 0
    for num in slice {
        if num < height {
            currentScore += 1
            continue
        } else {
            if num >= height {
                currentScore += 1
            }
            break
        }
    }
    let returnValue = currentScore > 0 ? currentScore : 1
    return returnValue
}

typealias TreeScoreAndPosition = (score: Int, position: (row: Int, col: Int))

var treePositionsAndScores: [TreeScoreAndPosition] = []

for (rowIdx, row) in heightMatrix.enumerated() {
    if rowIdx == 0 || (rowIdx == maxRowIdx) {
        // No op - skipping edges for "optimization"
        continue
    }
    let maxColIdx = row.count - 1
    var col = 0
    var scoreRow: [TreeScoreAndPosition] = []

    while col < row.count {
        if col == 0 || col == maxColIdx {
            // No op - Skipping edges for "optimization"
        } else {
            let height = row[col]

            // Horizontal Score:
            let rightRange = (col + 1)..<row.count
            let leftRange = 0..<col
            let rightSlice = row[rightRange]
            let leftSlice = row[leftRange]

            let rightSliceScore = score(slice: Array(rightSlice), height: height)
            let leftSliceScore = score(slice: Array(leftSlice).reversed(), height: height)

            // Vertical Score:
            let topRange = 0..<rowIdx
            let bottomRange = (rowIdx + 1)..<heightMatrix.count
            let topSlice: [Int] = heightMatrix[topRange].map({ $0[col] })
            let bottomSlice: [Int] = heightMatrix[bottomRange].map({ $0[col] })

            let topSliceScore = score(slice: topSlice.reversed(), height: height)
            let bottomSliceScore = score(slice: bottomSlice, height: height)

            print("left \(leftSliceScore), right: \(rightSliceScore), up: \(topSliceScore), down: \(bottomSliceScore)")
            let finalScore = leftSliceScore * rightSliceScore * topSliceScore * bottomSliceScore

            scoreRow.append(( (finalScore, (row: rowIdx, col: col)) ))

        }
        col += 1
    }
    treePositionsAndScores += scoreRow
}

print(treePositionsAndScores.sorted(by: { $0.score > $1.score }).debugDescription)
