close all;

% load data
load('contrast_vals_g_hemifields.mat');

% air upper vs. lower
figure; hold on; setupfig(5,5,8);
for x = 1:numel(air.meanLinC_u)
    
    % plot luminance histogram
    d1 = plot(xContLin, air.yContLin_u(x,:) / sum(air.yContLin_u(x,:)), 'Color',[0.85 0.75 0.4]);
    axis square;
    set(gca,'xtick',[-1 0 1 2 3 4],'ytick',[],'xlim',[-1.1 3.1],'ylim',[-0.01 0.45]); 
    
end

for x = 1:numel(air.meanLinC_l)
    
    % plot normalized luminance histogram
    d2 = plot(xContLin, air.yContLin_l(x,:) / sum(air.yContLin_l(x,:)), 'Color',[0.5 0.75 0.4]);
    axis square;
    set(gca,'xtick',[-1 0 1 2 3 4],'ytick',[],'xlim',[-1.1 3.1],'ylim',[-0.01 0.45]); 
    xlabel('Contrast'); ylabel('Probability density');
    
end
plot(xContLin, mean(air.yContLin_u ./ sum(air.yContLin_u,2)), 'Color', [0.5 0.45 0], 'LineWidth', 2);
plot(xContLin, mean(air.yContLin_l ./ sum(air.yContLin_l,2)), 'Color', [0.1 0.45 0], 'LineWidth', 2);

hax = gca; hax.LineWidth = 0.75;
hax.FontSize = 8; 

legend([d1 d2],{'Upper','Lower'});

hgexport(gcf,'./plots/hemifields_PDF_global_air_g_brc.eps');


% water upper vs. lower
figure; hold on; setupfig(5,5,8);
for x = 1:numel(water.meanLinC_u)
    
    % plot luminance histogram
    d1 = plot(xContLin, water.yContLin_u(x,:) / sum(water.yContLin_u(x,:)), 'Color',[0.85 0.4 0.75]);
    axis square;
    set(gca,'xtick',[-1 0 1 2 3 4],'ytick',[],'xlim',[-1.1 3.1],'ylim',[-0.01 0.45]); 
    
end

for x = 1:numel(water.meanLinC_l)
    
    % plot normalized luminance histogram
    d2 = plot(xContLin, water.yContLin_l(x,:) / sum(water.yContLin_l(x,:)), 'Color',[0.5 0.5 0.75]);
    axis square;
    set(gca,'xtick',[-1 0 1 2 3 4],'ytick',[],'xlim',[-1.1 3.1],'ylim',[-0.01 0.45]); 
    xlabel('Contrast'); ylabel('Probability density');
    
end
plot(xContLin, mean(water.yContLin_u ./ sum(water.yContLin_u,2)), 'Color', [0.5 0 0.45], 'LineWidth', 2);
plot(xContLin, mean(water.yContLin_l ./ sum(water.yContLin_l,2)), 'Color', [0 0 0.75], 'LineWidth', 2);

hax = gca; hax.LineWidth = 0.75;
hax.FontSize = 8; 

legend([d1 d2],{'Upper','Lower'});

hgexport(gcf,'./plots/hemifields_PDF_global_water_g_brc.eps');


%%%%%% SHADED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% air upper vs. lower
figure; hold on; setupfig(5,5,8);

h_upper = shadedErrorBar(xContLin, mean(air.yContLin_u ./ sum(air.yContLin_u,2)), std(air.yContLin_u ./ sum(air.yContLin_u,2)),'lineprops',{'-','Color',[0.5 0.45 0]},'transparent',1);
h_lower = shadedErrorBar(xContLin, mean(air.yContLin_l ./ sum(air.yContLin_l,2)), std(air.yContLin_l ./ sum(air.yContLin_l,2)),'lineprops',{'-','Color',[0.1 0.45 0]},'transparent',1);

h_upper.mainLine.Color = [0.5 0.45 0];
h_lower.mainLine.Color = [0.1 0.45 0];

h_upper.mainLine.LineWidth = 2;
h_lower.mainLine.LineWidth = 2;

h_upper.patch.FaceColor = [0.5 0.45 0];
h_lower.patch.FaceColor = [0.1 0.45 0];

h_upper.patch.LineStyle = 'none';
h_lower.patch.LineStyle = 'none';

set(h_lower.edge,'LineStyle','none')
set(h_upper.edge,'LineStyle','none')

axis square;
set(gca,'xtick',[-1 0 1 2 3 4],'ytick',[],'xlim',[-1.1 3.1],'ylim',[-0.01 0.3]); 
    
hax = gca; hax.LineWidth = 0.75;
hax.FontSize = 8; 

legend([d1 d2],{'Upper','Lower'});

hgexport(gcf,'./plots/hemifields_PDF_global_air_g_brc_SHADED.eps');


% water upper vs. lower
figure; hold on; setupfig(5,5,8);

h_upper = shadedErrorBar(xContLin, mean(water.yContLin_u ./ sum(water.yContLin_u,2)), std(water.yContLin_u ./ sum(water.yContLin_u,2)),'lineprops',{'-','Color',[0.5 0 0.45]},'transparent',1);
h_lower = shadedErrorBar(xContLin, mean(water.yContLin_l ./ sum(water.yContLin_l,2)), std(water.yContLin_l ./ sum(water.yContLin_l,2)),'lineprops',{'-','Color',[0 0 0.75]},'transparent',1);

h_upper.mainLine.Color = [0.5 0 0.45];
h_lower.mainLine.Color = [0 0 0.75];

h_upper.mainLine.LineWidth = 2;
h_lower.mainLine.LineWidth = 2;

h_upper.patch.FaceColor = [0.5 0 0.45];
h_lower.patch.FaceColor = [0 0 0.75];

h_upper.patch.LineStyle = 'none';
h_lower.patch.LineStyle = 'none';

set(h_lower.edge,'LineStyle','none')
set(h_upper.edge,'LineStyle','none')

axis square;
set(gca,'xtick',[-1 0 1 2 3 4],'ytick',[],'xlim',[-1.1 3.1],'ylim',[-0.01 0.3]); 
    
hax = gca; hax.LineWidth = 0.75;
hax.FontSize = 8; 

legend([d1 d2],{'Upper','Lower'});

hgexport(gcf,'./plots/hemifields_PDF_global_water_g_brc_SHADED.eps');
