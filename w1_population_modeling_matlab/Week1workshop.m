%This code runs growth models using for loops and if statements

%Type of model to run: 1 = exponential; 2 = logistic -- student choice
modeltype = 2;

%Input parameters -- student choice
N0 = 1; %Initial population size
r = .1; %Population growth rate
K = 100; %Carrying capacity [only pertains to logistic]
t = 200; %Number of generations
tau = 20; %Population response time lag [only matters for logistic]
    %Time lags (a delay in when the population size affects the growth rate) are really 
    %interesting. Try playing with increasingly large time lags and watch what happens


%Make the "storage variables"
generation = linspace(0,t,t+1);
dNdt = zeros(size(generation));
population = zeros(size(generation));



%"If" statement selects appropriate model
if modeltype == 1   %run the exponential growth model
    for i = 1:size(generation,2)    
        if i == 1   %The generation has population = N0
            population(i) = N0;
            dNdt(i) = r*population(i);
        else
            population(i) = population(i-1)+dNdt(i-1); %At the new
            %timestep, the population has grown by dNdt from the previous
            %generation
            dNdt(i) = r*population(i);
        end
    end
        
elseif modeltype == 2   %run the logistic growth model
    for i = 1:size(generation,2)
        if i == 1
            population(i) = N0;
            dNdt(i) = r*population(i)*(1-population(i)/K);
        else
            if i <= tau  %If you have a time lag (tau > 0) you need this 
                %alternate logistic equation without time lag to get you through
                %the first few generations.
                population(i) = population(i-1)+dNdt(i-1);
                dNdt(i) = r*population(i)*(1-population(i)/K);
            else
                population(i) = population(i-1)+dNdt(i-1);
                dNdt(i) = r*population(i)*(1-population(i-tau)/K);
            end
        end
    end
    
else
    disp('Error: Choose 1 for exponential model or 2 for logistic model')
end


%figure()
subplot(3,1,1)
plot(generation,population)
xlabel('Generation')
ylabel('Population Size')
%Note that with the logistic model and a time lag you get multiple growth
%rate values for the same population size (which makes sense, because
%the population's growth rate depends both on its current size, and on
%its size at some past time point). This results in some pretty spirals...
subplot(3,1,2)
%figure()
plot(population,dNdt) %This plot is basically the derivative of the upper
    %panel. It is useful if you want to show that the growth rate of a
    %population depends upon its size. And, if you have a logistic model
    %with no time lags, it gives a nice demonstration of why MSY
    %(maximum sustainable yield, a fisheries concept) is at K/2.
xlabel('Population Size')
ylabel('Growth Rate')
subplot(3,1,3) %This plot allows us to see that the density
    %dependence of the growth rate varies with growth model. In exponential
    %growth, per capita reproduction (dNdt/N) is a constant (r). In
    %logistic growth, per capita reproductive rate decreases with
    %increasing population density.
%figure()
plot(population,dNdt./population)
xlabel('Population Size')
ylabel('Per Capita Growth Rate')  