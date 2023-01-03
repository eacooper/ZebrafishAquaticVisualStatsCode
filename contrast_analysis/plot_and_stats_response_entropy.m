close all;
addpath(genpath('./shadedErrorBar-master'));

% load data to get histogram parameters
load('contrast_vals_g_brc');
load('entropy_vals_g_brc.mat');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot air and water CDFs
figure; hold on; setupfig(5,5,18);
for x = 1:numel(water.meanLinC)
    
    % plot normalized luminance histogram
    plot(xContLin, cumsum(water.yContLin(x,:)) / sum(water.yContLin(x,:)), 'Color', [0.5 0.5 0.75]);
    
end

for x = 1:numel(air.meanLinC)
    
    % plot normalized luminance histogram
    plot(xContLin, cumsum(air.yContLin(x,:)) / sum(air.yContLin(x,:)), 'Color', [0.5 0.75 0.4]);
    
end

plot(xContLin, mean(cumsum(air.yContLin,2) ./ sum(air.yContLin,2)), 'Color', [0.1 0.45 0], 'LineWidth', 4);
plot(xContLin, mean(cumsum(water.yContLin,2) ./ sum(water.yContLin,2)), 'Color', [0 0 0.75], 'LineWidth', 4);

plot([0 0],[0 1],'k:');
axis([-1 3 0 1]); axis square;
set(gca,'xtick',[-1 0 1 2 3],'ytick',[],'linewidth',1.5);
xlabel('Contrast'); ylabel('Cumulative density');

hgexport(gcf,'./plots/CDFs_g_brc.eps');

% shaded

figure; hold on; setupfig(2,2,8);

h_air = shadedErrorBar(xContLin, mean(cumsum(air.yContLin,2) ./ sum(air.yContLin,2)), std(cumsum(air.yContLin,2) ./ sum(air.yContLin,2)),'lineprops',{'-','Color',[0.1,0.45,0]},'transparent',1);
h_water = shadedErrorBar(xContLin, mean(cumsum(water.yContLin,2) ./ sum(water.yContLin,2)), std(cumsum(water.yContLin,2) ./ sum(water.yContLin,2)),'lineprops',{'-','Color',[0,0,0.75]},'transparent',1);

h_air.mainLine.Color = [0.1,0.45,0];
h_water.mainLine.Color = [0,0,0.75];

h_water.mainLine.LineWidth = 2;
h_air.mainLine.LineWidth = 2;

h_water.patch.FaceColor = [0,0,0.75];
h_air.patch.FaceColor = [0.1,0.45,0];

h_water.patch.LineStyle = 'none';
h_air.patch.LineStyle = 'none';

set(h_air.edge,'LineStyle','none')
set(h_water.edge,'LineStyle','none')

set(gca,'xtick',[-1 0 1 2 3 4],'ytick',[],'xlim',[-1.1 3.1]);

xlabel('Global contrast'); ylabel('Cumulative density');

hgexport(gcf,'./plots/CDFs_g_brc_SHADED.eps');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot probability of responses to air videos with optimal and non-optimal
% transfer functions

figure; hold on; setupfig(5,5,18);
for x = 1:numel(air.meanLinC)
    
    % plot normalized histogram
    plot(xContLin, aire.yContLinWater(x,:) / sum(aire.yContLinWater(x,:)), 'Color', [0.5 0.5 0.5]);
    plot(xContLin, aire.yContLin(x,:) / sum(aire.yContLin(x,:)), 'Color', [0.5 0.75 0.4]);

    xlabel('Input intensity'); ylabel('Response probability');
    
end
plot(xContLin, mean(aire.yContLinWater ./ sum(aire.yContLinWater,2)), 'Color', [0.25 0.25 0.25], 'LineWidth', 4);
plot(xContLin, mean(aire.yContLin ./ sum(aire.yContLin,2)), 'Color', [0.1 0.45 0], 'LineWidth', 4);

hgexport(gcf,['./plots/WhitenedResponseProbabilities_air_g_brc.eps']);


figure; hold on; setupfig(5,5,18);
for x = 1:numel(water.meanLinC)
    
    % plot normalized histogram
    plot(xContLin, watere.yContLinAir(x,:) / sum(watere.yContLinAir(x,:)), 'Color', [0.5 0.5 0.5]);
    plot(xContLin, watere.yContLin(x,:) / sum(watere.yContLin(x,:)), 'Color', [0.5 0.5 0.75]);
    
    xlabel('Input intensity'); ylabel('Response probability');
    
end
plot(xContLin, mean(watere.yContLinAir ./ sum(watere.yContLinAir,2)), 'Color', [0.25 0.25 0.25], 'LineWidth', 4);
plot(xContLin, mean(watere.yContLin ./ sum(watere.yContLin,2)), 'Color', [0 0 0.75], 'LineWidth', 4);

hgexport(gcf,['./plots/WhitenedResponseProbabilities_water_g_brc.eps']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% output entropy - air

figure; hold on; setupfig(2,1.5,8);
air_h = histogram(aire.entropy,linspace(4.75,8,10),'facecolor',[0.1 0.45 0]);
water_h = histogram(aire.entropy_water,linspace(4.75,8,10),'facecolor',[0.5 0.5 0.5]);

scatter(mean(aire.entropy),32,20,[0.1 0.45 0],'filled');
plot([mean(aire.entropy) - 1.96*std(aire.entropy)/sqrt(numel((aire.entropy))) ...
    mean(aire.entropy) + 1.96*std(aire.entropy)/sqrt(numel((aire.entropy)))],[32 32],'color',[0.1 0.45 0]);
scatter(mean(aire.entropy_water),37,20,[0.5 0.5 0.5],'filled');
plot([mean(aire.entropy_water) - 1.96*std(aire.entropy_water)/sqrt(numel((aire.entropy_water))) ...
    mean(aire.entropy_water) + 1.96*std(aire.entropy_water)/sqrt(numel((aire.entropy_water)))],[37 37],'color',[0.5 0.5 0.5]);

xlabel('Neural entropy'); ylabel('Count');

air_h.FaceAlpha = 1;
water_h.FaceAlpha = 1;
hax = gca;
hax.LineWidth = 0.75;
hax.FontSize = 8; 

hgexport(gcf,['./plots/Neuralentropy_air_g_brc.eps']);

display(['air air entropy = ' num2str(mean(aire.entropy),2) ' ; std = ' num2str(std(aire.entropy),2) ]);
display(['air water entropy = ' num2str(mean(aire.entropy_water),2) ' ; std = ' num2str(std(aire.entropy_water),2) ]);

[h,p,ci,stats] = ttest2(aire.entropy,aire.entropy_water);

display(['air vs air water: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% output entropy - water

figure; hold on; setupfig(2,1.5,8);
air_h = histogram(watere.entropy,linspace(4.75,8,10),'facecolor',[0 0 0.7]);
water_h = histogram(watere.entropy_air,linspace(4.75,8,10),'facecolor',[0.5 0.5 0.5]);

scatter(mean(watere.entropy),32,20,[0 0 0.75],'filled');
plot([mean(watere.entropy) - 1.96*std(watere.entropy)/sqrt(numel((watere.entropy))) ...
    mean(watere.entropy) + 1.96*std(watere.entropy)/sqrt(numel((watere.entropy)))],[32 32],'color',[0.7 0 0]);
scatter(mean(watere.entropy_air),37,20,[0.5 0.5 0.5],'filled');
plot([mean(watere.entropy_air) - 1.96*std(watere.entropy_air)/sqrt(numel((watere.entropy_air))) ...
    mean(watere.entropy_air) + 1.96*std(watere.entropy_air)/sqrt(numel((watere.entropy_air)))],[37 37],'color',[0.5 0.5 0.5]);

xlabel('Neural entropy'); ylabel('Count');

air_h.FaceAlpha = 1;
water_h.FaceAlpha = 1;
hax = gca;
hax.LineWidth = 0.75;
hax.FontSize = 8; 

hgexport(gcf,['./plots/Neuralentropy_water_g_brc.eps']);

display(['water water entropy = ' num2str(mean(watere.entropy),2) ' ; std = ' num2str(std(watere.entropy),2) ]);
display(['water air entropy = ' num2str(mean(watere.entropy_air),2) ' ; std = ' num2str(std(watere.entropy_air),2) ]);

[h,p,ci,stats] = ttest2(watere.entropy,watere.entropy_air);

display(['water vs water air: p = ' num2str(p,4) ' ; tstat = ' num2str(stats.tstat,4) ' ; df = ' num2str(stats.df,4) ]);
display(' ');

% dprime
dp = abs((mean(watere.entropy_air) - mean(watere.entropy))/sqrt(0.5*(var(watere.entropy_air)+var(watere.entropy))));
display(['dp = ' num2str(dp,4) ]);

display(' ');