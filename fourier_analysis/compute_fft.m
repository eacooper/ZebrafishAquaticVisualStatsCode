close all;

fname_tail = ['_g_cube'];
hanning = 1;

for f = 1:length(folders)

    figsp   = figure('units','normalized','outerposition',[0 0 1 1]); hold on;
    figt    = figure('units','normalized','outerposition',[0 0 1 1]); hold on;

    % get paths to all raw video cubes
    load([data_path '/' folders{f} '_valid_cubes.mat']);
    listing = listingclean;

    % get paths for output
    outFolder = [data_path '/fourierCubes/' folders{f} '/'];
    if ~exist(outFolder,'dir')
        mkdir(outFolder);
        addpath(outFolder);
        savepath
    end

    % load each video and compute fourier analysis
    for l = 1:numel(listing)

        % load it
        load([data_path '/' folders{f} '/' listing(l).name]);

        %file name
        fname = strtok(listing(l).name,'.');
        fname = replace(fname,fname_tail,''); fname_plot = replace(fname,'_',' ');
        disp([num2str(l) '-th cube: ' fname]);

        % normalize values
        cube = cube/mean(cube(:));

        % perform 3D fft
        fftCube = my_fft3(cube,hanning);

        % crop to remove repeated values, just in Time dimension
        fftCube = fftCube(:,:,((size(cube,3)+1)/2):size(cube,3));

        % plot spatial spectrum
        figure(figsp); subplot(7,7,l); hold on; title(fname_plot);
        imagesc(log10(squeeze(mean(fftCube,3)))); box on; axis equal tight; drawnow;

        % plot temporal spectrum
        figure(figt); subplot(7,7,l); hold on; title(fname_plot);
        imagesc(log10(squeeze(mean(fftCube,1)))); box on; axis equal tight; drawnow;

        % save it
        if hanning==1
            save([outFolder fname '_fourierCube.mat'],'fftCube');
        else
            save([outFolder fname '_noHanning_fourierCube.mat'],'fftCube');
        end

    end

    % save fourier images
    if hanning==1
        saveas(figsp,['./plots/histograms_space_' folders{f} '.png']);
        saveas(figt,['./plots/histograms_time_' folders{f} '.png']);
    else
        saveas(figsp,['./plots/histograms_space_' folders{f} '_noHanning.png']);
        saveas(figt,['./plots/histograms_time_' folders{f} '_noHanning.png']);
    end

    close all;

end

