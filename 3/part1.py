import re
filename = "engine.txt"

def find_numbers_and_ranges(line: str):
    return re.finditer(r"(\d+)", line)

def is_adjacent_to_symbol(span: (int, int), line_index: int, lines: [str]):
    is_symbol = r"[^0-9\.]"

    prev_line = lines[line_index - 1] if (line_index - 1)  > 0 else ""
    line = lines[line_index]
    succ_line = lines[line_index + 1] if len(lines) > (line_index + 1) else ""
        
    for index in range(span[0] - 1, span[1] + 1):
        if index < 0:
            continue
        if len(prev_line) > index and re.match(is_symbol, prev_line[index]):
            return True
        if len(line) > index and re.match(is_symbol, line[index]):
            return True
        if len(succ_line) > index and re.match(is_symbol, succ_line[index]):
            return True

with open(filename) as file:
    lines = [line.rstrip() for line in file]
    number = 0
    for line_index, line in enumerate(lines):
        for match in find_numbers_and_ranges(line):
            if is_adjacent_to_symbol(match.span(), line_index, lines):
                print(match.group())
                number += int(match.group())

    print(number)