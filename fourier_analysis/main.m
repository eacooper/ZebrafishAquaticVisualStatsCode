clear; close all;

% path to dataset
data_path = '../../dataset';
folders = {'air_g_brc','water_g_brc'};

% step 1: compute fft of each video and store results
% this is slow and saves the results to a fourierCubes subfolder in the data_path folder, so it can
% be commented out if just plotting
compute_fft;

% step 2: load fourierCubes and compute summary power in spatiotemporal bins and space/time marginals, store results
compute_fourier_summary;

% step 3: plot average heatmaps and marginals (Figure 4)
plot_fullspectra;
plot_fourier_marginals;

% step 4: compute slope and intercept of marginals, plots slope stats
compute_fourier_stats;
