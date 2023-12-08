import XCTest

@testable import AdventOfCode

final class Day08Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData1 = """
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
"""
    
    let testData2 = """
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
"""
    
    func testPart1WithData1() throws {
        let challenge = Day08(data: testData1)
        XCTAssertEqual(String(describing: challenge.part1()), "2")
    }
    
    func testPart1WithData2() throws {
        let challenge = Day08(data: testData2)
        XCTAssertEqual(String(describing: challenge.part1()), "6")
    }
    
//    func testPart2() throws {
//        let challenge = Day08(data: testData1)
//        XCTAssertEqual(String(describing: challenge.part2()), "5905")
//    }
}
