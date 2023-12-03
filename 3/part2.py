import re
filename = "engine.txt"

def find_numbers(line: str):
    return re.finditer(r"(\d+)", line)

def find_gear_candidates(line: str):
    return re.finditer(r"(\*)", line)

def is_adjacent_to_gear(number_line: int, number_span: (int, int), gear_line: int, gear_span: (int, int)):
    if number_line < gear_line - 1 or number_line > gear_line + 1:
        return False
    if number_span[1] < gear_span[0]:
        return False
    if number_span[0] > gear_span[1]:
        return False
    return True

with open(filename) as file:
    lines = [line.rstrip() for line in file]
    total_number = 0
    numbers = []
    gear_candidates = []
    candidate_numbers = {}

    for line_index, line in enumerate(lines):    
        for match in find_numbers(line):
            numbers.append((line_index, match))

        for candidate in find_gear_candidates(line):
            gear_candidates.append((line_index, candidate))

    for number in numbers:
        for candidate in gear_candidates:
            if candidate not in candidate_numbers:
                candidate_numbers[candidate] = []
            if is_adjacent_to_gear(number[0], number[1].span(), candidate[0], candidate[1].span()):
                candidate_numbers[candidate].append(number[1].group())

    for candidate in candidate_numbers:
        if len(candidate_numbers[candidate]) == 2:
            total_number += int(candidate_numbers[candidate][0]) * int(candidate_numbers[candidate][1])

    print(total_number)