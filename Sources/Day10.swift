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
        
        static let L: Direction = [.up, .right]
        static let J: Direction = [.up, .left]
        static let F: Direction = [.down, .right]
        static let Seven: Direction = [.down, .left]
        static let Vertical: Direction = [.down, .up]
        static let Horizontal: Direction = [.left, .right]
        
        static let start: Direction = [.left, .right, .down, .up]
    }
    
    var map: [Direction]
    let lineLength: Int
    let startIndex: Int
    var loop: Set<Int> = []
    
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
        self.startIndex = map.firstIndex(where: { $0 == .start })!
        self.loop = findLoop(from: startIndex)
        self.updateStartWithActualValue()
    }
    
    private func getNodes(connectedTo currentIndex: Int) -> [Int] {
        let (currentRow, currentColumn) = getPosition(of: currentIndex)
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
    
    private mutating func updateStartWithActualValue() {
        let startConnectedNodes = getNodes(connectedTo: startIndex)
        map[startIndex] = .init()
        if startConnectedNodes.contains(startIndex - lineLength) {
            map[startIndex].insert(.up)
        }
        if startConnectedNodes.contains(startIndex + lineLength) {
            map[startIndex].insert(.down)
        }
        // Ignores line wrapping
        if startConnectedNodes.contains(startIndex - 1) {
            map[startIndex].insert(.left)
        }
        // Ignores line wrapping
        if startConnectedNodes.contains(startIndex + 1) {
            map[startIndex].insert(.right)
        }
    }
    
    /// Returns the indices of all fileds that are connected to the given index
    private func findLoop(from startIndex: Int) -> Set<Int> {
        var visitedNodes: [Int] = []
        var connectedNodes: [Int] = [startIndex]
        var nodesToVisit: [Int] = [startIndex]
        
        repeat {
            let node = nodesToVisit.removeFirst()
            visitedNodes.append(node)
            getNodes(connectedTo: node).forEach { connectedNode in
                if !visitedNodes.contains(connectedNode) {
                    nodesToVisit.append(connectedNode)
                }
                connectedNodes.append(node)
            }
        } while !nodesToVisit.isEmpty
        
        return Set(connectedNodes)
    }
    
    private func getPosition(of index: Int) -> (row: Int, col: Int) {
        let col = index % lineLength
        let row = (index - col) / lineLength
        return (row, col)
    }

    // MARK: - Challenge Functions
    
    func part1() -> Any {
        return loop.count / 2
    }
    
    /// The second challenge part is to find the number of points contained within the loop.
    ///
    /// The test for contained elements resembles the Point-in-Polygon problem and is implemented here using the
    /// Even-Odd-Rule, which works as follows:
    ///
    /// > If a ray is drawn from the point to be tested in any direction and the number of intersections with the polygon is odd, the point is contained within the polygon. If the number is even, the point is outside.
    ///
    /// [Point-in-Polygon Problem](https://en.wikipedia.org/wiki/Point_in_polygon)
    ///
    /// [Even-Odd-Rule](https://en.wikipedia.org/wiki/Even%E2%80%93odd_rule)
    func part2() -> Any {
        var numberOfContainedElements = 0
        // For every node in the map
        for node in 0..<map.count {
            // Ignore nodes that are part of the loop since they are always contained
            guard !loop.contains(node) else { continue }
            
            // Set up the test
            var horizontalIntersectionCount = 0
            var openDownwardSegment = false
            var openUpwardSegment = false
            
            // Step through the rest of the line one node at a time
            for candidateNodeIndex in node..<(node + (lineLength - node % lineLength)) {
                // Ignore nodes that are part of the loop since they are always contained
                guard loop.contains(candidateNodeIndex) else { continue }
                
                switch map[candidateNodeIndex] {
                case .Vertical:
                    // If the segment is vertical `|` it is always an intersection
                    horizontalIntersectionCount += 1
                case .F:
                    // If the segment is horizontal, the length of the segment must be ignored,
                    // since it can contain an arbitrary number of horizontal `-` segments
                    // Keep track of opened segment and the direction of the opening F or L
                    openDownwardSegment = true
                case .L:
                    openUpwardSegment = true
                case .Seven:
                    // Once we reach the closing segment 7 or J, we count the intersection
                    
                    // If we are closing a segment in the same direction as the opening,
                    // e.g. `F--7` or `L--J` we need to count the intersection twice
                    // However, if the direction changes, e.g. `F--J` or `L--7` we only count once.
                    horizontalIntersectionCount += openDownwardSegment ? 2 : 1
                    openUpwardSegment = false
                    openDownwardSegment = false
                case .J:
                    horizontalIntersectionCount += openUpwardSegment ? 2 : 1
                    openUpwardSegment = false
                    openDownwardSegment = false
                case .Horizontal:
                    // A horizontal segment is not an intersection since it's parallel to the ray
                    continue
                default:
                    continue
                }
            }
            
            if horizontalIntersectionCount % 2 == 1 {
                numberOfContainedElements += 1
            }
        }
        return numberOfContainedElements
    }
}
