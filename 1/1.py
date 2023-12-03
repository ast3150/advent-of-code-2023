import re

filename = "full.txt"

def convert_to_number(match_obj):
    switch={
        'one':'o1e',
        'two':'t2o',
        'three':'t3e',
        'four':'f4r',
        'five':'f5e',
        'six':'s6x',
        'seven':'s7n',
        'eight':'e8t',
        'nine':'n9e'
    }
    return str(switch.get(match_obj.group(),""))

def readnumbers(line):
    line = re.sub(r"(one|two|three|four|five|six|seven|eight|nine|zero)", convert_to_number, line)
    line = re.sub(r"(one|two|three|four|five|six|seven|eight|nine|zero)", convert_to_number, line)
    numbers = re.findall(r"(\d)", line)
    return int(numbers[0] + numbers[-1])

with open(filename) as file:
    lines = [line.rstrip() for line in file]
    numbers = map(readnumbers, lines)
    print(sum(numbers))