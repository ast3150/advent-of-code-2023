//
//  Day09.swift
//
//
//  Created by Alain Stulz on 10.12.2023.
//

import Foundation

struct Day09: AdventDay {
    typealias Sequence = [Int]
    var values: [Sequence] = []
    
    init(data: String) {
        for line in data.split(separator: "\n").map(String.init) {
            let matches = line.matches(of: /(-?\d+)/)
            values.append(matches.map(\.output.1).reduce(into: [], { $0.append(Int($1)!) }))
        }
    }
    
    func getPrediction(for sequence: Sequence) -> Int {
        if sequence.allSatisfy( { $0 == 0 }) {
            return 0
        }
        
        let reducedSequence = stride(from: 0, to: sequence.endIndex - 1, by: 1).map {
            sequence[$0 + 1] - sequence[$0]
        }
        return sequence.last! + (getPrediction(for: reducedSequence))
    }
    
    func part1() -> Any {
        return values.reduce(0, { $0 + getPrediction(for: $1) })
    }
    
    func part2() -> Any {
        return values.reduce(0, { $0 + getPrediction(for: $1.reversed()) })
    }
}
