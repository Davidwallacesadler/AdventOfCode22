
import Foundation

let dayThreeDataFileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let rucksackContentsListData = try String(contentsOf: dayThreeDataFileURL!)
let rucksackContentsList = rucksackContentsListData.components(separatedBy: "\n")

// Part 1: Find the sum of all priorities in the list
// break the string apart in half
extension String {
    func splitInHalf() -> (String, String)? {
        guard count > 1 else { return nil }

        let midIdx: Int = (count / 2) - 1

        let firstStart = startIndex
        let firstEnd = index(firstStart, offsetBy: midIdx)
        let lastStart = index(firstEnd, offsetBy: 1)
        let lastEnd = index(firstStart, offsetBy: count - 1)

        let firstHalf = self[firstStart...firstEnd]
        let lastHalf = self[lastStart...lastEnd]

        return ("\(firstHalf)", "\(lastHalf)")
    }
}

typealias Rucksack = (firstCompartment: String, secondCompartment: String)

let rucksacks: [Rucksack] = rucksackContentsList.compactMap({ $0.splitInHalf() })

// find the shared character
extension String {
    func sharedCharacter(in comparison: String) -> Character? {
        let thisCharacterSet: Set<Character> = Set(self)
        let comparisonCharacterSet: Set<Character> = Set(comparison)
        let sameElements = thisCharacterSet.intersection(comparisonCharacterSet)
        return sameElements.first
    }
}

let rucksackItemTypes: [Character] = rucksacks.compactMap({ $0.firstCompartment.sharedCharacter(in: $0.secondCompartment) })

// compute the priority from the shared character
let basePriorityMapping: [String: Int] = [
    "a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6, "g": 7, "h": 8, "i": 9, "j": 10, "k": 11, "l": 12, "m": 13, "n": 14,
    "o": 15, "p": 16, "q": 17, "r": 18, "s": 19, "t": 20, "u": 21, "v": 22, "w": 23, "x": 24, "y": 25, "z": 26
]
func priorityValue(for character: Character) -> Int {
    guard character.isLetter else { return 0 }
    let valueOffset = character.isUppercase ? 26 : 0
    let lowercaseValue = basePriorityMapping[character.lowercased()]
    return lowercaseValue! + valueOffset
}
let rucksackPriorityValues = rucksackItemTypes.map({ priorityValue(for: $0) })
print(rucksackPriorityValues.reduce(into: 0, { $0 += $1 }))

// Part 2:
// groups of 3, each has badge that ids group - only thing carried by everyone in the group
// each set of three lines is a group

// create groups of 3
var rucksackContentGroups: [[String]] = []
var currentGroup: [String] = []
for i in 0..<rucksackContentsList.count {
    if currentGroup.count < 3 {
        currentGroup.append(rucksackContentsList[i])
    } else {
        rucksackContentGroups.append(currentGroup)
        currentGroup = [rucksackContentsList[i]]
    }
}
rucksackContentGroups.append(currentGroup)

// find char that is the same in all groups == badge item type
func sharedCharacter(in strings: [String]) -> Character? {
    var characterSets: [Set<Character>] = strings.map({ Set($0) })

    var comparisonSet: Set<Character> = []
    var currentShared: Set<Character> = []

    for set in characterSets {
        if comparisonSet.isEmpty {
            comparisonSet = set
        } else {
            let sameElements = comparisonSet.intersection(set)

            if currentShared.isEmpty {
                currentShared = sameElements
            } else {
                currentShared = currentShared.intersection(sameElements)
            }
            comparisonSet = set
        }
    }
    return currentShared.first
}

// compute the priority from the badge type
let badgeItemTypes: [Character] = rucksackContentGroups.compactMap({ sharedCharacter(in: $0)})
let rucksackBadgePriorityValues = badgeItemTypes.map({ priorityValue(for: $0) })
print(rucksackBadgePriorityValues.reduce(into: 0, { $0 += $1 }))
