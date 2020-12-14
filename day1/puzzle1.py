def find_addends(numbers, goal_sum=2020):
    for i, val in enumerate(numbers):
        diff = goal_sum - val
        if diff in numbers[i+1:]:
            return [val, diff]
    raise RuntimeError('no two numbers add up to {}'.format(goal_sum))

# added this just to show that sorting is often a good idea...
def find_addends_fast(numbers, goal_sum=2020):
    numbers.sort()
    last_min = 1
    last_max = len(numbers) - 1
    for v1 in numbers:
        for i in range(last_max, last_min, -1):
            v2 = numbers[i]
            s = v1 + v2
            if s > goal_sum:
                last_max = i - 1
            elif s < goal_sum:
                last_min = i
                break
            else:
                return [v1, v2]

from datetime import datetime, timedelta

with open('input.txt') as f:
    expenses = list(map(int, f.readlines()))

    now = datetime.now()
    addends = find_addends(expenses)
    diff = datetime.now() - now
    print(diff)

    print(addends[0] * addends[1])

    now = datetime.now()
    addends = find_addends_fast(expenses)
    diff = datetime.now() - now
    print(diff)

    print(addends[0] * addends[1])

