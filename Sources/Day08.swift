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
    
    private let startId = "AAA"
    private let endId = "ZZZ"
    
    init(data: String) {
        var lines = data.split(separator: "\n").map(String.init)
        let directionLine = lines.removeFirst()
        self.instructions = directionLine.compactMap { Instruction(rawValue: $0) }
                
        for line in lines {
            guard let match = line.wholeMatch(of: /(\w{3}) = \((\w{3}), (\w{3})\)/)?.output else { continue }
            nodes.updateValue((String(match.2), String(match.3)), forKey: String(match.1))
        }
    }
    
    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var currentNodeId: String = startId
        var count: Int = 0
        repeat {
            let currentNode = nodes[currentNodeId]!
            let instruction = instructions[count % instructions.count]
            currentNodeId = (instruction == .left) ? currentNode.0 : currentNode.1
            count += 1
        } while currentNodeId != endId
        return count
    }
    
    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        return 0
    }
}
