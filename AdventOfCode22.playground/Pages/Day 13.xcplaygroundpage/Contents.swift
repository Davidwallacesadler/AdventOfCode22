import Foundation

// Decoding packets
// Compare left to right side in each pair - LH must be less than RH for right ordering
// How many pairs of packest are in the right order?

let inputData = try String(contentsOf: Bundle.main.url(forResource: "Input", withExtension: "txt")!)

let packetPairs = inputData.components(separatedBy: "\n\n")

// Idea of a linked list? some kind of next
// Traversal == while next != nil

struct Packet {
    
    let dataList: [DataList]
    
    struct DataList {
        let depth: Int
        let values: [Int]
    }
    
        init?(textRepresentation: String) {
            guard !textRepresentation.isEmpty else { return nil }
            
            var currentString = ""
            var awaitingNumber: Bool = false
            
            for char in textRepresentation {
                if char == "[" && !awaitingNumber {
                    currentString = "["
                }
                if char.isNumber {
                    if awaitingNumber {
                        currentString.app
                    }
                    currentString = "\(char)"
                }
                
            }
            
            
            
        }
}
