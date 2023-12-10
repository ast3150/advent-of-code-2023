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
    
    let part2Sample1 = """
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........
"""
    
    let part2Sample2 = """
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
"""
    
    let part2Sample3 = """
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
"""


    
    func testPart1Simple() throws {
        let challenge = Day10(data: simpleLoop)
        XCTAssertEqual(String(describing: challenge.part1()), "4")
    }
    
    func testPart1Complex() throws {
        let challenge = Day10(data: complexLoop)
        XCTAssertEqual(String(describing: challenge.part1()), "8")
    }
    
    func testPart2Sample1() throws {
        let challenge = Day10(data: part2Sample1)
        XCTAssertEqual(String(describing: challenge.part2()), "4")
    }
    
    func testPart2Sample2() throws {
        let challenge = Day10(data: part2Sample2)
        XCTAssertEqual(String(describing: challenge.part2()), "8")
    }
    
    func testPart2Sample3() throws {
        let challenge = Day10(data: part2Sample3)
        XCTAssertEqual(String(describing: challenge.part2()), "10")
    }
}
