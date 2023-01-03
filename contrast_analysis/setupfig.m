function [] = setupfig(wid,ht,ft)

set(gcf ,'windowStyle','normal');
set(gcf,'color','w');
set(gcf, 'Units', 'inches');
set(gcf, 'Position', [1 1 wid ht]);

set(0,'DefaultAxesFontSize', ft)
set(0,'DefaultTextFontSize', ft)

grid off; box on;