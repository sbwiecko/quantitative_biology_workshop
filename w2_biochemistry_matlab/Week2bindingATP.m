m = readmatrix('example2_data.csv'); %read the csv data file and store data into the matrix m

x = m(:,1); %define your x-axis data
y = m(:,2); %define your y-axis data

% Fit parameters
% Enter appropriate initial guesses. Delete any that are not needed
a0 = 2200;
b0 = 400;        
k0 = 10000;

ft = fittype('a*(x/(x+k))+b', 'independent', 'x', 'coefficients', {'a','b', 'k'}); %specify your custom equation
f = fit(x,y,ft,'startpoint', [a0, b0, k0]) %fit your custom equation to your data

plot(f, x,y, 'k+') %plot your fit line and data
xlabel('nanomolar [nM]', 'Fontsize', 12)
ylabel('arbitrary units', 'Fontsize', 12)
set(gca,'XTick', [0, 5e4, 10e4, 15e4], ...
    'XTickLabel',{'0','50,000','100,000','150,000'})
