import XCTest

@testable import AdventOfCode

final class Day10Tests: XCTestCase {
    let simpleLoop = """
.....
.S-7.
.|.|.
.L-J.
.....
"""
    
    let complexLoop = """
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
"""
    
    func testPart1Simple() throws {
        let challenge = Day10(data: simpleLoop)
        XCTAssertEqual(String(describing: challenge.part1()), "4")
    }
    
    func testPart1Complex() throws {
        let challenge = Day10(data: complexLoop)
        XCTAssertEqual(String(describing: challenge.part1()), "8")
    }
    
    func testPart2() throws {
//        let challenge = Day10(data: testData)
//        XCTAssertEqual(String(describing: challenge.part2()), "2")
    }
}
