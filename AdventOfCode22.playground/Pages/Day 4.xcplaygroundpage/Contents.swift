
import Foundation

let dayFourDataFileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let sectionRangeData = try String(contentsOf: dayFourDataFileURL!)
let sectionRangeDataList = sectionRangeData.components(separatedBy: "\n")

// Part 1:
/*
 - Each section has an ID number
 - Each elf is given a range of sections
 - Elves are paired together

 - Find overlaps
 - Some ranges completely overlap (fully contain another range)
 - ranges can consist of just one section!
 */

// Turn data into ranges
struct SectionRange {
    let upperBound: Int
    let lowerBound: Int

    var isOnlyASingleSection: Bool {
        upperBound == lowerBound
    }

    var valueSet: Set<Int> {
        if self.isOnlyASingleSection {
            return Set([upperBound])
        }
        let range = lowerBound...upperBound
        let rangeValues: [Int] = range.map({ $0 })
        return Set(rangeValues)
    }

    func fullyContains(other sectionRange: Self) -> Bool {
        let lowerIsAtOrLower = self.lowerBound <= sectionRange.lowerBound
        let upperIsAtOrHigher = self.upperBound >= sectionRange.upperBound
        return lowerIsAtOrLower && upperIsAtOrHigher
    }

    func overlaps(other sectionRange: Self) -> Bool {
        return !self.valueSet.intersection(sectionRange.valueSet).isEmpty
    }
}

extension SectionRange {
    init(rangeString: String) {
        let bounds = rangeString.components(separatedBy: "-")
        self.lowerBound = Int(bounds.first!)!
        self.upperBound = Int(bounds.last!)!
    }
}

typealias SectionGroup = (first: SectionRange, second: SectionRange)

let groupSectionRanges: [SectionGroup] = sectionRangeDataList.compactMap { groupText in
    let groups = groupText.components(separatedBy: ",")
    guard groups.count == 2 else { return nil }
    return (SectionRange(rangeString: groups.first!), SectionRange(rangeString: groups.last!))
}

let sectionsWithFullyOverlappingGroups: [SectionGroup] = groupSectionRanges.filter { sectionGroup in
    let firstFullyContainsSecond = sectionGroup.first.fullyContains(other: sectionGroup.second)
    let secondFullyContainsFirst = sectionGroup.second.fullyContains(other: sectionGroup.first)
    return firstFullyContainsSecond || secondFullyContainsFirst
}
print(sectionsWithFullyOverlappingGroups.count)

// Part 2:
// Find the groups with ranges that have ANY overlap
let sectionsWithOverlappingGroups: [SectionGroup] = groupSectionRanges.filter { sectionGroup in
    return sectionGroup.first.overlaps(other: sectionGroup.second)
}
print(sectionsWithOverlappingGroups.count)
