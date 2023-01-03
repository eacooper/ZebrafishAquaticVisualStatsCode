% compute the contrast distributions for each video cube and save the results

% separately for air and water
for f = 1:length(folders)
    
    figglobal = figure('units','normalized','outerposition',[0 0 1 1]); hold on;
    figlocal = figure('units','normalized','outerposition',[0 0 1 1]); hold on;

    % get paths to all raw g video cubes
    load([ data_path '/' folders{f} '_valid_cubes.mat']);
    listing = listingclean;
    
    % grab luminance threshold used to create clean folder
    maxVal = topbit;
    
    % number of bins for histograms
    nbins1 = 55;
    
    % load each video and compute histogram and 4 statistical moments
    for l = 1:numel(listing)
        
        % load it
        load([ data_path '/' folders{f} '/' listing(l).name]);
        fname_tail = ['_g_cube'];
        
        %file name
        fname = strtok(listing(l).name,'.');
        display(fname);
        fname_plot = replace(fname,fname_tail,''); fname_plot = replace(fname_plot,'_',' ');
        
        % Weber contrast
        gContVals = (cube(:) - mean(cube(:)))/mean(cube(:));
        
        % remove clipping
        gContVals = gContVals(cube < maxVal);
        
        % histogram
        figure(figglobal); hold on;
        subplot(7,7,l); hold on; title(fname_plot,'FontSize',10);set(gca, 'FontSize', 10);
        histogram(gContVals(:)); box on; drawnow;
        
        % compute histogram on regular linear lattice
        xContLinEdges = linspace(-1.5,4,nbins1);
        [yContLin(l,:),~] = histcounts(gContVals,xContLinEdges);
        xContLin = xContLinEdges(1:end-1) + (diff(xContLinEdges,1)/2);

        % compute statistical moments in linear space
        meanLinC(l) = mean(gContVals);
        stdLinC(l) = std(gContVals);
        skewLinC(l) = skewness(gContVals);
        kurtLinC(l) = kurtosis(gContVals);
        
        % compute proportion negative contrast
        propNegLinC(l) = sum(gContVals < 0)/numel(gContVals);
        
        % compute entropy in linear space (use 256 bins to reflect number of discrete measurements)
        xContLinEEdges = linspace(-1,4,256);
        [yContLinE,~] = histcounts(gContVals,xContLinEEdges);
        entropyC(l) = entropy_from_histogram(yContLinE,1);
        
        display(['mean contrast = ' num2str(meanLinC(l),5) ]);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % repeat for local contrast (DoG)
        
        % define parameters of local contrast operator
        csig            = 3;                                % sigma of central Gaussian, in pixels
        ssig            = 6;                                % sigma of antagonistic surround Gaussian
        rf_size         = -(ssig*3):1:(ssig*3);             % positions at which to define the filter
        center          = make_gaussian_rf(rf_size,csig);   % central Gaussian
        surround        = make_gaussian_rf(rf_size,ssig);   % surround Gaussian
        ada             = surround;                         % adaptive pool
        
        % perform spatial convolution
        for x = 1:size(cube,3)
            
            im      = cube(:,:,x);
            imcen   = conv2( im, center, 'same' );                         % center filtered
            imsur   = conv2( im, surround, 'same' );                         % surround filtered
            imad    = conv2( im, ada, 'same' );                         % adaptation filter for divisive normalization, same as surround
            imRGC   = (imcen - imsur)./imad;                            % combine center - surround, and divisive normalization
            
            imRGC   = imRGC(round(numel(rf_size)/2)+1:end-round(numel(rf_size)/2),round(numel(rf_size)/2)+1:end-round(numel(rf_size)/2),:);          % crop edges by 1/2 filter width
            
            cubeRGC(:,:,x) = imRGC;
            
        end
        
        lContVals = cubeRGC(:);

        % histogram
        figure(figlocal); hold on;
        subplot(7,7,l); hold on; title(fname_plot,'FontSize',10);set(gca, 'FontSize', 10);
        histogram(lContVals); box on; drawnow;
        
        % compute histogram on regular linear lattice
        xLocalContLinEdges = linspace(-0.5,0.5,nbins1*2);
        [yLocalContLin(l,:),~] = histcounts(lContVals,xLocalContLinEdges);
        xLocalContLin = xLocalContLinEdges(1:end-1) + (diff(xLocalContLinEdges,1)/2);
        
        % compute statistical moments in linear space
        meanLocalLinC(l) = mean(lContVals);
        stdLocalLinC(l) = std(lContVals);
        skewLocalLinC(l) = skewness(lContVals);
        kurtLocalLinC(l) = kurtosis(lContVals);
        
        % compute proportion negative contrast
        propLocalNegLinC(l) = sum(lContVals < 0)/numel(lContVals);
        
        display(['mean local contrast = ' num2str(meanLocalLinC(l),5) ]);
        
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % save all together
    if ~isempty(strfind(folders{f},'air'))
        
        % global contrast
        air.yContLin = yContLin;
        air.meanLinC = meanLinC;
        air.stdLinC  = stdLinC;
        air.skewLinC = skewLinC;
        air.kurtLinC = kurtLinC;
        air.entropyC = entropyC;
        
        air.propNegLinC = propNegLinC;
        
        % local contrast
        air.yLocalContLin = yLocalContLin;
        air.meanLocalLinC = meanLocalLinC;
        air.stdLocalLinC  = stdLocalLinC;
        air.skewLocalLinC = skewLocalLinC;
        air.kurtLocalLinC = kurtLocalLinC;
        
        air.propLocalNegLinC = propLocalNegLinC;
        
        
    elseif ~isempty(strfind(folders{f},'water'))
        
        water.yContLin = yContLin;
        water.meanLinC = meanLinC;
        water.stdLinC  = stdLinC;
        water.skewLinC = skewLinC;
        water.kurtLinC = kurtLinC;
        water.entropyC = entropyC;
        
        water.propNegLinC = propNegLinC;
        
        % local contrast
        water.yLocalContLin = yLocalContLin;
        water.meanLocalLinC = meanLocalLinC;
        water.stdLocalLinC  = stdLocalLinC;
        water.skewLocalLinC = skewLocalLinC;
        water.kurtLocalLinC = kurtLocalLinC;

        water.propLocalNegLinC = propLocalNegLinC;
        
    end
    
    % save histograms
    saveas(figglobal,['./plots/histograms_global_' folders{f} '.png']);
    saveas(figlocal,['./plots/histograms_local_' folders{f} '.png']);
end

% save data
save(['./contrast_vals_g_brc.mat'],'air','water','xContLinEdges','xContLin','xContLinEEdges','xLocalContLin','xLocalContLinEdges');

