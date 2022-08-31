rawF = readtable("RawF.txt");

head(rawF, 10)

[rows,cols] = size(rawF)

% extracting the fluorescence data from
% preprocessed RawF.txt table


% Extract the data for the first cell
rawF_vector = rawF{:,"Cell1"}; % could also write rawF.Cell1

% Plot the results
figure
plot(rawF_vector)

% Extract the data for all cells
rawF_matrix = rawF{:,5:end};

% Visualize the result with an image
figure
imagesc(rawF_matrix)
colorbar

plot(rawF{:, ["Cell16", "Cell24"]})
ylim([0 5000])
xlim([0,600])
legend()

% distribution of the fluorescence values to get the mode
histogram(rawF_vector, NumBins=1000, DisplayStyle="stairs")

% Get the baseline
rawF_rounded = round(rawF_vector/10)*10; % Round values to nearest multiple of 10
baseline = mode(rawF_rounded);
DFF_vector = (rawF_vector - baseline)/baseline;
% rawF_rounded should only be used for calculate the baseline

% Make plot of raw and normalized values for Cell 1
% figure
% plot(rawF_vector)
% xlabel('Row')
% ylabel('Raw F')
% title('Raw fluorescence values of Cell 1')
% 
% figure
% plot(DFF_vector)
% xlabel('Row')
% ylabel('\DeltaF/F')
% title('DF/F values of Cell 1')

% Generate DFF matrix for all cells
% Generate the DFF matrix
rawF_rounded = round(rawF_matrix/10)*10;
% for each cell (columns)
baseline = mode(rawF_rounded,1);
DFF_matrix = (rawF_matrix - baseline)./baseline;

% Create a copy of the rawF table named DFF
DFF = rawF;

% Overwrite the raw fluorescence data with DFF values
DFF{:,5:end} = DFF_matrix;

% Make plots of rawF and DFF matrices
figure
imagesc(rawF_matrix)
colorbar
xlabel("Column")
ylabel("Row")
title('Raw F values')

figure
imagesc(DFF_matrix)
colorbar
xlabel("Column")
ylabel("Row")
title('DF/F values')

% grouping
% create logical variables
isOn = DFF.Orientation==180 & DFF.Cycle=="ON";
isOff = DFF.Orientation==180 & DFF.Cycle=="OFF";
% extract DFF values for Cell1 for the two conditions
cellOn = DFF{isOn, "Cell1"};
cellOff= DFF{isOff, "Cell1"};
% calculate mean DFF values
meanOn = mean(cellOn) % also mean(DFF.Cell1(isOn))
meanOff = mean(cellOff)


% we need to calculate values for each stimulus condition,
% such as the orientation and cycle
% number of trials for std error statistics
numTrials=6;
% Use groupsummary to get summary statistics
results = groupsummary( ...
    DFF, ...
    ["Orientation", "Cycle"], ...
    ["mean", "std"],...
    ["Cell1"]);

% Print out table to see the values
results

% Extract data from results table to plot
% Standard error of the mean is std/sqrt(N)
meanCellOn = results{results.Cycle=="ON", "mean_Cell1"};
stdCellOn = results{results.Cycle=="ON", "std_Cell1"};
stdErrorCellOn = stdCellOn/sqrt(numTrials);
% scalar with the mean of Cell1 during the OFF cycle, 
% i.e., averaged accross all orientations
meanCellOff = mean(results{results.Cycle=="OFF", "mean_Cell1"});

% Get x-values for plot (stimulus orientations). We could also get these 
% values from our results table with some logical indexing. Try it!
orientations = 0:30:330;

% Errorbar plot with standard errors
figure
errorbar(orientations,meanCellOn,stdErrorCellOn)
yline(meanCellOff(1),"r");
legend("ON","OFF")
xlabel("Orientation (deg)")
ylabel("\DeltaF/F")
xlim([-30 360])



% -------------------------------------------------------------------
% Get average ON and OFF responses for all cells
% -------------------------------------------------------------------

% Get string array with the variable names, e.g. ["Cell1","Cell2", ... ]
cellNames = "Cell" + (1:73);

% Get the average responses for all cells with groupsummary
results = groupsummary( ...
    DFF, ...
    ["Orientation", "Cycle"], ...
    ["mean"],... % don't need the std here
    cellNames);

% Extract mean ON responses from the results table. This should be
% a 12 x 73 matrix. It may help to define which rows and columns you 
% need as separate variables.
rows = results.Cycle=="ON";
columns = "mean_" + cellNames;
meanOn = results{rows, columns};

% Extract mean OFF responses. This should be a 1 x 73 vector, averaged 
% across orientations.
rows = results.Cycle=="OFF";
%columns = ??; % same as above
meanOff = mean(results{rows, columns});

% -------------------------------------------------------------------
% Create a tuningCurves matrix
% -------------------------------------------------------------------

% Create a tuning curves matrix using meanOn and meanOff
% need to remove all ON responses that were weaker than average OFF
% response, thus substract ON responses by the OFF responsesn, then replace
% negative values with zeros using logical indexing
tuningCurves = meanOn - meanOff;

% Use logical indexing to replace negative values with zeros
tuningCurves(tuningCurves < 0) = 0;

% -------------------------------------------------------------------
% Plot some tuning curves (not graded)
% -------------------------------------------------------------------

% Pick some cells to plot. You can change this to any number of 
% cells, but it will be hard to tell apart the lines if you plot too
% many.
cellsToPlot = 1:6;

% Plot these tuning curves
orientation = 0:30:330;
plot(orientation,tuningCurves(:,cellsToPlot),"LineWidth",1.5);
xlabel("Orientation (deg)")
ylabel("ON response -  OFF response")
legend(cellNames(cellsToPlot))
title("Tuning curves")
