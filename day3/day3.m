input = regexp(fileread('input.txt'), '\n', 'split');
m = vertcat(input{:});

% part 1
fprintf('part 1: %d\n', ...
sum(m(sub2ind(size(m), 2:size(m,1), mod((1:size(m,1)-1) * 3, size(m, 2)) + 1)) == '#'));

% part 2
right = [1 3 5 7 1];
down  = [1 1 1 1 2];
res = ones(size(right));
for i = 1:numel(right)
    col = mod((1:size(m,1)-1) * right(i), size(m, 2)) + 1;
    row = (2:down(i):size(m,1)) + down(i) - 1;
    res(i) = sum(m(sub2ind(size(m), row, col(1:numel(row)))) == '#');
end
fprintf('part 2: %d\n', prod(res));
