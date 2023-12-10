//
//  Day10.swift
//
//
//  Created by Alain Stulz on 10.12.2023.
//

import Foundation

struct Day10: AdventDay {
    
    struct Direction: OptionSet {
        let rawValue: Int
        
        static let left     = Direction(rawValue: 1 << 0)
        static let right    = Direction(rawValue: 1 << 1)
        static let up       = Direction(rawValue: 1 << 2)
        static let down     = Direction(rawValue: 1 << 3)
        
        static let start: Direction = [.left, .right, .down, .up]
    }
    
    let map: [Direction]
    let lineLength: Int
    
    init(data: String) {
        let lines = data.split(separator: "\n").map(String.init)
        self.map = lines.reduce([], { array, line in
            return array + line.map { char in
                switch char {
                case "|": return [.up, .down]
                case "-": return [.left, .right]
                case "L": return [.up, .right]
                case "J": return [.up, .left]
                case "7": return [.down, .left]
                case "F": return [.down, .right]
                case ".": return []
                case "S": return .start
                default: fatalError("Unexpected input value in map")
                }
            }
        })
        self.lineLength = lines.first!.count
    }
    
    private func getNodes(connectedTo currentIndex: Int) -> [Int] {
        let currentColumn = currentIndex % lineLength
        let currentRow = (currentIndex - currentColumn) / lineLength

        let currentNode = map[currentIndex]
        var connectedNodes: [Int] = []
        if currentNode.contains(.left), currentColumn > 0 {
            let leftIndex = currentIndex - 1
            if map[leftIndex].contains(.right) {
                connectedNodes.append(leftIndex)
            }
        }
        if currentNode.contains(.right), currentColumn < lineLength {
            let rightIndex = currentIndex + 1
            if map[rightIndex].contains(.left) {
                connectedNodes.append(rightIndex)
            }
        }
        if currentNode.contains(.up), currentRow > 0 {
            let upIndex = currentIndex - lineLength
            if map[upIndex].contains(.down) {
                connectedNodes.append(upIndex)
            }
        }
        if currentNode.contains(.down), currentRow < map.count {
            let downIndex = currentIndex + lineLength
            if map[downIndex].contains(.up) {
                connectedNodes.append(downIndex)
            }
        }
        return connectedNodes
    }
    
    /// Returns the indices of all fileds that are connected to the given index
    private func findLoop(from startIndex: Int) -> Set<Int> {
        var connectedNodes: Set<Int> = [startIndex]
        
        var countBefore = 0
        var countAfter = 0
        
        repeat {
            countBefore = connectedNodes.count
            for node in connectedNodes {
                connectedNodes.formUnion(getNodes(connectedTo: node))
            }
            countAfter = connectedNodes.count
        } while countBefore < countAfter
        
        return connectedNodes
    }
        
    func part1() -> Any {
        let startIndex = map.firstIndex(where: { $0 == .start })!
        let loop = findLoop(from: startIndex)
        return loop.count / 2
    }
    
    func part2() -> Any {
        return 0
    }
}
