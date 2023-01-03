close all;

% initiate matrices to store mean bin power for each sample
powerbinsAir = [];
powerbinsWater = [];

probbinsAir = [];
probbinsWater = [];

% for each folder
for f = 1:length(folders)
    
    % get listing of files
    listing = dir(['./powerSpectra/' folders{f} '/*_powerSpectra.mat']);
    
    % for each file
    for l = 1:numel(listing)
        
        % load it
        % row = tf, col = sf
        load(['./powerSpectra/' folders{f} '/' listing(l).name]);
        
        % save to the appropriate matrix
        if strfind(folders{f},'air')
            powerbinsAir = cat(3,powerbinsAir,power_bins);
            probbinsAir = cat(3,probbinsAir,power_bins./sum(power_bins(:)));
        else
            powerbinsWater = cat(3,powerbinsWater,power_bins);
            probbinsWater = cat(3,probbinsWater,power_bins./sum(power_bins(:)));
        end
        
    end
end

% take the median for each habitat
pbAirMedian = median(powerbinsAir,3);
pbWaterMedian = median(powerbinsWater,3);

% difference of medians
powerbinsDiff = log10(pbAirMedian) - log10(pbWaterMedian);


% plots

% just plot speed in each bin
figure; hold on; setupfig(5,5,18);
[SF_centers_grid,TF_centers_grid] = meshgrid(Xsf_centers,Xtf_centers);
speed = TF_centers_grid./SF_centers_grid;
imagesc([Xtf_centers(1) Xtf_centers(end)],[Xsf_centers(1) Xsf_centers(end)], log10(speed'));
xlabel('Temporal (hz)'); ylabel('Spatial (cpd)');
set(gca,'ydir','normal');
box on; axis square tight;
hc = colorbar; hc.Label.String = 'log 10 speed';
ha = gca; ha.LineWidth = 2;
hgexport(gcf,['./plots/speed_g_air_brc.eps']);

% Contour plot of the speed in each bin. This will overlay with the
% green-blue map in Illustrator.
hf = figure; hold on; setupfig(5,5,18);
contour(TF_centers_grid, SF_centers_grid, speed,'showtext','on');
hax = gca; hax.XScale = 'log'; hax.YScale = 'log'; hax.PlotBoxAspectRatio = [1 1 1];
set(gca,'xtick',[0.5 2 10 44],'xticklabel',[0.5 2 10 44]);
set(gca,'ylim',[0.058 0.7],'ytick',[0.06 0.13 0.3 0.7],'yticklabel',[0.06 0.13 0.3 0.7],'ydir','normal');
hCt = hax.Children; % hCt is the contour properties object
hCt.LevelList = logspace(log10(2),log10(250),5);hCt.LineWidth = 0.75;
hC = colorbar; colormap hot;hC.Limits = [0.01 500];hax.ColorScale = 'log';
hgexport(gcf,'./plots/speed_contour.eps');


% air
figure; hold on; setupfig(5,5,18);
imagesc([Xtf_centers(1) Xtf_centers(end)],[Xsf_centers(1) Xsf_centers(end)], log10(pbAirMedian),[1.5 6]);
xlabel('Temporal (hz)'); ylabel('Spatial (cpd)');
set(gca,'ydir','normal');
box on; axis square tight;
hc = colorbar; hc.Label.String = 'log10 mean power';
hc.Ticks = 2:6;
ha = gca; ha.LineWidth = 2;
hgexport(gcf,['./plots/avg_spectra_g_air_brc.eps']);

% water
figure; hold on; setupfig(5,5,18);
imagesc([Xtf_centers(1) Xtf_centers(end)],[Xsf_centers(1) Xsf_centers(end)], log10(pbWaterMedian),[1.5 6]);
xlabel('Temporal (hz)'); ylabel('Spatial (cpd)');
set(gca,'ydir','normal');
box on; axis square tight;
hc = colorbar; hc.Label.String = 'log10 mean power';
hc.Ticks = 3:7;
ha = gca; ha.LineWidth = 2;
hgexport(gcf,['./plots/avg_spectra_g_water_brc.eps']);



% plot raw differences
figure; hold on; setupfig(5,5,18);

greenblue = make_green_blue_colormap; % add greenblue colormap

imagesc(powerbinsDiff,[-max([abs(min(powerbinsDiff(:))) abs(max(powerbinsDiff(:)))]) max([abs(min(powerbinsDiff(:))) abs(max(powerbinsDiff(:)))])]);
%plot(c,r,'k*');
xlabel('Temporal (hz)'); ylabel('Spatial (cpd)');
set(gca,'ydir','normal');
set(gca,'xtick',[1 7 13 19],'xticklabel',[0.5 2 10 44]);
set(gca,'ytick',[1 7 13 19],'yticklabel',[0.06 0.13 0.3 0.7],'ydir','normal');
box on; axis square tight;
hc = colorbar; hc.Label.String = 'difference log10 mean power';
hc.Ticks = [-0.8 0 0.8];
ha = gca; ha.LineWidth = 2;
colormap(flipud(greenblue));

hgexport(gcf,['./plots/avg_spectra_g_air_vs_water_brc.eps']);

