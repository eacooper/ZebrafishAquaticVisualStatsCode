close all;

% Fit slope and intercept of marginals
fit_flag = 0;
if fit_flag, fit_linear_marginals(); end

% load slopes and intercepts of marginal fits
air   = load('./powerSpectra/fitLin_marg_air_g_brc.mat');
water = load('./powerSpectra/fitLin_marg_water_g_brc.mat');

% get CIs for slopes
pd_as = fitdist(air.slope_spatial','Normal'); ci_as = pd_as.paramci; ci_as_bar = abs(ci_as(1)-ci_as(2))/2;
pd_at = fitdist(air.slope_temporal','Normal'); ci_at = pd_at.paramci; ci_at_bar = abs(ci_at(1)-ci_at(2))/2;
pd_ws = fitdist(water.slope_spatial','Normal'); ci_ws = pd_ws.paramci; ci_ws_bar = abs(ci_ws(1)-ci_ws(2))/2;
pd_wt = fitdist(water.slope_temporal','Normal'); ci_wt = pd_wt.paramci; ci_wt_bar = abs(ci_wt(1)-ci_wt(2))/2;

% Compute slope and intercept stats

% spatial
display(['avg. air spatial slope = ' num2str(mean(air.slope_spatial),4) ' ; std = ' num2str(std(air.slope_spatial),4) ]);
display(['avg. water spatial slope = ' num2str(mean(water.slope_spatial),4) ' ; std = ' num2str(std(water.slope_spatial),4) ]);

[h,p_slope_s,ci,stats] = ttest2(air.slope_spatial,water.slope_spatial);

display(['air vs water spatial slope: p = ' num2str(p_slope_s,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');

% dprime
dp = abs((mean(air.slope_spatial) - mean(water.slope_spatial))/sqrt(0.5*(var(air.slope_spatial)+var(water.slope_spatial))));
display(['dp = ' num2str(dp,4) ]);

display(' ');


% temporal
display(['avg. air temporal slope = ' num2str(mean(air.slope_temporal),4) ' ; std = ' num2str(std(air.slope_temporal),4) ]);
display(['avg. water temporal slope = ' num2str(mean(water.slope_temporal),4) ' ; std = ' num2str(std(water.slope_temporal),4) ]);

[h,p_slope_t,ci,stats] = ttest2(air.slope_temporal,water.slope_temporal);

display(['air vs water: p = ' num2str(p_slope_t,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');


% dprime
dp = abs((mean(air.slope_temporal) - mean(water.slope_temporal))/sqrt(0.5*(var(air.slope_temporal)+var(water.slope_temporal))));
display(['dp = ' num2str(dp,4) ]);

display(' ');


% Plot spatial spectra slope comparison b/w air and water

hf_s = figure; hold on; setupfig(2,2,8); 

hData1 = histogram(air.slope_spatial, linspace(-4.5,0.5,10), 'FaceColor', [0.15 0.45 0]);
hData2 = histogram(water.slope_spatial, linspace(-4.5,0.5,10), 'FaceColor', [0 0 0.75]);
hData1bar = errorbar(mean(air.slope_spatial), 28, ci_as_bar, 'horizontal','Marker','.','Color',[0.15 0.45 0]);
hData2bar = errorbar(mean(water.slope_spatial), 29, ci_ws_bar, 'horizontal','Marker','.','Color',[0 0 0.75]);

hax = gca; hax.Box = 'on'; hax.PlotBoxAspectRatio = [1 1 1]; 
hax.XLim = [-4.5 0.5]; hax.YLim = [0 30]; hax.XTick = [-4 -3 -2 -1 0]; hax.YTick = [0 8 16 24]; 
hax.YLabel.String = 'Frequency';
hax.XLabel.String = 'Slope';
hax.Units='pixels'; hax.LineWidth = 0.75; hax.FontSize=8;


hData1bar.LineWidth = 1.5; hData1bar.MarkerSize = 12; hData1bar.CapSize = 0;
hData2bar.LineWidth = 1.5; hData2bar.MarkerSize = 12; hData2bar.CapSize = 0;
hData1.FaceAlpha = 1;hData2.FaceAlpha = 1;

hgexport(hf_s,['./plots/stats_slope_spatial_g_brc.eps']); 

% Temporal spectra slope comparison b/w air and water

hf_t = figure; hold on; setupfig(2,2,8); 

hData1 = histogram(air.slope_temporal, linspace(-4.5,0.5,10), 'FaceColor', [0.15 0.45 0]);
hData2 = histogram(water.slope_temporal, linspace(-4.5,0.5,10), 'FaceColor', [0 0 0.75]);
hData1bar = errorbar(mean(air.slope_temporal), 28, ci_at_bar, 'horizontal','Marker','.','Color',[0.15 0.45 0]);
hData2bar = errorbar(mean(water.slope_temporal), 29, ci_wt_bar, 'horizontal','Marker','.','Color',[0 0 0.75]);

hax = gca; hax.PlotBoxAspectRatio = [1 1 1]; hax.Box = 'on'; 
hax.XLim = [-4.5 0.5]; hax.YLim = [0 30]; hax.XTick = [-4 -3 -2 -1 0]; hax.YTick = [0 8 16 24]; 
hax.YLabel.String = 'Frequency';
hax.XLabel.String = 'Slope';
hax.Units='pixels'; hax.LineWidth = 0.75; hax.FontSize=8;

hData1bar.LineWidth = 1.5;hData1bar.MarkerSize = 12;hData1bar.CapSize = 0;
hData2bar.LineWidth = 1.5;hData2bar.MarkerSize = 12;hData2bar.CapSize = 0;
hData1.FaceAlpha = 1;hData2.FaceAlpha = 1;
hgexport(hf_t,['./plots/stats_slope_temporal_g_brc.eps']); 
