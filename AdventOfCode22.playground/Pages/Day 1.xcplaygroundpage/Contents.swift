
import Foundation

let calorieFileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let calorieListData = try String(contentsOf: calorieFileURL!)
let calorieGroupTextList: [String] = calorieListData.components(separatedBy: "\n\n")
let groupCalorieValueList: [[Int]] = calorieGroupTextList.map { groupString in
    let groupValueTextList: [String] = groupString.components(separatedBy: "\n")
    return groupValueTextList.compactMap({ Int($0) })
}
let groupCalorieSums: [Int] = groupCalorieValueList.map { calorieGroupList in
    return calorieGroupList.reduce(into: 0, { $0 += $1 })
}

// Part 1: Find the max amount of calories in any given group
let maximumGroupCalories = groupCalorieSums.max()
print(maximumGroupCalories)

// Part 2:
// a) find the top 3 groups in terms of calorie count
// b) find the total calorie count of the groups in a)
let sortedCalorieSums = groupCalorieSums.sorted(by: >)
var totalCaloriesInTopGroups = 0
for i in 0..<3 {
    totalCaloriesInTopGroups += sortedCalorieSums[i]
}
print(totalCaloriesInTopGroups)
