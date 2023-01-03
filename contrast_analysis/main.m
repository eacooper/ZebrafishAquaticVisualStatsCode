clear; close all;

% path to dataset
data_path = '../../dataset';
folders = {'air_g_brc','water_g_brc'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% overall contrast analysis (Figure 2)

% (0) compute the contrast distributions for each video and save the results
% this is slow and saves the results to contrast_vals_g_brc.mat, so it can
% be commented out if just plotting
compute_contrast_distributions;

% (1) plot the full distributions of global contrast
plot_contrast_distributions;

% (2) compute stats on momenta and make plots
contrast_stats;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% upper and lower field comparison analysis (Figure 3)

% (0) make average contrast images for air and water
make_average_images;

% (1) compute contrast distributions of upper and lower fields for each video sample
% this is slow and saves the results to contrast_vals_g_hemifields.mat, so it can
% be commented out if just plotting
compute_contrast_distributions_hemifields;

% (2) plot contrast distributions
plot_contrast_distributions_hemifields;

% (3) plot stats of upper and lower fields
contrast_stats_hemifields;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% entropy analysis (Figure 5)
%(0) pre-compute entropy of neural responses with optimal transfer
%functions of when swapped between air/water
% this is slow and saves the results to entropy_vals_g_brc.mat, so it can
% be commented out if just plotting
compute_response_entropy;

% (1) plot the optimal transfer functions, resulting response probabilities
% if optimal or swapped, and resulting neural entropy
plot_and_stats_response_entropy;


