m = readmatrix('7QBW_Day2_Biochem_example1_data.csv'); %read the csv data file and store data into the matrix m

x = m(:,1); %Define your x-axis data, i.e. free I
y = m(:,2); %Define your y-axis data, i.e. fraction B bound
k0 = 100; %Define your initial guess for the value of Kd as the variable k0
% looking at the plot(x,y) at y=0.5
% 
ft = fittype('x/(x+k)', 'independent', 'x', 'coefficients', 'k'); %Specify your custom equation
f = fit(x,y,ft,'startpoint', [k0]) %Fit your custom equation to your data

plot(f, x, y, 'k^') %Plot your fit line and data 
xlabel('nanomolar [nM]')
ylabel('fraction bound') 