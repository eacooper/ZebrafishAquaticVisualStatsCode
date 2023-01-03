close all;

% load data
load('contrast_vals_g_hemifields.mat');

% momenta to analyze
momenta = {'Mean','Var','Skew','Kurt','PropDark','PropDarkLocal'};

for m = 1:length(momenta)
    
    % set up groups for ANOVAs
    tmp1 = []; tmp2 = []; tmp3 = []; tmp4 = []; tmp5 = []; tmp6 = [];
    [tmp1{1:2*numel(water.meanLinC_u)}] = deal('water');
    [tmp2{1:2*numel(air.meanLinC_u)}] = deal('air');
    g1       = [tmp1 tmp2];
    [tmp3{1:numel(water.meanLinC_u)}] = deal('up');
    [tmp4{1:numel(water.meanLinC_l)}] = deal('down');
    [tmp5{1:numel(air.meanLinC_u)}] = deal('up');
    [tmp6{1:numel(air.meanLinC_l)}] = deal('down');
    g2       = [tmp3 tmp4 tmp5 tmp6];
    
    display(['----------------------' momenta{m} '----------------------']);
    switch momenta{m}
        
        case 'Mean'
            
            air_u = air.meanLinC_u;
            air_l = air.meanLinC_l;
            
            water_u = water.meanLinC_u;
            water_l = water.meanLinC_l;
            
            histlims = [-1.1 1.1];
            linelims = [-0.8 0.8];
            
        case 'Var'
            
            air_u = air.stdLinC_u.^2;
            air_l = air.stdLinC_l.^2;
            
            water_u = water.stdLinC_u.^2;
            water_l = water.stdLinC_l.^2;
            
            histlims = [0 2];
            linelims = [0 2.5];
            
        case 'Skew'
            
            air_u = air.skewLinC_u;
            air_l = air.skewLinC_l;
            
            water_u = water.skewLinC_u;
            water_l = water.skewLinC_l;
            
            histlims = [0 5];
            linelims = [0 6];
            
        case 'Kurt'
            
            air_u = air.kurtLinC_u;
            air_l = air.kurtLinC_l;
            
            water_u = water.kurtLinC_u;
            water_l = water.kurtLinC_l;
            
            histlims = [0 30];
            linelims = [0 47];
            
        case 'PropDark'
            
            air_u = air.propNegLinC_u;
            air_l = air.propNegLinC_l;
            
            water_u = water.propNegLinC_u;
            water_l = water.propNegLinC_l;
            
            histlims = [0 1];
            linelims = [-0.1 1.1];
            
        case 'PropDarkLocal'
            
            air_u = air.propLocalNegLinC_u;
            air_l = air.propLocalNegLinC_l;
            
            water_u = water.propLocalNegLinC_u;
            water_l = water.propLocalNegLinC_l;
            
            histlims = [0 1];
            linelims = [-0.1 1.1];
            
    end
    

    % LINE PLOTs

    figure; hold on; setupfig(1.75,1.3,9);
    
    % individual samples
    scatter(repmat(1,size(water_l)),water_l,1,[0 0 0.75],'jitter','on', 'jitterAmount',0.1);
    scatter(repmat(2,size(water_u)),water_u,1,[0.4 0.17 0.57],'jitter','on', 'jitterAmount',0.1);
    
    scatter(repmat(1,size(air_l)),air_l,1,[0.1 0.45 0],'jitter','on', 'jitterAmount',0.1);
    scatter(repmat(2,size(air_u)),air_u,1,[0.5 0.45 0.18],'jitter','on', 'jitterAmount',0.1);
    
   % means
    plot([1 2],[mean(air_l) mean(air_u)],'-','color',[0.1 0.45 0],'markerfacecolor',[0.1 0.45 0],'linewidth',1)
    plot([1 2],[mean(water_l) mean(water_u)],'-','color',[0 0 0.75],'markerfacecolor',[0 0 0.75],'linewidth',1)
    
    plot([1 2],[mean(air_l) mean(air_u)],'--','color',[0.5 0.45 0.18],'markerfacecolor',[0.1 0.45 0],'linewidth',1)
    plot([1 2],[mean(water_l) mean(water_u)],'--','color',[0.4 0.17 0.57],'markerfacecolor',[0 0 0.75],'linewidth',1)
    
    plot(1,[mean(air_l)],'o','color',[0.1 0.45 0],'markerfacecolor',[0.1 0.45 0],'linewidth',1.5,'markersize',2.5)
    plot(1,[mean(water_l)],'o','color',[0 0 0.75],'markerfacecolor',[0 0 0.75],'linewidth',1.5,'markersize',2.5)
    
    plot(2,[mean(air_u)],'o','color',[0.5 0.45 0.18],'markerfacecolor',[0.5 0.45 0.18],'linewidth',1.5,'markersize',2.5)
    plot(2,[mean(water_u)],'o','color',[0.4 0.17 0.57],'markerfacecolor',[0 0 0.75],'linewidth',1.5,'markersize',2.5)
    
    display(['max: ' num2str(max([water_l water_u air_l air_u]))]);
    display(['min: ' num2str(min([water_l water_u air_l air_u]))]);
    
    % error bars
    plot([1 1],[mean(air_l) - 1.96*std(air_l)/sqrt(numel((air_l))) ...
        mean(air_l) + 1.96*std(air_l)/sqrt(numel((air_l)))],'color',[0.1 0.45 0],'linewidth',1);
    plot([2 2],[mean(air_u) - 1.96*std(air_u)/sqrt(numel((air_u))) ...
        mean(air_u) + 1.96*std(air_u)/sqrt(numel((air_u)))],'color',[0.5 0.45 0.18],'linewidth',1);
    
    plot([1 1],[mean(water_l) - 1.96*std(water_l)/sqrt(numel((water_l))) ...
        mean(water_l) + 1.96*std(water_l)/sqrt(numel((water_l)))],'color',[0 0 0.75],'linewidth',1);
    plot([2 2],[mean(water_u) - 1.96*std(water_u)/sqrt(numel((water_u))) ...
        mean(water_u) + 1.96*std(water_u)/sqrt(numel((water_u)))],'color',[0.4 0.17 0.57],'linewidth',1);
    
    xlim([0.5 2.5])
    set(gca,'xtick',[1 2],'xticklabel',{'lower','upper'});
    
        if ~strcmp(momenta{m},'Kurt')
    ytickformat('%.1f')
        end
    
    if strcmp(momenta{m},'Mean')
        plot([0.5 2.5],[0 0],'k:');
        set(gca,'ytick',[-0.5 0 0.5],'yticklabel',{'0.5','0.0','0.5'});
    end
    ylim(linelims)
    ylabel([momenta(m)]);
    
    set(findall(gcf,'-property','FontSize'),'FontSize',7)
    
    hgexport(gcf,['./plots/hemifields_contrast_' momenta{m} '_g_brc.eps']);

    
    % ANOVA
    aov                     = [ water_u water_l air_u air_l];
    [p,tbl,stats]           = anovan(aov,{g1 g2},'model','interaction','varnames',{'waterair','updown'});

    display(tbl);
    
    % effect sizes (partial eta square; SSeffect / (SSeffect + SSerror)
    pe2_waterair = tbl{2,2}/(tbl{2,2} + tbl{5,2});
    pe2_updown = tbl{3,2}/(tbl{3,2} + tbl{5,2});
    pe2_interaction = tbl{4,2}/(tbl{4,2} + tbl{5,2});
    
    display(['partial eta^2 waterair: ' num2str(pe2_waterair) ]);
    display(['partial eta^2 updown: ' num2str(pe2_updown) ]);
    display(['partial eta^2 interaction: ' num2str(pe2_interaction) ]);
    display(' ');
    
    % upper/lower main effect
    display([momenta{m} '- contrast upper mean = ' num2str(mean([air_u water_u]),2) ' ; std = ' num2str(std([air_u water_u]),2) ]);
    display([momenta{m} '- contrast lower mean = ' num2str(mean([air_l water_l]),2) ' ; std = ' num2str(std([air_l water_l]),2) ]);
    
    % habitat main effect
    display([momenta{m} '- contrast terrestrial mean = ' num2str(mean([air_u air_l]),2) ' ; std = ' num2str(std([air_u air_l]),2) ]);
    display([momenta{m} '- contrast aquatic mean = ' num2str(mean([water_u water_l]),2) ' ; std = ' num2str(std([water_u water_l]),2) ]);
    
    display(' ');
    set(gcf,'Name',momenta{m})
    
    % follow up tests
    [c,m,h,gnames] = multcompare(stats,'Dimension',[1 2]);
    
    [gnames num2cell(m)]
    
    display('G1 G2 -- delta_mean -- P');
    
    c
    
    display(' ');
    
end


