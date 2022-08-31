%This code simulates a very simplistic fishery. All the fish are in one
%place, and you can choose to harvest as many as you want.

%Can you manage the fishery sustainably?


%Imagine a fishery where the fish population grows logistically according
%to the equation:

%dN/dt = rN(1-N/K)

%where:     N = number of fish
%           t = time
%           r = population growth rate
%           K = carrying capacity


%Now, we will introduce a harvest term, H, which is the number of fish
%humans remove from the population by fishing:

%dN/dt = rN(1-N/K) - H


%Managers are often tasked with choosing this "H" so that the fishery is
%sustainable -- that is, so that the number of fish does not change from
%year to year.

%With a bit of algebra or calculus, you can arrive at the correct choice for H, 
%or you can play with the simulation below.



%Choose your parameters:
r = .1;     %Fish population growth rate
K = 100;    %Fish carrying capacity
N0 = K/2;   %Fish initial population size
t = 100;   %We'll let this run for a long time to see how you did

H = 0;  %Your choice of harvest rate


%Variables to hold data
time = linspace(0,t,t+1);
population = zeros(size(time));
harvest = zeros(size(time));

%Run the model
for i = 1:size(time,2)
   if i == 1
       population(i) = N0;
       harvest(i) = H;
   else
       population(i) = population(i-1) + (r*population(i-1)*(1-population(i-1)/K)-harvest(i-1));
       if population(i) > H
           harvest(i) = H;
       else
           harvest(i) = population(i);
       end
   end   
end


figure(2)
plot(time,population)
xlabel('Time (years)')
ylabel('Fish Population Size')


%Explore:   What happens if you "overfish" (i.e. H is too large)?
%           What happens if your fish population is destabilized (i.e.,
%           somehow your initial population gets bumped below K/2)?
