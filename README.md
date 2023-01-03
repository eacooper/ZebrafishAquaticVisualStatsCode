# ZebrafishAquaticVisualStatsCode

This repository contains Matlab code for running the analyses described in the manuscript "Spatiotemporal visual statistics of aquatic environments in the natural habitats of zebrafish" By Cai et al. 

The dataset of terrestrial and aquatic videos should be downloaded separately from:

X

and the path should be manually updated in the code.

The repository is split into two parts:

## Contrast Analysis

This code runs the analyses of global and local contrast statistics (Figures 2, 3, and 5B/C). The script "main" sets the appropriate paths and calls a set of scripts to run each analysis, save plots, and report statistical tests.

## Fourier Analysis

This code runs the analyses of spatiotemporal statistics (Figures 4 and 5A). The script "main" sets the appropriate paths and calls a set of scripts to run each analysis, save plots, and report statistical tests.

## About the dataset

The dataset you download from Zenodo contains all of the terrestrial (air_g_brc) and aquatic (water_g_brc) videos (sometimes called "cubes" in the code) that were subsampled from the original field recordings, as well as mat files (air_g_brc_valid_cubes.mat, water_g_brc_valid_cubes.mat) with the names of the files that were used for the final analysis after applying exclusion criteria. There is also a folder called "fourierCubes" that contains the results of applying a Fourier transform to the valid cubes, using the code found in the Fourier Analysis section of this repository.
