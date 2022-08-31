% The following code is used to generate noisy linear data with initial slope 2 and intercept 1. 
% 
x = (0:100)'; % column vector of x-values;

y = 2*x+1+randn(length(x),1); % generate colmn vector of y-data + random noise
      
% Enter your solution below.
fitObj = fit(x, y, 'poly1')
m = fitObj.p1;
b = fitObj.p2; 

%plot(x,y, 'r+')