import Cocoa
import Foundation

let startTime = Date()

// MARK: Constants
let digits: Regex = /(\d+)/
let mapLine: Regex = /(\d+) (\d+) (\d+)/

typealias MapEntry = (targetStart: Int, sourceStart: Int, length: Int)
typealias Map = [MapEntry]

// MARK: Input

let inputFile = #fileLiteral(resourceName: "input.txt")
let file = try! String(contentsOf: inputFile, encoding: .utf8)
var lines = file.components(separatedBy: .newlines)

let seedsLine = lines.removeFirst()
var seeds: [Int] = seedsLine.matches(of: digits).map(\.output).compactMap { Int($0.1) }

let seedRanges: [Range<Int>] = seedsLine.matches(of: /(\d+) (\d+)/).map(\.output).map { output in
    let start = Int(output.1)!
    let end = start + Int(output.2)!
    return start..<end
}

var maps: [Map] = []
var map: Map = Map()

for line in lines {
    if let match = line.firstMatch(of: mapLine).map(\.output) {
        let targetRangeStart = Int(match.1)!
        let sourceRangeStart = Int(match.2)!
        let length = Int(match.3)!
        map.append((targetStart: targetRangeStart, sourceStart: sourceRangeStart, length: length))
    } else if !map.isEmpty {
        maps.append(map)
        map = Map()
    }
}

// MARK: - Functions

/// Determines the intersection of two `Range<Int>` values.
/// - Parameters:
///   - lhs: The first range to intersect.
///   - rhs: The second range to intersect.
/// - Returns: An optional `Range<Int>` representing the intersection of the two ranges, or `nil` if they do not intersect.
func intersect(_ lhs: Range<Int>, _ rhs: Range<Int>) -> Range<Int>? {
    let intersectionStart = max(lhs.lowerBound, rhs.lowerBound)
    let intersectionEnd = min(lhs.upperBound, rhs.upperBound)
    return intersectionStart < intersectionEnd ? intersectionStart..<intersectionEnd : nil
}

/// Subtracts one range from another and returns an array of ranges representing the difference.
/// - Parameters:
///   - lhs: The range to be subtracted from.
///   - rhs: The range to subtract.
/// - Returns: An array of ranges that represent the segments of `lhs` that do not overlap with `rhs`.
func subtract(_ lhs: Range<Int>, _ rhs: Range<Int>) -> [Range<Int>] {
    var difference: [Range<Int>] = []
    
    if lhs.lowerBound < rhs.lowerBound {
        difference.append(lhs.lowerBound..<rhs.lowerBound)
    }
    
    if lhs.upperBound > rhs.upperBound {
        difference.append(rhs.upperBound..<lhs.upperBound)
    }
    
    return difference
}

func mapRanges(map: Map, unmappedRanges: [Range<Int>]) -> [Range<Int>] {
    var mappedRanges: [Range<Int>] = []
    var unmappedRanges = unmappedRanges
    
    // Iterate over all the ranges in the map
    for entry in map {
        var newUnmappedRanges: [Range<Int>] = []
        
        // Iterate over all the unmapped (source) ranges
        for unmappedRange in unmappedRanges {
            // The source range defined in the map entry
            let srcRange = entry.sourceStart..<(entry.sourceStart + entry.length)
            
            // We intersect the unmapped range from the source data with the map
            if let intersection = intersect(unmappedRange, srcRange), !intersection.isEmpty {
                // If the intersection is not empty, we can map the intersecting source data using this map entry
                let mappedStart = intersection.lowerBound - entry.sourceStart + entry.targetStart
                mappedRanges.append(mappedStart..<(mappedStart + intersection.count))
                
                // Everything not in the intersection is left for the next pass
                newUnmappedRanges += subtract(unmappedRange, srcRange)
            } else {
                // Since the intersection is empty, everything is left for the next pass
                newUnmappedRanges.append(unmappedRange)
            }
        }
        
        // Unmapped ranges are left for the next pass
        unmappedRanges = newUnmappedRanges
    }
    
    // All mapped ranges are returned, all ranges that could not be mapped remain intact
    return mappedRanges + unmappedRanges
}

// MARK: - Main

var currentRanges = seedRanges
for map in maps {
    currentRanges = mapRanges(map: map, unmappedRanges: currentRanges)
}
    
print(currentRanges.min(by: { $0.lowerBound < $1.lowerBound })?.min() ?? "Not found")

print("Runtime: \(Date().timeIntervalSince(startTime))")
