m = readmatrix('7QBW_Day2_Biochem_example3_data.csv'); %Read the csv data file and store data into the matrix m

x = m(:,1); %Define your x-axis data
y = m(:,2); %Define your y-axis data

% Fit parameters
% Enter appropriate initial guesses. Delete any that are not needed
a0 = 1500;
b0 = 200;        
k0 = .693/200; % using roughly t1/2 as denominator

ft = fittype( ...
    'b+a*exp(-k*x)', ...
    'independent', 'x', ...
    'coefficients', {'a', 'b', 'k'}); %Specify your custom equation
f = fit(x,y,ft,'startpoint', [a0,b0,k0]) %Fit your custom equation to your data

plot(f, x,y,'bs') %Plot your fit line and data
xlabel('time [seconds]')
ylabel('arbitrary units') 
