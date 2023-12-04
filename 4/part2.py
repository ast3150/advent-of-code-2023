import re
from functools import cmp_to_key

filename = "input.txt"
memo = {}

def get_wins(line: str):
    digits = r"(\d+)"
    line = str.split(line, ": ")[1]
    parts = str.split(line, '|')
    (winning_numbers, card_numbers) = (re.findall(digits, parts[0]), re.findall(digits, parts[1]))
    return len(set(winning_numbers).intersection(set(card_numbers)))

def expand_cards(index: int, lines: [str]):
    if index in memo:
        return memo[index]

    wins = get_wins(lines[index])
    if wins == 0:
        result = lines[index]
    else:
        cards = []
        for win in range(1, wins+1):
            cards.append(expand_cards(index + win, lines))
        result = [lines[index]] + cards
    memo[index] = result
    return result

def flatten(A):
    rt = []
    for i in A:
        if isinstance(i,list): rt.extend(flatten(i))
        else: rt.append(i)
    return rt


with open(filename) as file:
    lines = [line.rstrip() for line in file]
    cards = []
    for (i, line) in enumerate(lines):
        cards.append(expand_cards(i, lines))
    print(len(flatten(cards)))