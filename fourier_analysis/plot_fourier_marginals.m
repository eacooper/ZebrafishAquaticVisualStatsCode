close all;

addpath(genpath('./helper_functions'));


%--------------------%
% plot marginals %
%--------------------%

colors_individual = [0.5 0.75 0.4; 0.5 0.5 0.75];
colors_avg        = [0.1 0.45 0; 0 0 0.75];

hf_s_a = figure; setupfig(2,2,8);
hf_t_a = figure; setupfig(2,2,8);

for f = 1 : length(folders)

    clear spatial_marg_all; clear temporal_marg_all; 

    color_individual = colors_individual(f,:);
    color_avg        = colors_avg(f,:);

    h_s = figure(hf_s_a); hold on;
    h_t = figure(hf_t_a); hold on;

    % get paths to all power spectra
    listing = dir(['./powerSpectra/' folders{f} '/*logbinned_powerSpectra.mat']);

    % grab all marginals
    for l = 1:numel(listing)
        load(['./powerSpectra/' folders{f} '/' listing(l).name]);

        spatial_marg_all(l,:) = spatial_marg;
        temporal_marg_all(l,:) = temporal_marg;

    end

    % plot avg. marginals
    figure(h_s);
    h_sp = shadedErrorBar(Xsf_centers, mean(log10(spatial_marg_all)), std(log10(spatial_marg_all)),'lineprops',{'-','Color',color_avg},'transparent',1);

    set(gca,'PlotBoxAspectRatio',[1 1 1],'xscale','log');
    xlabel('Spatial freq. (cpd)');
    ylabel('Mean power');
    set(gca,'xtick',round(logspace(log10(0.05),log10(0.75),4),2));

    box on;

    xlim([0.05 0.75]);
    ylim([2 9]);
    set(gca,'ytick', [3 6 9]);

    figure(h_t);
    h_tm = shadedErrorBar(Xtf_centers, mean(log10(temporal_marg_all)), std(log10(temporal_marg_all)),'lineprops',{'-','Color',color_avg},'transparent',1);

    set(gca,'PlotBoxAspectRatio',[1 1 1],'xscale','log');
    xlabel('Temporal freq. (cps)');
    ylabel('Mean power');
    set(gca,'xtick',round(logspace(log10(0.5),log10(40),4),2));
    set(gca,'ytick', [2 4 6]);
    box on;

    xlim([0.38 50]);
    ylim([1 6]);

end


hgexport(h_s,['./plots/marg_spatial_g_both_SHADED.eps']);
hgexport(h_t,['./plots/marg_temporal_g_both_SHADED.eps']);

