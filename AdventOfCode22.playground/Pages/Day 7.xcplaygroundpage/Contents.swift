
import Foundation

let daySevenDataFileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let terminalInputData = try String(contentsOf: daySevenDataFileURL!)
let terminalInputLines = terminalInputData.components(separatedBy: "\n")

struct TerminalCommand {

    let textRepresentation: String
    let commandType: CommandType
    let operand: String?
    var output: [String]

    init?(textRepresentation: String) {
        self.textRepresentation = textRepresentation
        if textRepresentation.contains("$ cd") {
            commandType = .changeDirectory
            operand = textRepresentation.components(separatedBy: " ").last
            output = []
        } else if textRepresentation.contains("$ ls") {
            commandType = .list
            operand = nil
            output = []
        } else {
            return nil
        }
    }

    enum CommandType {
        case changeDirectory, list
    }

}

var commands: [TerminalCommand] = []

var commandAwaitingOutput: TerminalCommand? = nil
var currentOutput: [String] = []

for line in terminalInputLines {
    if let newCommand = TerminalCommand(textRepresentation: line) {

        if var awaitingCommand = commandAwaitingOutput {
            awaitingCommand.output = currentOutput
            commands.append(awaitingCommand)
            commandAwaitingOutput = nil
            currentOutput = []
        }

        if newCommand.commandType == .list {
            // Await ouput
            commandAwaitingOutput = newCommand
        } else {
            // add to commands
            commands.append(newCommand)
        }
    } else {
        currentOutput.append(line)
    }
}

if var awaitingCommand = commandAwaitingOutput {
    awaitingCommand.output = currentOutput
    commands.append(awaitingCommand)
}

struct FileDirectory {

    var files: [String: Int] = [:]

    var directorySize: Int {
        files.values.reduce(into: 0, { $0 += $1 })
    }
}

class FileSystem {

    var currentfilePath: [String] = []
    var workingDirectory: String {
        var path: String = ""
        for directory in currentfilePath {
            if path.isEmpty {
                path += directory
            } else {
                path += "\(directory)/"
            }
        }
        return path
    }

    var system: [String : FileDirectory] = [:]

    func handleCommand(_ command: TerminalCommand) {
        switch command.commandType {
        case .changeDirectory:
            if let operand = command.operand {
                switch operand {
                case "..":
                    // Pop last in filepath
                    let _ = currentfilePath.removeLast()
                default:
                    // Add to the filepath
                    currentfilePath.append(operand)
                }
            }

        case .list:
            var newDirectory = FileDirectory()
            for line in command.output {
                let lineComponents = line.components(separatedBy: " ")
                if line.contains("dir") {
                    // New directory!
                    // Ignore for now
                } else {
                    // New file!
                    if lineComponents.count > 1 {
                        let fileSize = Int(lineComponents.first!)!
                        let fileName = lineComponents.last!
                        newDirectory.files[fileName] = fileSize
                    }
                }
            }
            system[workingDirectory] = newDirectory
        }
    }
}

var fileSystem = FileSystem()

typealias FileSize = (filePath: String, size: Int)

var fileSizes: [FileSize] = []

for filePath in fileSystem.system.keys {
    let subDirectoryPaths = fileSystem.system.keys.filter({ $0.contains(filePath) && $0 != filePath })

    var size = fileSystem.system[filePath]!.directorySize
    for path in subDirectoryPaths {
        size += fileSystem.system[path]!.directorySize

    }

    fileSizes.append((filePath, size))
}

// Part 1:
var filesUnder100k = fileSizes.filter({ $0.size <= 100_000 })
print(filesUnder100k.reduce(into: 0, { $0 += $1.size }))

// Part 2: Need to free up 30_000_000, find a directory to delete
// Find the smallest directory that, if deleted, would free up enough space on the filesystem to run the update. What is the total size of that directory?

var freeSpace = 70_000_000

let homeDirFileSize = fileSizes.first(where: { $0.filePath  == "/"})!.size

freeSpace -= homeDirFileSize

let amountToFreeUpEnough = 30_000_000 - freeSpace

var filesOver30Mil = fileSizes.filter({ $0.size >= amountToFreeUpEnough})

print(filesOver30Mil.sorted(by:{ $0.size < $1.size }).first)
