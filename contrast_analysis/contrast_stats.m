close all;

% load data
load('contrast_vals_g_brc');

% global contrast

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mean (not included in figure)
figure; hold on; setupfig(2,1.5,8);
air_h = histogram(air.meanLinC,linspace(-0.1,0.1,10),'facecolor',[0.1 0.45 0]);
water_h = histogram(water.meanLinC,linspace(-0.1,0.1,10),'facecolor',[0 0 0.7]);
ylim([0 40]);

scatter(mean(air.meanLinC),32,20,[0.1 0.45 0],'filled','markeredgecolor',[0.1 0.45 0],'linewidth',1.5);
plot([mean(air.meanLinC) - 1.96*std(air.meanLinC)/sqrt(numel((air.meanLinC))) ...
    mean(air.meanLinC) + 1.96*std(air.meanLinC)/sqrt(numel((air.meanLinC)))],[32 32],'color',[0.1 0.45 0],'linewidth',1.5);
scatter(mean(water.meanLinC),37,20,[0 0 0.7],'filled','markeredgecolor',[0 0 0.7],'linewidth',1.5);
plot([mean(water.meanLinC) - 1.96*std(water.meanLinC)/sqrt(numel((water.meanLinC))) ...
    mean(water.meanLinC) + 1.96*std(water.meanLinC)/sqrt(numel((water.meanLinC)))],[37 37],'color',[0 0 0.7],'linewidth',1.5);
xlabel('Mean'); ylabel('Count');

air_h.FaceAlpha = 1;
water_h.FaceAlpha = 1;
hax = gca;
hax.LineWidth = 0.75;
hax.FontSize = 8;

hgexport(gcf,['./plots/GlobalContrast_mean_g.eps']);

display(['contrast air mean = ' num2str(mean(air.meanLinC),2) ' ; std = ' num2str(std(air.meanLinC),2) ]);
display(['contrast water mean = ' num2str(mean(water.meanLinC),2) ' ; std = ' num2str(std(water.meanLinC),2) ]);

[h,p,ci,stats] = ttest2(air.meanLinC,water.meanLinC);

display(['air vs water: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);

% dprime
dp = abs((mean(air.meanLinC) - mean(water.meanLinC))/sqrt(0.5*(var(air.meanLinC)+var(water.meanLinC))));
display(['dp = ' num2str(dp,4) ]);

display(' ');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variance

air.varLinC = air.stdLinC.^2;
water.varLinC = water.stdLinC.^2;

figure; hold on; setupfig(2,1.5,8);
air_h = histogram(air.varLinC,linspace(0,1.5,10),'facecolor',[0.1 0.45 0]);
water_h = histogram(water.varLinC,linspace(0,1.5,10),'facecolor',[0 0 0.7]);
ylim([0 25]);
bar_height_a = 20; bar_height_w = 22;


scatter(mean(air.varLinC),bar_height_a,20,[0.1 0.45 0],'filled','markeredgecolor',[0.1 0.45 0],'linewidth',1.5);
plot([mean(air.varLinC) - 1.96*std(air.varLinC)/sqrt(numel((air.varLinC))) ...
    mean(air.varLinC) + 1.96*std(air.varLinC)/sqrt(numel((air.varLinC)))],[bar_height_a bar_height_a],'color',[0.1 0.45 0],'linewidth',1.5);
scatter(mean(water.varLinC),bar_height_w,20,[0 0 0.7],'filled','markeredgecolor',[0 0 0.7],'linewidth',1.5);
plot([mean(water.varLinC) - 1.96*std(water.varLinC)/sqrt(numel((water.varLinC))) ...
    mean(water.varLinC) + 1.96*std(water.varLinC)/sqrt(numel((water.varLinC)))],[bar_height_w bar_height_w],'color',[0 0 0.7],'linewidth',1.5);
set(gca,'linewidth',1.5,'ytick',[0 10 20],'xlim',[-0.08 1.5],'fontsize',8);

xlabel('Variance'); ylabel('Count');

air_h.FaceAlpha = 1;
water_h.FaceAlpha = 1;
hax = gca;
hax.LineWidth = 0.75;
hax.FontSize = 8;

hgexport(gcf,['./plots/GlobalContrast_var_g_brc.eps']);

display(['contrast air var = ' num2str(mean(air.varLinC),2) ' ; std = ' num2str(std(air.varLinC),2) ]);
display(['contrast water var = ' num2str(mean(water.varLinC),2) ' ; std = ' num2str(std(water.varLinC),2) ]);

[h,p,ci,stats] = ttest2(air.varLinC,water.varLinC);

display(['air vs water: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');

% dprime
dp = abs((mean(air.varLinC) - mean(water.varLinC))/sqrt(0.5*(var(air.varLinC)+var(water.varLinC))));
display(['dp = ' num2str(dp,4) ]);

display(' ');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% skew

figure; hold on; setupfig(2,1.5,8);
air_h = histogram(air.skewLinC,linspace(-1,4.75,10),'facecolor',[0.1 0.45 0]);
water_h = histogram(water.skewLinC,linspace(-1,4.75,10),'facecolor',[0 0 0.7]);
ylim([0 25]);
bar_height_a = 20; bar_height_w = 22;


scatter(mean(air.skewLinC),bar_height_a,20,[0.1 0.45 0],'filled','markeredgecolor',[0.1 0.45 0],'linewidth',1.5);
plot([mean(air.skewLinC) - 1.96*std(air.skewLinC)/sqrt(numel((air.skewLinC))) ...
    mean(air.skewLinC) + 1.96*std(air.skewLinC)/sqrt(numel((air.skewLinC)))],[bar_height_a bar_height_a],'color',[0.1 0.45 0],'linewidth',1.5);
scatter(mean(water.skewLinC),bar_height_w,20,[0 0 0.7],'filled','markeredgecolor',[0 0 0.7],'linewidth',1.5);
plot([mean(water.skewLinC) - 1.96*std(water.skewLinC)/sqrt(numel((water.skewLinC))) ...
    mean(water.skewLinC) + 1.96*std(water.skewLinC)/sqrt(numel((water.skewLinC)))],[bar_height_w bar_height_w],'color',[0 0 0.7],'linewidth',1.5);
set(gca,'linewidth',1.5,'ytick',[0 10 20 30],'xlim',[-1 5],'xtick',[-1 0 1 2 3 4]);

plot([0 0],[0 40],'k--','linewidth',1.5);
xlabel('Skewness'); ylabel('Count');

air_h.FaceAlpha = 1;
water_h.FaceAlpha = 1;
hax = gca;
hax.LineWidth = 0.75;
hax.FontSize = 8;

hgexport(gcf,['./plots/GlobalContrast_skew_g_brc.eps']);

display(['contrast air skew = ' num2str(mean(air.skewLinC),2) ' ; std = ' num2str(std(air.skewLinC),2) ]);
display(['contrast water skew = ' num2str(mean(water.skewLinC),2) ' ; std = ' num2str(std(water.skewLinC),2) ]);

[h,p,ci,stats] = ttest2(air.skewLinC,water.skewLinC);

display(['air vs water: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');

% dprime
dp = abs((mean(air.skewLinC) - mean(water.skewLinC))/sqrt(0.5*(var(air.skewLinC)+var(water.skewLinC))));
display(['dp = ' num2str(dp,4) ]);

display(' ');

% is skew greater than 0?
[h,p,ci,stats] = ttest(air.skewLinC);

display(['air vs 0: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);

[h,p,ci,stats] = ttest(water.skewLinC);

display(['water vs 0: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% proportion negative contrast
figure; hold on; setupfig(2,1.5,8);
air_h = histogram(air.propNegLinC,linspace(0.45,0.85,10),'facecolor',[0.1 0.45 0]);
water_h = histogram(water.propNegLinC,linspace(0.45,0.85,10),'facecolor',[0 0 0.75]);
ylim([0 25]);

scatter(mean(air.propNegLinC),20,20,[0.1 0.45 0],'filled','markeredgecolor',[0.1 0.45 0],'linewidth',1.5);
plot([mean(air.propNegLinC) - 1.96*std(air.propNegLinC)/sqrt(numel((air.propNegLinC))) ...
    mean(air.propNegLinC) + 1.96*std(air.propNegLinC)/sqrt(numel((air.propNegLinC)))],[20 20],'color',[0.1 0.45 0],'linewidth',1.5);
scatter(mean(water.propNegLinC),22,20,[0 0 0.7],'filled','markeredgecolor',[0 0 0.7],'linewidth',1.5);
plot([mean(water.propNegLinC) - 1.96*std(water.propNegLinC)/sqrt(numel((water.propNegLinC))) ...
    mean(water.propNegLinC) + 1.96*std(water.propNegLinC)/sqrt(numel((water.propNegLinC)))],[22 22],'color',[0 0 0.7],'linewidth',1.5);

set(gca,'ytick',[0 10 20],'xlim',[0.42 0.88],'xtick',[0.5 0.6 0.7 0.8]);

plot([0.5 0.5],[0 40],'k--','linewidth',1.5);
xlabel('Prop. negative contrast'); ylabel('Count');

air_h.FaceAlpha = 1;
water_h.FaceAlpha = 1;
hax = gca;
hax.LineWidth = 0.75;
hax.FontSize = 8;

hgexport(gcf,['./plots/PropNeg_g.eps']);

display(['contrast air prop negative = ' num2str(mean(air.propNegLinC),2) ' ; std = ' num2str(std(air.propNegLinC),2) ]);
display(['contrast water prop negative = ' num2str(mean(water.propNegLinC),2) ' ; std = ' num2str(std(water.propNegLinC),2) ]);

[h,p,ci,stats] = ttest2(air.propNegLinC,water.propNegLinC);

display(['air vs water: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');

% dprime
dp = abs((mean(air.propNegLinC) - mean(water.propNegLinC))/sqrt(0.5*(var(air.propNegLinC)+var(water.propNegLinC))));
display(['dp = ' num2str(dp,4) ]);

display(' ');

% is prop greater than 0.5?
[h,p,ci,stats] = ttest(air.propNegLinC-0.5);

display(['air vs 0.5: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);

[h,p,ci,stats] = ttest(water.propNegLinC-0.5);

display(['water vs 0.5: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% proportion negative contrast - LOCAL

figure; hold on; setupfig(2,1.5,8);
air_h = histogram(air.propLocalNegLinC,linspace(0.45,0.7,10),'facecolor',[0.1 0.45 0]);
water_h = histogram(water.propLocalNegLinC,linspace(0.45,0.7,10),'facecolor',[0 0 0.75]);
ylim([0 25]);

scatter(mean(air.propLocalNegLinC),20,20,[0.1 0.45 0],'filled','markeredgecolor',[0.1 0.45 0],'linewidth',1.5);
plot([mean(air.propLocalNegLinC) - 1.96*std(air.propLocalNegLinC)/sqrt(numel((air.propLocalNegLinC))) ...
    mean(air.propLocalNegLinC) + 1.96*std(air.propLocalNegLinC)/sqrt(numel((air.propLocalNegLinC)))],[20 20],'color',[0.1 0.45 0],'linewidth',1.5);
scatter(mean(water.propLocalNegLinC),22,20,[0 0 0.7],'filled','markeredgecolor',[0 0 0.7],'linewidth',1.5);
plot([mean(water.propLocalNegLinC) - 1.96*std(water.propLocalNegLinC)/sqrt(numel((water.propLocalNegLinC))) ...
    mean(water.propLocalNegLinC) + 1.96*std(water.propLocalNegLinC)/sqrt(numel((water.propLocalNegLinC)))],[22 22],'color',[0 0 0.7],'linewidth',1.5);

set(gca,'ytick',[0 10 20],'xlim',[0.4 0.7],'xtick',[0.4 0.5 0.6 0.7]);

plot([0.5 0.5],[0 40],'k--','linewidth',1.5);
xlabel('Prop. negative contrast LOCAL'); ylabel('Count');

air_h.FaceAlpha = 1;
water_h.FaceAlpha = 1;
hax = gca;
hax.LineWidth = 0.75;
hax.FontSize = 8;

hgexport(gcf,['./plots/PropLocalNeg_g.eps']);

display(['contrast air prop negative LOCAL = ' num2str(mean(air.propLocalNegLinC),2) ' ; std = ' num2str(std(air.propLocalNegLinC),2) ]);
display(['contrast water prop negative LOCAL = ' num2str(mean(water.propLocalNegLinC),2) ' ; std = ' num2str(std(water.propLocalNegLinC),2) ]);

[h,p,ci,stats] = ttest2(air.propLocalNegLinC,water.propLocalNegLinC);

display(['air vs water: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');

% dprime
dp = abs((mean(air.propLocalNegLinC) - mean(water.propLocalNegLinC))/sqrt(0.5*(var(air.propLocalNegLinC)+var(water.propLocalNegLinC))));
display(['dp = ' num2str(dp,4) ]);

display(' ');

% is prop greater than 0.5?
[h,p,ci,stats] = ttest(air.propLocalNegLinC-0.5);

display(['air vs 0.5: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);

[h,p,ci,stats] = ttest(water.propLocalNegLinC-0.5);

display(['water vs 0.5: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kurtosis

figure; hold on; setupfig(2,1.5,8);
air_h = histogram(air.kurtLinC,linspace(0,40,12),'facecolor',[0.1 0.45 0]);
water_h = histogram(water.kurtLinC,linspace(0,40,12),'facecolor',[0 0 0.7]);
ylim([0 25]);
bar_height_a = 20; bar_height_w = 22;

scatter(mean(air.kurtLinC),bar_height_a,20,[0.1 0.45 0],'filled','markeredgecolor',[0.1 0.45 0],'linewidth',1.5);
plot([mean(air.kurtLinC) - 1.96*std(air.kurtLinC)/sqrt(numel((air.kurtLinC))) ...
    mean(air.kurtLinC) + 1.96*std(air.kurtLinC)/sqrt(numel((air.kurtLinC)))],[bar_height_a bar_height_a],'color',[0.1 0.45 0],'linewidth',2);
scatter(mean(water.kurtLinC),bar_height_w,20,[0 0 0.7],'filled','markeredgecolor',[0 0 0.7],'linewidth',1.5);
plot([mean(water.kurtLinC) - 1.96*std(water.kurtLinC)/sqrt(numel((water.kurtLinC))) ...
    mean(water.kurtLinC) + 1.96*std(water.kurtLinC)/sqrt(numel((water.kurtLinC)))],[bar_height_w bar_height_w],'color',[0 0 0.7],'linewidth',2);
set(gca,'linewidth',1.5,'ytick',[0 10 20 30],'xlim',[-4 44],'xtick',[0 10 20 30 40]);

plot([3 3],[0 40],'k--','LineWidth',1.5)
xlabel('Kurtosis'); ylabel('Count');

air_h.FaceAlpha = 1;
water_h.FaceAlpha = 1;
hax = gca;
hax.LineWidth = 0.75;
hax.FontSize = 8;

hgexport(gcf,['./plots/GlobalContrast_kurt_g_brc.eps']);

display(['contrast air kurt = ' num2str(mean(air.kurtLinC),2) ' ; std = ' num2str(std(air.kurtLinC),2) ]);
display(['contrast water kurt = ' num2str(mean(water.kurtLinC),2) ' ; std = ' num2str(std(water.kurtLinC),2) ]);

[h,p,ci,stats] = ttest2(air.kurtLinC,water.kurtLinC);

display(['air vs water: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');

% dprime
dp = abs((mean(air.kurtLinC) - mean(water.kurtLinC))/sqrt(0.5*(var(air.kurtLinC)+var(water.kurtLinC))));
display(['dp = ' num2str(dp,4) ]);

display(' ');


% is kurt greater than 3?
[h,p,ci,stats] = ttest(air.kurtLinC - 3);

display(['air vs 3: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);

[h,p,ci,stats] = ttest(water.kurtLinC - 3);

display(['water vs 3: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input entropy
figure; hold on; setupfig(2,1.5,8);
air_h = histogram(air.entropyC,linspace(4.75,7.5,10),'facecolor',[0.1 0.45 0]);
water_h = histogram(water.entropyC,linspace(4.75,7.5,10),'facecolor',[0 0 0.7]);
ylim([0 25]);
bar_height_a = 20; bar_height_w = 22;

scatter(mean(air.entropyC),bar_height_a,20,[0.1 0.45 0],'filled','markeredgecolor',[0.1 0.45 0],'linewidth',1.5);
plot([mean(air.entropyC) - 1.96*std(air.entropyC)/sqrt(numel((air.entropyC))) ...
    mean(air.entropyC) + 1.96*std(air.entropyC)/sqrt(numel((air.entropyC)))],[bar_height_a bar_height_a],'color',[0.1 0.45 0],'linewidth',2);
scatter(mean(water.entropyC),bar_height_w,20,[0 0 0.7],'filled');
plot([mean(water.entropyC) - 1.96*std(water.entropyC)/sqrt(numel((water.entropyC))) ...
    mean(water.entropyC) + 1.96*std(water.entropyC)/sqrt(numel((water.entropyC)))],[bar_height_w bar_height_w],'color',[0 0 0.7],'linewidth',2);
set(gca,'linewidth',1.5,'ytick',[0 10 20 30],'xlim',[4.5 7.5]);

xlabel('Contrast entropy'); ylabel('Count');

air_h.FaceAlpha = 1;
water_h.FaceAlpha = 1;
hax = gca;
hax.LineWidth = 0.75;
hax.FontSize = 8;

hgexport(gcf,['./plots/GlobalContrast_inputentropy_g_brc.eps']);

display(['contrast air entropy = ' num2str(mean(air.entropyC),4) ' ; std = ' num2str(std(air.entropyC),4) ]);
display(['contrast water entropy = ' num2str(mean(water.entropyC),4) ' ; std = ' num2str(std(water.entropyC),4) ]);

[h,p,ci,stats] = ttest2(air.entropyC,water.entropyC);

display(['air vs water: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');

% dprime
dp = abs((mean(air.entropyC) - mean(water.entropyC))/sqrt(0.5*(var(air.entropyC)+var(water.entropyC))));
display(['dp = ' num2str(dp,4) ]);

display(' ');