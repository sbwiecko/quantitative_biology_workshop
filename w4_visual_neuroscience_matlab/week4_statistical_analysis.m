% Load variables from file PopMap.mat
load PopMap.mat img ROIs OSI PO tuningCurves

% Variables available:
% OSI, PO, tuningCurves
% img, the average projection image you made in ImageJ
% ROIs, the regions of interest for each cell

% Get the number of cells
numCells = size(tuningCurves,2);        
        
% Display average projection image
image(img) 
axis square

% Setup the colormap. This is a 180 x 3 matrix. Each row is an RGB vector
% that specifies a color. There are 180 rows, which we'll map to each
% orientation degree from 1 to 180 degrees, i.e. 1,2...,180. For example,
% if the PO value is 120 degrees, we will use the color defined by
% colors(120,:)
colors = hsv(180); 

% Loop for each cell
for i = 1:numCells
    
    % get ROI coordinates
    roi = ROIs{i}.mnCoordinates;    
    
    % Pick a color. 
    %   Not visually responsive = black 
    %   Broadly tuned = white 
    %   Visually responsive = lookup from list of colors
    if all(tuningCurves(:,i)==0) % also if isnan(OSI(i))
        roiColor = zeros(1,3); % black  
    elseif OSI(i) < .25       
        roiColor = ones(1,3); % white
    else
        POind = ceil(PO(i));
        roiColor = colors(POind,:);
    end      
    
    % Draw a colored ROI
    patch(roi(:,1),roi(:,2),roiColor)    
end     

% Plot options
ax = gca(); % current axes
ax.Colormap = colors;
ax.CLim = [0 180];
ax.XTick = [];
ax.YTick = [];
cb = colorbar();
cb.Label.String = "Preferred orientation (deg)";
title("Population Orientation Map")      