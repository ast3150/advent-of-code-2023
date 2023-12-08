//
//  Day08.swift
//
//
//  Created by Alain Stulz on 08.12.2023.
//

import Foundation

struct Day08: AdventDay {
    enum Instruction: Character {
        case left = "L"
        case right = "R"
    }
    
    private let instructions: [Instruction]
    private var nodes: [String: (String, String)] = [:]
    
    init(data: String) {
        var lines = data.split(separator: "\n").map(String.init)
        let directionLine = lines.removeFirst()
        self.instructions = directionLine.compactMap { Instruction(rawValue: $0) }
                
        for line in lines {
            guard let match = line.wholeMatch(of: /(\w{3}) = \((\w{3}), (\w{3})\)/)?.output else { continue }
            nodes.updateValue((String(match.2), String(match.3)), forKey: String(match.1))
        }
    }
    
    func part1() -> Any {
        var currentNodeId: String = "AAA"
        var count: Int = 0
        repeat {
            let currentNode = nodes[currentNodeId]!
            let instruction = instructions[count % instructions.count]
            currentNodeId = (instruction == .left) ? currentNode.0 : currentNode.1
            count += 1
        } while currentNodeId != "ZZZ"
        return count
    }
    
    func part2() -> Any {
        var nodeIds: [String] = nodes.filter { $0.key.last == "A" }.map(\.key)
        var instructionCount: [Int] = Array(repeating: 0, count: nodeIds.count)

        func traverseNode(at index: Int) -> String {
            let currentNode = nodes[nodeIds[index]]!
            let instruction = instructions[instructionCount[index] % instructions.count]
            let nextNodeId = (instruction == .left) ? currentNode.0 : currentNode.1
            nodeIds[index] = nextNodeId
            instructionCount[index] += 1
            return nextNodeId
        }
        
        var currentIndex = 0
        while !nodeIds.allSatisfy({ $0.last == "Z" }) {
            var nodeId = ""
            repeat {
                nodeId = traverseNode(at: currentIndex)
            } while nodeId.last != "Z"
            currentIndex += 1
        }
        
        return instructionCount.lestCommonMultiple()
    }
}

extension Collection where Element == Int {
    /// Returns the least common multiple of all elements in the collection.
    func lestCommonMultiple() -> Int {
        var ans = 1
        for element in self {
            ans = lcm(ans, element)
        }
        return ans
    }
    
    /// Returns the least common multiple of both integers.
    /// Uses the GCD approach for calculation of the LCM.
    private func lcm(_ a: Int, _ b: Int) -> Int {
        return a / gcd(a, b) * b
    }
    
    /// Returns the greatest common divisor of both integers.
    private func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        while b != 0 {
            let t = b
            b = a % b
            a = t
        }
        return a
    }
}
