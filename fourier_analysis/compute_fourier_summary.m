close all;

% Set up analysis params

% load half_fov_deg, frame_rate, cut_off, nFrames, and apertureSizeDeg.
load('./metadata_fourierCubes.mat');

% Compute video clip duration in seconds (e.g., 10.01 s for S and T10, 7.51 s for T40, etc.)
nSec = (nFrames * 2 - 1) / frame_rate;

% Set maximum and minimum spatial frequency for analysis (cpd)
maxsf = 225/2/apertureSizeDeg;
minsf = cut_off * (1 / apertureSizeDeg); % use cut_off times true minsf to remove sampling artifacts
capsf = 0.75;

% Set maximum and minimum temporal frequency (Hz)
maxtf = frame_rate / 2;
mintf = cut_off * (1 / nSec);

% bins along the spatial and temporal dimensions for heatmap/marginals

% spatial
nSFbins = 19;
Xsf_edges = logspace(log10(minsf), log10(capsf), nSFbins+1); % edges of SF bins desired for analysis
Xsf_centers = logspace(log10(minsf), log10(capsf), 2*nSFbins+1); % edges of TF bins desired for analysis
Xsf_centers = Xsf_centers(2:2:end);

% temporal
tfs       = linspace((1 / nSec), maxtf, nFrames+1);         % tf for each frame in fourier cube
nTFbins   = 19;
Xtf_edges = logspace(log10(mintf), log10(maxtf), nTFbins+1); % edges of TF bins desired for analysis
Xtf_centers = logspace(log10(mintf), log10(maxtf), 2*nTFbins+1); % edges of TF bins desired for analysis
Xtf_centers = Xtf_centers(2:2:end);

% make a meshgrid to specify the sf and tf of each power bin
[SF_centers_grid,TF_centers_grid] = meshgrid(Xsf_centers,Xtf_centers);

% transpose so that SF is in rows and TF is in columns
SF_centers_grid = SF_centers_grid';
TF_centers_grid = TF_centers_grid';


% for each folder
for f = 1:length(folders)

    % get paths to all fourier cubes
    listing = dir([data_path '/fourierCubes/' folders{f} '/*.mat']);

    %  plot all spectra and store averaged spectra as a separate variable
    fig   = figure('units','normalized','outerposition',[0 0 1 1]); hold on;

    % initialize average variables
    clear avg_heatmap; avg_heatmap = zeros(size(SF_centers_grid));

    % load each fourier cube and compute summaries
    for l = 1:numel(listing)

        % make sure no other fftCube's linger
        clear fftCube; % works even if fftCube doesn't exist

        %% load it
        load([data_path '/fourierCubes/' folders{f} '/' listing(l).name]);

        %file name
        fname = strtok(listing(l).name,'.');
        fname = replace(fname,'_fourierCube',''); fname_plot = replace(fname,'_',' ');
        disp([num2str(l) '-th cube: ' fname]);

        % square to get power spectrum
        ampCube   = fftCube;
        powerCube = fftCube.^2;

        %% summarize power spectra

        % compute spatial frequency power spectrum for each temporal freq. slice of powerCube
        disp('Computing binned spatiotemporal spectrum...');
        clear Xsf;
        clear powerSF;
        clear power_bins;

        parfor iSlice = 1:nFrames
            [~,powerSF(iSlice,:)] = compute_freq_spectra(powerCube(:,:,iSlice),minsf,maxsf,Xsf_edges);

            % Take the average power in this frame to get temporal marginal
            current_slice = powerCube(:,:,iSlice);
            temporal_marg_all(iSlice) = mean(current_slice(:)); % variable size 1-by-nFrames
        end

        % Take the average across all temporal frequency slices to get spatial marginal
        spatial_marg = mean(powerSF,1); % variable size is 1-by-19

        % compute spatial power spectra for each temporal frequency bins
        for iTFbin = 1:nTFbins
            inds                  = find( tfs >= Xtf_edges(iTFbin) & tfs < Xtf_edges(iTFbin+1)); % indices of spatial power spectrum to grab
            power_bins(iTFbin,:)  = mean(powerSF(inds,:),1);                                       % mean spatial spectrum in this bin
            temporal_marg(iTFbin) = mean(temporal_marg_all(inds));                                 % mean power in this bin
        end

        % transpose so that SF is in rows and TF is in columns
        power_bins = power_bins';


        % plot spatiotemporal spectrum (individual heatmaps)
        % row = sf, col = tf
        subplot(7,7,l); hold on; title(fname_plot);

        ph = imagesc([Xtf_centers(1) Xtf_centers(end)],[Xsf_centers(1) Xsf_centers(end)], log10(power_bins));
        set(gca,'ydir','normal')
        colorbar;
        xlabel('temporal (hz)'); ylabel('spatial (cpd)');
        set(gca,'fontsize',9);
        box on; axis square tight; drawnow;

        % save it
        disp('saving...');
        save(['./powerSpectra/' folders{f} '/' fname '_logbinned_powerSpectra.mat'],...
            'power_bins','Xsf_centers','Xtf_centers','spatial_marg','temporal_marg','SF_centers_grid','TF_centers_grid');

        % update calculation of averages
        avg_heatmap  = avg_heatmap + power_bins./numel(listing);

    end

    % save avg_heatmap
    save(['./powerSpectra/summary_g_logbinned_avg_heatmap_' folders{f} '.mat'], 'avg_heatmap','Xsf_centers','Xtf_centers','SF_centers_grid','TF_centers_grid');

    % save plot
    saveas(gcf,['./plots/spectra_' folders{f} '_logbinned.png']);
    close all;

end

