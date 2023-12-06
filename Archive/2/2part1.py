import re
from operator import itemgetter

filename = "example.txt"

maxRed = int(12)
maxGreen = int(13)
maxBlue = int(14)

def parse_draw(line: str):
    red = re.search(r"(\d+) red", line)
    green = re.search(r"(\d+) green", line)
    blue = re.search(r"(\d+) blue", line)
    redBalls = int(red.group(1)) if red else 0
    greenBalls = int(green.group(1)) if green else 0
    blueBalls = int(blue.group(1)) if blue else 0
    return (redBalls, greenBalls, blueBalls)

def get_game(line: str):
    partition = line.partition(": ")
    header = partition[0];
    body = partition[2];
    gameId = int(re.findall(r"Game (\d+)", header)[0])
    
    draws = body.split(';')
    parsedDraws = list(map(parse_draw, draws))

    highestRed = max(parsedDraws, key=itemgetter(0))[0]
    highestGreen = max(parsedDraws, key=itemgetter(1))[1]
    highestBlue = max(parsedDraws, key=itemgetter(2))[2]
    
    if highestRed <= maxRed and highestGreen <= maxGreen and highestBlue <= maxBlue:
        return gameId
    else:
        return 0

with open(filename) as file:
    lines = [line.rstrip() for line in file]
    games = map(get_game, lines)
    print(sum(list(games)))
        
