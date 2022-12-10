
import Foundation

let inputData = try String(contentsOf: Bundle.main.url(forResource: "Input", withExtension: "txt")!)
let programLines = inputData.components(separatedBy: "\n")

struct CPUInstruction {
    let type: InstructionType
    
    init?(textRepresentation: String) {
        guard !textRepresentation.isEmpty else { return nil }
        let components = textRepresentation.components(separatedBy: " ")
        if components.count > 1 {
            type = .add(value: Int(components[1])!)
        } else {
            type = .noop
        }
    }
    
    enum InstructionType {
        case noop, add(value: Int)
        
        var cyclesToComplete: Int {
            switch self {
            case .noop:
                return 1
            case .add:
                return 2
            }
        }
    }
}

// Part 1: Sample at the following cycle counts and get the signal stregth
func getSignalStrengthSample(captureCycles: Set<Int>) -> Int {
    var registerX: Int = 1
    var currentCycle: Int = 0
    
    var signalStrengths: [Int: Int] = [:]
    
    func handleSignalStrengthCapture() {
        if captureCycles.contains(currentCycle) {
            signalStrengths[currentCycle] = registerX * currentCycle
        }
    }

    for line in programLines {
        if let instruction = CPUInstruction(textRepresentation: line) {
            switch instruction.type {
            case .noop:
                currentCycle += 1
                handleSignalStrengthCapture()
            case .add(let value):
                for _ in 0..<instruction.type.cyclesToComplete {
                    currentCycle += 1
                    handleSignalStrengthCapture()
                }
                registerX += value // Adds value AFTER its cycle count
            }
        }
    }
    
    return signalStrengths.values.reduce(into: 0, { $0 += $1 })
}
getSignalStrengthSample(captureCycles: [20, 60, 100, 140, 180, 220])

// Part 2: CRT draws a single pixel during each cycle - on if in sprite range, off otherwise
func getCRTPixelOutput(captureCycles: Set<Int>) -> [String] {
    var registerX: Int = 1
    var currentCycle: Int = 0
    
    var pixelLines: [String] = []
    var currentLinePixels: String = ""
    
    func handleLineCapture() {
        if captureCycles.contains(currentCycle) {
            pixelLines.append(currentLinePixels)
            currentLinePixels = ""
        }
    }
    
    func handlePixelDraw() {
        let spriteRange = registerX...(registerX + 2)
        if spriteRange.contains(currentLinePixels.count + 1) {
            currentLinePixels += "#"
        } else {
            currentLinePixels += "."
        }
    }

    for line in programLines {
        if let instruction = CPUInstruction(textRepresentation: line) {
            switch instruction.type {
            case .noop:
                handlePixelDraw()
                currentCycle += 1
                handleLineCapture()
            case .add(let value):
                for _ in 0..<instruction.type.cyclesToComplete {
                    handlePixelDraw()
                    currentCycle += 1
                    handleLineCapture()
                }
                registerX += value
            }
        }
    }
    
    return pixelLines
}
getCRTPixelOutput(captureCycles: [40, 80, 120, 160, 200, 240]).joined(separator: "\n")
