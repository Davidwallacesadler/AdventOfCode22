import Foundation

// Decoding packets
// Compare left to right side in each pair - LH must be less than RH for right ordering
// How many pairs of packest are in the right order?

let inputData = try String(contentsOf: Bundle.main.url(forResource: "Input", withExtension: "txt")!)

let packetPairs = inputData.components(separatedBy: "\n\n")

// Idea of a linked list? some kind of next
// Traversal == while next != nil

struct Packet {
    
    let dataLists: [DataList]
    
    struct DataList {
        let depth: Int
        let isASingleValue: Bool
        let values: [Int]
        
        init(depth: Int, value: Int) {
            self.depth = depth
            self.values = [value]
            self.isASingleValue = true
        }
        
        init(depth: Int, values: [Int]) {
            self.depth = depth
            self.values = values
            self.isASingleValue = false
        }
    }
    
    init?(textRepresentation: String) {
        guard !textRepresentation.isEmpty else { return nil }
        
        var datas: [DataList] = []
        var currentDepth = 0
        var currentListString = ""
        
        for char in textRepresentation {
            print("Looking at \(char)")
            switch char {
            case "[":
                if !currentListString.isEmpty {
                    print("Have a build string... need to add it: \(currentListString)")
                    let nums = currentListString.components(separatedBy: ",").compactMap({ Int($0) })
                    print("nums \(nums)")
                    if nums.count > 1 {
                        print("Adding nums")
                        datas.append(DataList(depth: currentDepth, values: nums))
                    } else {
                        print("Adding single num")
                        if currentListString.last!.isPunctuation {
                            datas.append(DataList(depth: currentDepth, values: nums))
                        } else {
                            datas.append(DataList(depth: currentDepth, value: nums[0]))
                        }
                    }
                }
                print("Increasing depth to \(currentDepth + 1)")
                currentDepth += 1
                currentListString = ""
                continue
            case "]":
                // End of list
                print("Got an end brace at depth \(currentDepth)")
                if currentDepth > 1 {
                    if currentListString.isEmpty && currentListString != "]" {
                        print("No list string - adding empty array")
                        datas.append(DataList(depth: currentDepth, values: []))
                    } else {
                        let nums = currentListString.components(separatedBy: ",").compactMap({ Int($0) })
                        print("Adding list \(nums)")
                        if nums.count > 1 {
                            print("Adding nums")
                            datas.append(DataList(depth: currentDepth, values: nums))
                        } else {
                            print("Adding single num")
                            datas.append(DataList(depth: currentDepth, value: nums[0]))
                        }
                    }
                }
                if currentDepth == 1 && !currentListString.isEmpty {
                    let nums = currentListString.components(separatedBy: ",").compactMap({ Int($0) })
                    print("Adding list \(nums)")
                    if nums.count > 1 {
                        print("Adding nums")
                        datas.append(DataList(depth: currentDepth, values: nums))
                    } else {
                        print("Adding single num")
                        datas.append(DataList(depth: currentDepth, value: nums[0]))
                    }
                }

                
                currentDepth -= 1
                currentListString = "]"
                continue
            case ",":
                if currentListString.isEmpty {
                    continue
                }
                currentListString.append(char)
            default:
                print("Num char - adding to build string...")
                currentListString.append(char)
                print("Build string is now \(currentListString)")
            }
        }
        self.dataLists = datas
    }
}

let packet = Packet(textRepresentation: "[1,[2,[3,[4,[5,6,7]]]],8,9]")!

for data in packet.dataLists {
    print("Data: \(data.values) at depth \(data.depth) is a single value \(data.isASingleValue ? "yes" : "no")")
}
