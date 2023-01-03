% compute the median contrast across all videos for visualization
close all;

% folders with air and water videos
folders = {['air_g_brc'],['water_g_brc']};


for f = 1:length(folders)

    % get paths to all raw g video cubes
    load([ data_path '/' folders{f} '_valid_cubes.mat']);
    listing = listingclean;

    % store global contrasts
    cubeContLin = zeros(225,225,1001*numel(listing));

    cnt = 1;

    % load each video
    for l = 1:numel(listing)

        % load it
        load([ data_path '/' folders{f} '/' listing(l).name]);

        %file name
        fname = strtok(listing(l).name,'.');
        display(fname);

        % Weber contrast
        gContVals = (cube - mean(cube(:)))/mean(cube(:));

        for x = 1:size(cube,3)

            cubeContLin(:,:,cnt) = gContVals(:,:,x);
            cnt = cnt + 1;

        end

    end

    % medians
    cubeContLin_avg = median(cubeContLin,3);

    % plot
    cmap = flipud([spring(256) ; flipud(summer(256))]);
    figure; hold on;
    imagesc(flipud(cubeContLin_avg));
    colormap(cmap);
    caxis([-1.5 1.5]);
    axis image off;
    colorbar

    saveas(gcf,['./plots/image_median_global_contrast_g_' folders{f} '.png']);

end
