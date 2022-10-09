%ROC Bowel Cancer ROC Example
clear, close all, clc,

disp('% Load test data')
pause,

load FecalBloodData_for_matlab_ROC.mat % contains test results and case status for 914 test cases
% The columns in FecalBloodData.mat are
    % 1. Fecal blood level (<<<ordered decereasingly>>>)
    % 2. indicator of case bowel cancer (1 positive, 0 negative)
    % 3. indicator of noncase bowel cancer
whos,
pause,

% histogram the 914 test values 
disp('% histogram the 914 test values'),
pause,
hist(ada(:,1),50);
xlabel('test value'), ylabel('number of tests'),
pause,
    
% Calculate number of true positive and false positive test results 
%    thresholds corresponding to each observed test value.
cumul_true_pos_calls  = cumsum(ada(:,2)); % sum positive indicators from patients with bowel cancer
cumul_false_pos_calls = cumsum(ada(:,3)); % sum positive indicators from patients without bowel cancer
pause,

% Calculate the number of positive and negative cases
disp('% Calculate the number of positive and negative cases'),
pause,
num_pos_cases = sum(ada(:,2)),
num_neg_cases = sum(ada(:,3)),
pause,

% Find the threshold such that the test has has 90% sensitivity
disp('% Find the threshold such that the test has has 90% sensitivity'),
pause,
index = find(cumul_true_pos_calls == round(num_pos_cases*0.90)); % ENTER your desired sensitivity here
index = (min(index));
threshold_value = ada(index,1),
pause,

% Generate a 2x2 results table for the chosen threshold value
disp('% Generate a 2x2 results table for the chosen threshold value')
pause,
tp = cumul_true_pos_calls(index); table(1,1) = tp;
fp = cumul_false_pos_calls(index); table(1,2) = fp; 
fn = sum(ada((index+1):end,2)); table(2,1) = fn;
tn = sum(ada((index+1):end,3)); table(2,2) = tn,
pause,

% Calculate the specificity at your chosen threshold value
disp('% Calculate the specificity at your chosen threshold value'),
pause,
sensitivity = tp / (tp + fn),
specificity = tn / (tn + fp),
pause,

% plot the ROC curve
disp('plot the ROC curve')
pause,
num_pos_cases = cumul_true_pos_calls(end);  % sum negative indicators from patients without bowel cancer
num_neg_cases = cumul_false_pos_calls(end); % sum negative indicators from patients with bowel cancer
sensitivity = cumul_true_pos_calls/num_pos_cases;    % sensitivity at the threshold
one_minus_specificity = cumul_false_pos_calls/num_neg_cases;  % 1-specificity at the threshold
plot(one_minus_specificity,sensitivity) % ROC is a plot of sensitivity against (1-specificity)
xlabel('1 - specificity'), ylabel('sensitivity')
x = 0:.1:1; % plot the line of no discrimination
y = 1*x;
hold on
plot(x,y,'--')
legend('ROC for fetal blood test','line of no discrimination','Location','southeast'),
pause,

% Calculate the AUC between the non-discriminant and discriminant lines
disp('% Calculate the AUC'), 
area_under_curve = sum((one_minus_specificity(2:end) - one_minus_specificity(1:end-1)) .* (sensitivity(2:end)+sensitivity(1:end-1))/2),
pause,  
disp('area under the ROC curve:')
disp('= 1.0 for a perfect test')
disp('= 0.5 for a test with no predictive value')
pause,
disp(' '),
disp('now modify the code and re-run to find'),
disp('the threshold value that give equal'),
disp('sensitivity and specificity'),
