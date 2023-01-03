close all;

for f = 1:length(folders)

    figcont = figure('units','normalized','outerposition',[0 0 1 1]); hold on;
    figlocal = figure('units','normalized','outerposition',[0 0 1 1]); hold on;

    % get paths to all raw g video cubes
    load([data_path '/' folders{f} '_valid_cubes.mat'],'listingclean','topbit');
    listing = listingclean;

    % grab luminance threshold used to create clean folder
    maxVal = topbit;

    % number of bins for histograms
    nbins1 = 55;

    for l = 1:numel(listing)

        % load it
        load([data_path '/' folders{f} '/' listing(l).name],'cube');
        fname_tail = ['_g_cube'];

        %file name
        fname = strtok(listing(l).name,'.');
        display(fname);
        fname_plot = replace(fname,fname_tail,''); fname_plot = replace(fname_plot,'_',' ');

        % split the cube into cube_u for upper field and cube_l for lower field
        cube_u = cube(1:112, :, :);
        cube_l = cube(114:end, :, :);

        % Weber contrast
        gContVals_u = (cube_u(:) - mean(cube(:)))/mean(cube(:));
        gContVals_l = (cube_l(:) - mean(cube(:)))/mean(cube(:));

        % remove clipping
        gContVals_u = gContVals_u(cube_u < maxVal);
        gContVals_l = gContVals_l(cube_l < maxVal);

        % histogram
        figure(figcont); hold on;
        subplot(10,8,l); hold on; title(fname_plot,'FontSize',10);set(gca, 'FontSize', 10);
        histogram(gContVals_u(:)); box on; drawnow;
        subplot(10,8,(l+40)); hold on; title(fname_plot,'FontSize',10);set(gca, 'FontSize', 10);
        histogram(gContVals_l(:)); box on; drawnow;

        % compute histogram on regular linear lattice
        xContLinEdges = linspace(-1.5,4,nbins1);
        [yContLin_u(l,:),~] = histcounts(gContVals_u,xContLinEdges);
        [yContLin_l(l,:),~] = histcounts(gContVals_l,xContLinEdges);
        xContLin = xContLinEdges(1:end-1) + (diff(xContLinEdges,1)/2);

        % compute statistical moments in linear space
        meanLinC_u(l) = mean(gContVals_u);
        stdLinC_u(l) = std(gContVals_u);
        skewLinC_u(l) = skewness(gContVals_u);
        kurtLinC_u(l) = kurtosis(gContVals_u);
        meanLinC_l(l) = mean(gContVals_l);
        stdLinC_l(l) = std(gContVals_l);
        skewLinC_l(l) = skewness(gContVals_l);
        kurtLinC_l(l) = kurtosis(gContVals_l);

        % compute proportion negative contrast
        propNegLinC_u(l) = sum(gContVals_u < 0)/numel(gContVals_u);
        propNegLinC_l(l) = sum(gContVals_l < 0)/numel(gContVals_l);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % repeat for local contrast (DoG)

        % define parameters of local contrast operator
        csig            = 3;                                % sigma of central Gaussian
        ssig            = 6;                               % sigma of antagonistic surround Gaussian
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

        % split the cube into cube_u for upper field and cube_l for lower field
        cubeRGC_u = cubeRGC(1:112, :, :);
        cubeRGC_l = cubeRGC(114:end, :, :);

        lContVals_u = cubeRGC_u(:);
        lContVals_l = cubeRGC_l(:);

        % histogram
        figure(figlocal); hold on;
        subplot(10,8,l); hold on; title(fname_plot,'FontSize',10);set(gca, 'FontSize', 10);
        histogram(lContVals_u(:)); box on; drawnow;
        subplot(10,8,(l+40)); hold on; title(fname_plot,'FontSize',10);set(gca, 'FontSize', 10);
        histogram(lContVals_l(:)); box on; drawnow;

        % compute histogram on regular linear lattice
        xLocalContLinEdges = linspace(-0.5,0.5,nbins1*2);
        [yLocalContLin_u(l,:),~] = histcounts(lContVals_u,xLocalContLinEdges);
        [yLocalContLin_l(l,:),~] = histcounts(lContVals_l,xLocalContLinEdges);
        xLocalContLin = xLocalContLinEdges(1:end-1) + (diff(xLocalContLinEdges,1)/2);

        % compute statistical moments in linear space
        meanLocalLinC_u(l) = mean(lContVals_u);
        stdLocalLinC_u(l) = std(lContVals_u);
        skewLocalLinC_u(l) = skewness(lContVals_u);
        kurtLocalLinC_u(l) = kurtosis(lContVals_u);
        meanLocalLinC_l(l) = mean(lContVals_l);
        stdLocalLinC_l(l) = std(lContVals_l);
        skewLocalLinC_l(l) = skewness(lContVals_l);
        kurtLocalLinC_l(l) = kurtosis(lContVals_l);

        % compute proportion negative contrast
        propLocalNegLinC_u(l) = sum(lContVals_u < 0)/numel(lContVals_u);
        propLocalNegLinC_l(l) = sum(lContVals_l < 0)/numel(lContVals_l);

    end

    if ~isempty(strfind(folders{f},'air'))

        %global
        air.yContLin_u = yContLin_u;
        air.meanLinC_u = meanLinC_u;
        air.stdLinC_u  = stdLinC_u;
        air.skewLinC_u = skewLinC_u;
        air.kurtLinC_u = kurtLinC_u;

        air.yContLin_l = yContLin_l;
        air.meanLinC_l = meanLinC_l;
        air.stdLinC_l  = stdLinC_l;
        air.skewLinC_l = skewLinC_l;
        air.kurtLinC_l = kurtLinC_l;

        air.propNegLinC_u = propNegLinC_u;
        air.propNegLinC_l = propNegLinC_l;

        % local
        air.yLocalContLin_u = yLocalContLin_u;
        air.meanLocalLinC_u = meanLocalLinC_u;
        air.stdLocalLinC_u  = stdLocalLinC_u;
        air.skewLocalLinC_u = skewLocalLinC_u;
        air.kurtLocalLinC_u = kurtLocalLinC_u;

        air.yLocalContLin_l = yLocalContLin_l;
        air.meanLocalLinC_l = meanLocalLinC_l;
        air.stdLocalLinC_l  = stdLocalLinC_l;
        air.skewLocalLinC_l = skewLocalLinC_l;
        air.kurtLocalLinC_l = kurtLocalLinC_l;

        air.propLocalNegLinC_u = propLocalNegLinC_u;
        air.propLocalNegLinC_l = propLocalNegLinC_l;

    elseif ~isempty(strfind(folders{f},'water'))

        water.yContLin_u = yContLin_u;
        water.meanLinC_u = meanLinC_u;
        water.stdLinC_u  = stdLinC_u;
        water.skewLinC_u = skewLinC_u;
        water.kurtLinC_u = kurtLinC_u;

        water.yContLin_l = yContLin_l;
        water.meanLinC_l = meanLinC_l;
        water.stdLinC_l  = stdLinC_l;
        water.skewLinC_l = skewLinC_l;
        water.kurtLinC_l = kurtLinC_l;

        water.propNegLinC_u = propNegLinC_u;
        water.propNegLinC_l = propNegLinC_l;

        % local
        water.yLocalContLin_u = yLocalContLin_u;
        water.meanLocalLinC_u = meanLocalLinC_u;
        water.stdLocalLinC_u  = stdLocalLinC_u;
        water.skewLocalLinC_u = skewLocalLinC_u;
        water.kurtLocalLinC_u = kurtLocalLinC_u;

        water.yLocalContLin_l = yLocalContLin_l;
        water.meanLocalLinC_l = meanLocalLinC_l;
        water.stdLocalLinC_l  = stdLocalLinC_l;
        water.skewLocalLinC_l = skewLocalLinC_l;
        water.kurtLocalLinC_l = kurtLocalLinC_l;

        water.propLocalNegLinC_u = propLocalNegLinC_u;
        water.propLocalNegLinC_l = propLocalNegLinC_l;

    end

    % save histograms
    saveas(figcont,['./plots/histograms_hemifields_g_' folders{f} '.png']);

end

save('contrast_vals_g_hemifields.mat','air','water','xContLinEdges','xContLin');
