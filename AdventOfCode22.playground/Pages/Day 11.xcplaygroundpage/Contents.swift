import Foundation

let inputData = try String(contentsOf: Bundle.main.url(forResource: "Input", withExtension: "txt")!)
let monkeyData = inputData.components(separatedBy: "\n\n")

struct Monkey {
    var items: [Int]
    var inspectionCount = 0
    let operation: Operation
    let itemThrow: (divisor: Int, trueTarget: Int, falseTarget: Int)
    
    init?(textRepresentation: String) {
        let lines = textRepresentation.components(separatedBy: "\n")
        guard !lines.isEmpty, !textRepresentation.isEmpty else { return nil }
        // Items
        items = lines[1].replacingOccurrences(of: " ", with: "").components(separatedBy: ":").last!.components(separatedBy: ",").compactMap({ Int($0) })
        // Operation
        let operationDescription = lines[2].components(separatedBy: "=").last!.components(separatedBy: " ")
        if operationDescription.contains("+") {
            self.operation = .add(value: Int(operationDescription.last!)!)
        } else {
            if operationDescription.last! == "old" {
                self.operation = .square
            } else {
                self.operation = .multiply(value: Int(operationDescription.last!)!)
            }
        }
        // Throw
        let divisor = Int(lines[3].components(separatedBy: " ").last!)!
        let trueTarget = Int(lines[4].components(separatedBy: " ").last!)!
        let falseTarget = Int(lines[5].components(separatedBy: " ").last!)!
        self.itemThrow = (divisor, trueTarget, falseTarget)
    }
    
    enum Operation {
        case add(value: Int), multiply(value: Int), square
    }
    
    mutating func inspectFirstItem() {
        guard !items.isEmpty else { return }
//        print("Insepecting \(items[0]) and applying \(operation)")
        switch operation {
        case .add(let value):
            items[0] += value
        case .multiply(let value):
            items[0] *= value
        case .square:
            items[0] *= items[0]
        }
//        print("Inspected item is now \(items[0])")
        inspectionCount += 1
    }
    
    mutating func getBoredOfItemFirstItem(factor: Int) {
        guard !items.isEmpty else { return }
//        print("Getting bored...")
//        reduceWorryLevelPart1()
        reduceWorryLevelPart2(factor: factor)
    }
    
    mutating func reduceWorryLevelPart1() {
        items[0] = (items[0] / 3)
    }
    
    mutating func reduceWorryLevelPart2(factor: Int) {
        items[0] = (items[0] % factor)
    }
    
    mutating func throwFirstItem() -> (item: Int, target: Int)? {
        guard !items.isEmpty else { return nil }
        let item = items.removeFirst()
        let test = (item % itemThrow.divisor) == 0
//        print("Throwing \(item) to Monkey \(test ? itemThrow.trueTarget : itemThrow.falseTarget)")
//        print("-----")
        if test {
            return (item, itemThrow.trueTarget)
        } else {
            return (item, itemThrow.falseTarget)
        }
    }
}

var monkies: [Monkey] = monkeyData.compactMap({ Monkey(textRepresentation: $0) })
let reductionFactor = monkies.reduce(into: 1, { $0 *= $1.itemThrow.divisor })

func simulateMonkeyActions(roundCount: Int) {
    for _ in 0..<roundCount {
        for monkeyIdx in 0..<monkies.count {
            let itemCount = monkies[monkeyIdx].items.count
            for _ in 0..<itemCount {
//                print("Monkey \(monkeyIdx) is looking at an item...")
                monkies[monkeyIdx].inspectFirstItem()
                monkies[monkeyIdx].getBoredOfItemFirstItem(factor: reductionFactor)
                if let thrownItem = monkies[monkeyIdx].throwFirstItem() {
                    monkies[thrownItem.target].items.append(thrownItem.item)
                }
            }
        }
    }
}

simulateMonkeyActions(roundCount: 10000)

for monkeyIdx in 0..<monkies.count {
    print("Monkey \(monkeyIdx) inspected items \(monkies[monkeyIdx].inspectionCount) times.")
}
