close all;
addpath(genpath('./shadedErrorBar-master/'));

% load data
load('./contrast_vals_g_brc.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% water & air PDF global contrast
figure; hold on; setupfig(3.5,3.5,8);
for x = 1:numel(water.meanLinC)
    
    % plot luminance histogram
    plot(xContLin, water.yContLin(x,:) / sum(water.yContLin(x,:)), 'Color',[0.5 0.5 0.75]);
    
end

for x = 1:numel(air.meanLinC)
    
    % plot normalized luminance histogram
    plot(xContLin, air.yContLin(x,:) / sum(air.yContLin(x,:)), 'Color',[0.5 0.75 0.4]);
    axis square;
    set(gca,'xtick',[-1 0 1 2 3 4],'ytick',[],'xlim',[-1.1 3.1],'ylim',[-0.01 0.45]); % Emily's talk
    %set(gca,'xtick',[0 1 2],'ytick',0:0.1:0.3,'xlim',[0 2.07],'ylim',[-0.01 0.3]); % vss poster
    xlabel('Contrast'); ylabel('Probability density');
    
end
h_air = plot(xContLin, mean(air.yContLin ./ sum(air.yContLin,2)), 'Color', [0.1 0.45 0], 'LineWidth', 2);
h_water = plot(xContLin, mean(water.yContLin ./ sum(water.yContLin,2)), 'Color', [0 0 0.75], 'LineWidth', 2);

hax = gca; hax.LineWidth = 0.75;
hax.FontSize = 8; % vss poster
hlg = legend([h_air h_water],{'Terrestrial','Aquatic'});hlg.Box = 'off';

hgexport(gcf,['./plots/PDF_global_g_brc.eps']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% water & air PDF global contrast SHADED
addpath('../shadedErrorBar-master')
figure; hold on; setupfig(3.5,3.5,8);

h_air = shadedErrorBar(xContLin, mean(air.yContLin ./ sum(air.yContLin,2)), std(air.yContLin ./ sum(air.yContLin,2)),'lineprops',{'-','Color',[0.1,0.45,0]},'transparent',1);
h_water = shadedErrorBar(xContLin, mean(water.yContLin ./ sum(water.yContLin,2)), std(water.yContLin ./ sum(water.yContLin,2)),'lineprops',{'-','Color',[0,0,0.75]},'transparent',1);

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

%hax = gca; hax.LineWidth = 0.75;
hax.FontSize = 8; % vss poster
%hlg = legend([h_air h_water],{'Terrestrial','Aquatic'});hlg.Box = 'off';

set(gca,'xtick',[-1 0 1 2 3 4],'ytick',[],'xlim',[-1.1 3.5],'ylim',[-0.001 0.2]);

saveas(gcf,['./plots/PDF_global_g_brc_SHADED.png']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% water & air PDF local contrast

figure; hold on; setupfig(3.5,3.5,8);
for x = 1:numel(water.meanLinC)
    
    % plot luminance histogram
    plot(xLocalContLin, water.yLocalContLin(x,:) / sum(water.yLocalContLin(x,:)), 'Color',[0.5 0.5 0.75]);
    axis square;

end

for x = 1:numel(air.meanLinC)
    
    % plot normalized luminance histogram
    plot(xLocalContLin, air.yLocalContLin(x,:) / sum(air.yLocalContLin(x,:)), 'Color',[0.5 0.75 0.4]);
    axis square;
    set(gca,'xtick',[-1 0 1 2 3 4],'ytick',[],'xlim',[-0.5 0.5],'ylim',[-0.01 1]); % Emily's talk
    xlabel('Contrast'); ylabel('Probability density');
    
end
h_air = plot(xLocalContLin, mean(air.yLocalContLin ./ sum(air.yLocalContLin,2)), 'Color', [0.1 0.45 0], 'LineWidth', 2);
h_water = plot(xLocalContLin, mean(water.yLocalContLin ./ sum(water.yLocalContLin,2)), 'Color', [0 0 0.75], 'LineWidth', 2);


hax = gca; hax.LineWidth = 0.75;
hax.FontSize = 8; % vss poster
hlg = legend([h_air h_water],{'Terrestrial','Aquatic'});hlg.Box = 'off';

hgexport(gcf,['./plots/PDF_local_g_brc.eps']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% water & air PDF local contrast SHADED

figure; hold on; setupfig(3.5,3.5,8);

h_air = shadedErrorBar(xLocalContLin, mean(air.yLocalContLin ./ sum(air.yLocalContLin,2)), std(air.yLocalContLin ./ sum(air.yLocalContLin,2)),'lineprops',{'-','Color',[0.1,0.45,0]},'transparent',1);
h_water = shadedErrorBar(xLocalContLin, mean(water.yLocalContLin ./ sum(water.yLocalContLin,2)), std(water.yLocalContLin ./ sum(water.yLocalContLin,2)),'lineprops',{'-','Color',[0,0,0.75]},'transparent',1);

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

axis square;
set(gca,'xtick',[-0.5 -0.25 0 0.25 0.5],'ytick',[],'xlim',[-0.25 0.25],'ylim',[-0.001 0.6]); % Emily's talk
xlabel('Contrast'); ylabel('Probability density');


hax = gca; hax.LineWidth = 0.75;
hax.FontSize = 8; % vss poster

hgexport(gcf,['./plots/PDF_local_g_brc_SHADED.eps']);
