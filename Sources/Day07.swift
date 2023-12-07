//
//  Day07.swift
//  
//
//  Created by Alain Stulz on 07.12.2023.
//

import Foundation

struct Day07: AdventDay {
    struct Hand: Comparable {
        var cards: String
        var bid: Int
        
        enum HandType: Int {
            case highCard = 0
            case pair
            case twoPairs
            case threeOfAKind
            case fullHouse
            case fourOfAKind
            case fiveOfAKind
        }
        
        var type: HandType {
            var uniqueItems: [Character: Int] = [:]
            for card in cards {
                uniqueItems.updateValue((uniqueItems[card] ?? 0) + 1, forKey: card)
            }
            
            switch uniqueItems.keys.count {
            case 5: return .highCard
            case 4: return .pair
            case 3: return uniqueItems.values.max() == 3 ? .threeOfAKind : .twoPairs
            case 2: return uniqueItems.values.max() == 4 ? .fourOfAKind : .fullHouse
            case 1: return .fiveOfAKind
            default: fatalError()
            }
        }
        
        static func < (lhs: Day07.Hand, rhs: Day07.Hand) -> Bool {
            if lhs.type == rhs.type {
                for (lhsCard, rhsCard) in zip(lhs.cards, rhs.cards) {
                    if lhsCard.cardValue == rhsCard.cardValue { continue }
                    return lhsCard.cardValue < rhsCard.cardValue
                }
            }
            return lhs.type.rawValue < rhs.type.rawValue
        }
    }
    
    var hands: [Hand]
    
    init(data: String) {
        let lines = data.split(separator: "\n").map(String.init)
        self.hands = lines
            .compactMap { $0.wholeMatch(of: /(.+)\ (\d+)/)?.output }
            .map { Hand(cards: String($0.1), bid: Int($0.2)!) }
    }
        
    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        return hands.sorted().enumerated().map { $0.element.bid * ($0.offset + 1) }.reduce(0, +)
    }
    
    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        return 0
    }
}

private extension Character {
    var cardValue: Int {
        switch self {
        case "2", "3", "4", "5", "6", "7", "8", "9": return Int(String(self))!
        case "T": return 10
        case "J": return 11
        case "Q": return 12
        case "K": return 13
        case "A": return 14
        default: return 0
        }
    }
}
