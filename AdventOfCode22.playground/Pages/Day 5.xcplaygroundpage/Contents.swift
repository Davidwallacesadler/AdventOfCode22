
import Foundation

let dayFiveDataFileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let stacksAndMovesData = try String(contentsOf: dayFiveDataFileURL!)
let stacksAndMoves = stacksAndMovesData.components(separatedBy: "\n\n").filter({ !$0.isEmpty })

let stacksDataString = stacksAndMoves.first!
let movesDataString = stacksAndMoves.last!

let stackDataStrings = stacksDataString.components(separatedBy: "\n")

typealias BoxCharAndCol = (char: Character, column: Int)

// Tie the character to its position in the string (tells us the group its in):
var boxLevels: [[BoxCharAndCol]] = []
for line in stackDataStrings {
    var boxNames: [BoxCharAndCol] = []
    for (charIdx, char) in line.enumerated() {
        if char.isLetter {
            boxNames.append((char, charIdx))
        }
    }
    if !boxNames.isEmpty {
        boxLevels.append(boxNames)
    }
}

// Encapuslate a stack with a number to map from boxLevels:
struct BoxStack {
    let number: Int
    var list: [Character]

    var lastChar: Character? {
        return list.last
    }

    mutating func append(_ new: Character) {
        list.append(new)
    }

    mutating func append(list: [Character]) {
        self.list += list
    }

    mutating func pop() -> Character? {
        if list.count > 0 {
            return list.removeLast()
        }
        return nil
    }

    mutating func pop(amount: Int) -> [Character] {
        let idxRange = (list.count - amount)..<list.count
        let poppedSlice = list[idxRange]
        list.removeSubrange(idxRange)
        return Array(poppedSlice)
    }
}

// Map using column ID and keep track of the top stack number:
var stackMap: [Int: BoxStack] = [:]
var maxStackNumber: Int = 1

for level in boxLevels.reversed() {
    for (char, id) in level {
        if let _ = stackMap[id] {
            stackMap[id]?.append(char)
        } else {
            let newStack = BoxStack(number: maxStackNumber, list: [char])
            stackMap[id] = newStack
            maxStackNumber += 1
        }
    }
}

// Sort stacks by number to make indexing easy:
var boxStacksPartOne: [BoxStack] = stackMap.values.sorted(by: { $0.number < $1.number })

// Parse move data string:
typealias BoxMove = (amount: Int, fromIdx: Int, toIdx: Int)

let moves: [BoxMove] = movesDataString.components(separatedBy: "\n").compactMap { line in
    let numbers = line.components(separatedBy: CharacterSet.decimalDigits.inverted).filter({ !$0.isEmpty }).compactMap({ Int($0) })
    guard numbers.count == 3 else { return nil }
    return (numbers[0], numbers[1] - 1, numbers[2] - 1)
}

// Part 1: Crane can only grame one box per move
for move in moves {
    if move.amount < 1 { continue }
    for _ in 0..<move.amount {
        let moveChar = boxStacksPartOne[move.fromIdx].pop()
        if let char = moveChar {
            boxStacksPartOne[move.toIdx].append(char)
        }
    }
}

var partOnefinalString: String = ""

for stack in boxStacksPartOne {
    if let lastChar = stack.lastChar {
        partOnefinalString.append("\(lastChar)")
    }
}

print(partOnefinalString)

// Part 2: single and multiple grabbed by crane
var boxStacksPartTwo: [BoxStack] = stackMap.values.sorted(by: { $0.number < $1.number })
for move in moves {
    if move.amount < 1 { continue }
    if move.amount == 1 {
        let moveChar = boxStacksPartTwo[move.fromIdx].pop()
        if let char = moveChar {
            boxStacksPartTwo[move.toIdx].append(char)
        }
    } else {
        let moveChars = boxStacksPartTwo[move.fromIdx].pop(amount: move.amount)
        boxStacksPartTwo[move.toIdx].append(list: moveChars)
    }
}

var partTwoFinalString: String = ""

for stack in boxStacksPartTwo {
    if let lastChar = stack.lastChar {
        partTwoFinalString.append("\(lastChar)")
    }
}

print(partTwoFinalString)
