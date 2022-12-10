
import Foundation

let daySixDataFileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let dataStreamBufferData = try String(contentsOf: daySixDataFileURL!)
let dataStreamBufferTexts = dataStreamBufferData.components(separatedBy: "\n")

struct DataStreamBuffer {
    let bufferText: String

    var firstStartOfPacketMarkerPosition: Int? {
        firstStartOfPacketMarkerPosition(strideLength: 4)
    }

    var firstStartOfMessageMarkerPosition: Int? {
        firstStartOfPacketMarkerPosition(strideLength: 14)
    }

    func firstStartOfPacketMarkerPosition(strideLength: Int) -> Int? {
        guard strideLength < bufferText.count else { return nil }
        var windowIdxMax = strideLength
        var windowIdxMin = 0
        while windowIdxMax < bufferText.count {

            let sliceMin = bufferText.index(bufferText.startIndex, offsetBy: windowIdxMin)
            let sliceMax = bufferText.index(bufferText.startIndex, offsetBy: windowIdxMax)
            let sliceWindow = sliceMin..<sliceMax
            let windowSlice = bufferText[sliceWindow]

            let charSet: Set<Character> = Set(windowSlice)
            if charSet.count == strideLength {
                return windowIdxMax
            } else {
                windowIdxMin += 1
                windowIdxMax += 1
            }
        }
        return nil
    }
}

let buffer = DataStreamBuffer(bufferText: dataStreamBufferData)
print(buffer.firstStartOfPacketMarkerPosition)
print(buffer.firstStartOfMessageMarkerPosition)

