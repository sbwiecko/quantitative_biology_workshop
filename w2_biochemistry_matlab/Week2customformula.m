x_start = (0:0.5:10)';
x = x_start+randn(length(x_start),1)/10; % add a little variability to x_start (+/- 0.1)
y = 1./(1+exp(-2*(x-4))) + randn(length(x_start),1)/50; % add a little variability to y as well (+/- 0.1)

% Create the custom logistic fittype with fit parameters k and c
formula = '1/(1+exp(-k*(x-c)))';
ft = fittype( ...
    formula, ...
    'independent', 'x', ...
    'coefficients', {'k', 'c'});

% Use the fit function, the fittype variable, and initial parameter estimates
% to fit a logistic curve to the data
f = fit(x,y, ...
    ft, ...
    'startpoint', [2,4])

% Extract the fit parameters
k = f.k
c = f.c

% Add a plot
%figure()
%plot(x,y, 'k+')
%hold on
%plot(x, 1./(1+exp(-k*(x-c))), 'r')
%hold off

% Better way to plot data and fitting curve
plot(f, x, y, 'k+')