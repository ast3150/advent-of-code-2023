import re
filename = "input.txt"

def parse_line(line: str):
    digits = r"(\d+)"
    line = str.split(line, ": ")[1]
    parts = str.split(line, '|')
    return (re.findall(digits, parts[0]), re.findall(digits, parts[1]))

def get_value(matches: int):
    if matches <= 0:
        return 0
    return 2 ** (matches-1)

with open(filename) as file:
    lines = [line.rstrip() for line in file]
    number = 0
    for line in lines:
        (winning_numbers, card_numbers) = parse_line(line)
        number += get_value(len(set(winning_numbers).intersection(set(card_numbers))))
    print(number)

    