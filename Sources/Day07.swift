//
//  Day07.swift
//  
//
//  Created by Alain Stulz on 07.12.2023.
//

import Foundation

struct Day07: AdventDay {
    private var hands: [Hand]
    
    init(data: String) {
        let lines = data.split(separator: "\n").map(String.init)
        self.hands = lines
            .compactMap { $0.wholeMatch(of: /(.+)\ (\d+)/)?.output }
            .map { Hand(cards: String($0.1), bid: Int($0.2)!) }
    }
        
    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        return hands.sorted(by: Hand.part1RulesSort).enumerated().map { $0.element.bid * ($0.offset + 1) }.reduce(0, +)
    }
    
    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        return hands.sorted(by: Hand.part2RulesSort).enumerated().map { $0.element.bid * ($0.offset + 1) }.reduce(0, +)
    }
}

extension Day07 {
    struct Hand {
        var cards: String
        var bid: Int
        
        enum HandType: Int {
            case highCard = 0, pair, twoPairs, threeOfAKind, fullHouse, fourOfAKind, fiveOfAKind
            
            func improved(numberOfJokers j: Int) -> HandType {
                guard j < 5 else { return .fiveOfAKind }
                
                switch self {
                case .highCard: return .pair
                case .pair: return .threeOfAKind
                case .twoPairs: return .threeOfAKind
                case .threeOfAKind: return .fourOfAKind
                case .fullHouse: return .fiveOfAKind
                case .fourOfAKind: return .fiveOfAKind
                case .fiveOfAKind: return .fiveOfAKind
                }
            }
        }
                
        static func part1RulesSort(lhs: Day07.Hand, rhs: Day07.Hand) -> Bool {
            if lhs.cards.type == rhs.cards.type {
                for (lhsCard, rhsCard) in zip(lhs.cards, rhs.cards) {
                    if lhsCard.cardValuePart1 == rhsCard.cardValuePart1 { continue }
                    return lhsCard.cardValuePart1 < rhsCard.cardValuePart1
                }
            }
            return lhs.cards.type.rawValue < rhs.cards.type.rawValue
        }
                
        static func part2RulesSort(lhs: Day07.Hand, rhs: Day07.Hand) -> Bool {
            let lhsType = lhs.cards.applyingJokers().type
            let rhsType = rhs.cards.applyingJokers().type
            
            if lhsType == rhsType {
                for (lhsCard, rhsCard) in zip(lhs.cards, rhs.cards) {
                    if lhsCard.cardValuePart2 == rhsCard.cardValuePart2 { continue }
                    return lhsCard.cardValuePart2 < rhsCard.cardValuePart2
                }
            }
            
            return lhsType.rawValue < rhsType.rawValue
        }
    }
}

private extension Character {
    var cardValuePart1: Int {
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
    
    var cardValuePart2: Int {
        switch self {
        case "J": return 1
        default: return cardValuePart1
        }
    }
}

private extension Collection where Element == Character {
    var countByCharacter: [Character: Int] {
        var uniqueItems: [Character: Int] = [:]
        for character in self {
            uniqueItems.updateValue((uniqueItems[character] ?? 0) + 1, forKey: character)
        }
        return uniqueItems
    }
}

private extension String {
    var type: Day07.Hand.HandType {
        let countByCharacter = self.countByCharacter
        switch countByCharacter.keys.count {
        case 5: return .highCard
        case 4: return .pair
        case 3: return countByCharacter.values.max() == 3 ? .threeOfAKind : .twoPairs
        case 2: return countByCharacter.values.max() == 4 ? .fourOfAKind : .fullHouse
        case 1: return .fiveOfAKind
        default: fatalError()
        }
    }

    func applyingJokers() -> String {
        guard let mostCommon = self.countByCharacter.filter({ $0.key != "J" }).max(by: { $0.value < $1.value })?.key else {
            return self
        }
        return self.replacingOccurrences(of: "J", with: String(mostCommon))
    }
}
