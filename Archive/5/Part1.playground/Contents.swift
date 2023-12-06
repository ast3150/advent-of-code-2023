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
let seeds: [Int] = seedsLine.matches(of: digits).map(\.output.1).compactMap { Int($0) }

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

var targetValues: [(seed: Int, location: Int)] = []

for seed in seeds {
    var value = seed
    for map in mapList {
        guard let entry = map.entries.first(where: { $0.contains(value) }) else {
            continue
        }
        value += entry.diff
    }
    
    targetValues.append((seed, value))
}

print("Lowest location: \(targetValues.min(by: { $0.location < $1.location })!)")

print("Runtime: \(Date().timeIntervalSince(startTime)) seconds")
