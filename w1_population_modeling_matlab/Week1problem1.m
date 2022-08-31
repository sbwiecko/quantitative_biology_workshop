m = csvread('test.txt',1,0);
m
%%Start coding below this point!
% analyzes the numbers in the 2nd column of array m
% for whether they are odd or even

% get the length of the column
nrows = size(m, 1);

% create the oddoreven column vector
% of the size of the input matrix
oddoreven = zeros(nrows, 1);

% for each row of the colum:
% - check if the value in the 2nd column
%   of matrix m is even or odd using modulus operator
% - put 1 or 0 in the oddoreven column vector

for idx = 1:nrows
    if mod(m(idx, 2), 2) == 0
        oddoreven(idx) = 1;
    end % no need to change the zeros already place if False
end

oddoreven
% we could solve it with this kind of element-wise approach
% oddoreven = ~mod(m[2, :], 2)
