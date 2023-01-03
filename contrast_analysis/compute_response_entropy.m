close all;

% load data
load('./contrast_vals_g_brc.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% apply transfer functions of CDFs

% compute CDFs & rescale - optimal transfer functions
aire.TF   = (mean(cumsum(air.yContLin,2) ./ sum(air.yContLin,2)) * (xContLin(end) - xContLin(1)))  + xContLin(1);
watere.TF = (mean(cumsum(water.yContLin,2) ./ sum(water.yContLin,2)) * (xContLin(end) - xContLin(1)))  + xContLin(1);

% get paths to all raw g video cubes
load([data_path '/air_g_brc_valid_cubes.mat']);
listing_air = listingclean;
load([data_path '/water_g_brc_valid_cubes.mat']);
listing_water = listingclean;

% grab luminance threshold used to create clean folder
maxVal = topbit;

%%% AIR

% load each video and perform equalization analysis
for l = 1:numel(listing_air)
    
    % load it
    load([data_path '/air_g_brc/' listing_air(l).name]);
    display(listing_air(l).name);
    
    % divide by mean
    gContVals = (cube(:) - mean(cube(:)))/mean(cube(:));
    
    % remove clipping
    gContVals = gContVals(cube < maxVal);
    
    % apply average cumulative for air and water
    gContValsTFairair = interp1(xContLin,aire.TF,gContVals);
    gContValsTFairwater = interp1(xContLin,watere.TF,gContVals);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute histogram on regular linear lattice -- air air
    [aire.yContLin(l,:),~] = histcounts(gContValsTFairair,xContLinEdges);

    % compute entropy
    [yContLinE,~] = histcounts(gContValsTFairair,xContLinEEdges);
    aire.entropy(l) = entropy_from_histogram(yContLinE,1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute histogram on regular linear lattice -- air water
    [aire.yContLinWater(l,:),~] = histcounts(gContValsTFairwater,xContLinEdges);

    % compute entropy
    [yContLinE,~] = histcounts(gContValsTFairwater,xContLinEEdges);
    bin_width = xContLinEEdges(2) - xContLinEEdges(1);
    aire.entropy_water(l) = entropy_from_histogram(yContLinE,1);
    
end

%%% WATER

% load each video and perform equalization analysis
for l = 1:numel(listing_water)
    
    % load it
    load([data_path '/water_g_brc/' listing_water(l).name]);
    display(listing_water(l).name);

    % divide by mean
    gContVals = (cube(:) - mean(cube(:)))/mean(cube(:));
    
    % remove clipping
    gContVals = gContVals(cube < maxVal);
    
    % apply average cumulative for water and entropyC
    gContValsTFwaterwater = interp1(xContLin,watere.TF,gContVals);
    gContValsTFwaterair = interp1(xContLin,aire.TF,gContVals);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute histogram on regular linear lattice -- water water
    [watere.yContLin(l,:),~] = histcounts(gContValsTFwaterwater,xContLinEdges);
    %xContLin = xContLin(1:end-1) + diff(xContLin,1);
    
    % compute entropy
    [yContLinE,~] = histcounts(gContValsTFwaterwater,xContLinEEdges);
    watere.entropy(l) = entropy_from_histogram(yContLinE,1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute histogram on regular linear lattice -- water air
    [watere.yContLinAir(l,:),~] = histcounts(gContValsTFwaterair,xContLinEdges);
    
    % compute entropy
    [yContLinE,~] = histcounts(gContValsTFwaterair,xContLinEEdges);
    bin_width = xContLinEEdges(2) - xContLinEEdges(1);
    watere.entropy_air(l) = entropy_from_histogram(yContLinE,1);
    
end

% save data
save(['entropy_vals_g_brc.mat'],'aire','watere');