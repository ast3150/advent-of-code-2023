import Algorithms

struct Day06: AdventDay {
    typealias Race = (maxTime: Int, distance: Int)
    
    let races: [Race]
    let combinedRace: Race
    
    init(data: String) {
        let readDigits: (String) -> [Int] = {
            $0.matches(of: /(\d+)/).map(\.output).map(\.1).compactMap { Int($0) }
        }
        let lines = data.split(separator: "\n").map(String.init)
        
        let times = readDigits(lines[0])
        let distances = readDigits(lines[1])
        races = times.enumerated().map { index, element in (element, distances[index]) }
        
        combinedRace = Race(maxTime: Int(times.compactMap(String.init).joined()) ?? -1,
                            distance: Int(distances.compactMap(String.init).joined()) ?? -1)
    }
    
    /// Returns the distance travelled in a race for a given press time
    /// The distance is calculated by:
    /// `distanceTravelled = timeRacing * speed = (race.maxTime - pressDuration) * pressDuration`
    private func distanceTravelled(at pressDuration: Int, in race: Race) -> Int {
        return (race.maxTime - pressDuration) * pressDuration
    }
    
    /// Returns the number of winning scenarios for a given race, based on the distance travelled for a given press duration
    private func numberOfWinningOutcomesForRace(_ race: Race) -> Int {
        return (0..<race.maxTime).map { distanceTravelled(at: $0, in: race) }.filter { $0 > race.distance }.count
    }
    
    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        return races.map(numberOfWinningOutcomesForRace(_:)).reduce(1, *)
    }
    
    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        return numberOfWinningOutcomesForRace(combinedRace)
    }
}
