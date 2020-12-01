def find_addends(numbers, goal_sum=2020):
    for i, val1 in enumerate(numbers):
        search_space = numbers[i+1:]
        for j, val2 in enumerate(search_space):
            diff = goal_sum - val1 - val2
            if diff in search_space[j+1:]:
                return [val1, val2, diff]
    raise RuntimeError('no two numbers add up to {}'.format(goal_sum))


with open('input.txt') as f:
    expenses = list(map(int, f.readlines()))
    addends = find_addends(expenses)
    print(addends[0] * addends[1] * addends[2])
