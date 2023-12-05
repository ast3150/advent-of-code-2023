import Cocoa
import Foundation

// MARK: Models
let startTime = Date()

struct MapEntry {
    let range: ClosedRange<Int>
    let diff: Int
    
    func contains(_ int: Int) -> Bool {
        return range.contains(int)
    }
}

class Map {
    var entries: [MapEntry]
    
    init(entries: [MapEntry]) {
        self.entries = entries
    }
}

extension RandomAccessCollection {
    /// Finds such index N that predicate is true for all elements up to
    /// but not including the index N, and is false for all elements
    /// starting with index N.
    /// Behavior is undefined if there is no such N.
    func binarySearch(predicate: (Element) -> Bool) -> Index {
        var low = startIndex
        var high = endIndex
        while low != high {
            let mid = index(low, offsetBy: distance(from: low, to: high)/2)
            if predicate(self[mid]) {
                low = index(after: mid)
            } else {
                high = mid
            }
        }
        return low
    }
}


// MARK: Constants
let digits: Regex = /(\d+)/
let mapLine: Regex = /(\d+) (\d+) (\d+)/

// MARK: Vars

var mapList: [Map] = []


// MARK: Input

let inputFile = #fileLiteral(resourceName: "input.txt")
let file = try! String(contentsOf: inputFile, encoding: .utf8)
var lines = file.components(separatedBy: .newlines)

let seedsLine = lines.removeFirst()
typealias SeedRange = (start: Int, offset: Int)
let seedRanges: [SeedRange] = seedsLine.matches(of: /(\d+) (\d+)/).map(\.output).map { (Int($0.1)!, Int($0.2)!) }

for line in lines {
    if line.contains(/\w+:/) {
        mapList.append(Map(entries: []))
    } else if let match = line.firstMatch(of: mapLine).map(\.output) {
        let targetRangeStart = Int(match.1)!
        let sourceRangeStart = Int(match.2)!
        let offset = Int(match.3)!

        mapList.last?.entries.append(
            MapEntry(range: sourceRangeStart...(sourceRangeStart+offset),
                     diff: (targetRangeStart - sourceRangeStart))
        )
    }
}

for map in mapList {
    map.entries.sort(by: { $0.range.startIndex < $1.range.startIndex })
}

typealias MappedSeed = (seed: Int, location: Int)

func calculateSeeds(in range: SeedRange) async -> MappedSeed {
    var lowestSeed: MappedSeed = MappedSeed(0, Int.max)
    
    for seed in range.start...(range.start + range.offset) {
        var mappedValue = seed
        
        for map in mapList {
            let entryIndex = map.entries.binarySearch(predicate: { $0.range.lowerBound < mappedValue })
            guard map.entries.count < entryIndex else {
                continue
            }
            let entry = map.entries[entryIndex]
            guard entry.range.contains(mappedValue) else {
                continue
            }
            
            mappedValue += entry.diff
        }
        
        if mappedValue < lowestSeed.location {
            print("Found seed \((seed, mappedValue))")
            lowestSeed = (seed, mappedValue)
        }
    }
    return lowestSeed
}

Task {
    let minSeed = await withTaskGroup(of: MappedSeed.self) { group in
        for seedRange in seedRanges {
            group.addTask { await calculateSeeds(in: seedRange) }
        }
        return await group.min(by: { $0.location < $1.location })!
    }
    
    print("Lowest location: \(minSeed)")
    
    print("Runtime: \(Date().timeIntervalSince(startTime)) seconds")
}
