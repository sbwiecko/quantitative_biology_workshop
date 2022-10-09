clear, close all, clc,

disp('% Set the gambler''s prior'),
pause, 
table = ([18/37,0.95,0.0; 0.6,0.05,0.0; 0.0,0.0,0.0]), %SET VALUES
pause, 

disp('% Check that total prior probability sums to one'),
pause, 
prior_sum = table(1,2) + table(2,2),

if prior_sum ~= 1,
    disp('% oops! sum of prior probabilities does not equal one')
end
pause, 

disp(' '), 
disp('% plot the prior probability mass function'),
pause, 
bar(table(1:2,1),table(1:2,2:3),1),
axis([0,1,0,1]),
xlabel('probability that the ball lands in a red space (P(Red))'),
ylabel('probability'),
legend('prior probability'),
pause,  

disp('% Set data observation'),
pause, 
num_red = 13, %SET VALUE
num_spins = 14, %SET VALUE
pause, 

disp('% Calculate posterior probabilities using Bayes'' Rule'),
pause, 
binomial_coeff = factorial(num_spins)/(factorial(num_red)*factorial(num_spins - num_red)),

table(1,3) = (binomial_coeff * (table(1,1)^num_red*(1-table(1,1))^(num_spins-num_red)) * table(1,2)) / ((binomial_coeff * (table(1,1)^num_red*(1-table(1,1))^(num_spins-num_red)) * table(1,2)) + (binomial_coeff * (table(2,1)^num_red*(1-table(2,1))^(num_spins-num_red)) * table(2,2)) );
table(2,3) = (binomial_coeff * (table(2,1)^num_red*(1-table(2,1))^(num_spins-num_red)) * table(2,2)) / ((binomial_coeff * (table(1,1)^num_red*(1-table(1,1))^(num_spins-num_red)) * table(1,2)) + (binomial_coeff * (table(2,1)^num_red*(1-table(2,1))^(num_spins-num_red)) * table(2,2)) ),
pause, 

disp(' '), 
disp('% add the posterior probability mass function to the plot'),
pause, 
bar(table(1:2,1),table(1:2,2:3),1),
axis([0,1,0,1]),
xlabel('probability that the ball lands in a red space (P(Red))'),
ylabel('probability'),
legend('prior probability','posterior proba bility'),
pause, 

disp('% Calculate E(P(Red)) based on posterior probabilities'),
pause, 
table(3,3) = table(1,1)*table(1,3) + table(2,1)*table(2,3),
pause, 

disp('% Is the expected return on the Red bet > 0?'),
disp('(This requires that E(P(Red)) > 0.5)'),
pause,

if table(3,3) > 0.5,
    disp('% Yes, the Bayesian gambler should bet')
elseif table(3,3) <= 0.5,
    disp('% No, the Bayesian gambler should not bet')
end
pause,
 
disp(' '),
disp('% Change the observed data (num_red) and re-run to'),
disp('see how the calculated posterior probability changes.'), 
pause, 
 
disp(' '),
disp('% If you have time, go on to change the gambler''s prior'),
disp('to see how atering her belief changes the expected value'),
disp('of the bet. Can you find a prior where she shouldn''t make'),
disp('the bet based on observing 10 Red results out of 14 spins?'),