def find_addends(numbers, goal_sum=2020):
    for i, val in enumerate(numbers):
        diff = goal_sum - val
        if diff in numbers[i+1:]:
            return [val, diff]
    raise RuntimeError('no two numbers add up to {}'.format(goal_sum))


with open('input.txt') as f:
    expenses = list(map(int, f.readlines()))
    addends = find_addends(expenses)
    print(addends[0] * addends[1])

