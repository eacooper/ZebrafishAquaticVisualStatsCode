function fit_linear_marginals()

folders = {'air_g_brc','water_g_brc'};

% Set fitting model
ft = fittype('a*x+b');

% Fit marginals

for f = 1:length(folders)

    fig_sp = figure('units','normalized','outerposition',[0.02 0.02 0.98 0.98]); hold on;
    fig_tm = figure('units','normalized','outerposition',[0.02 0.02 0.98 0.98]); hold on;

    % Get paths to spectra of all cubes
    listing = dir(['./powerSpectra/' folders{f} '/*_powerSpectra.mat']);

    if exist('validcube_air','var')
        if f==1
            listing = listing(validcube_air);
        else
            listing = listing(validcube_water);
        end
    end

    % Compute slope and intercept for each cube and each marginal
    for l = 1:numel(listing)

        % Load marginals for the current cube
        load(['./powerSpectra/' folders{f} '/' listing(l).name],'Xsf_centers','Xtf_centers','spatial_marg','temporal_marg');

        % Fit spatial marginals
        [toFit_spatial,gof_s] = fit(log10(Xsf_centers)',log10(spatial_marg)',ft);
        slope_spatial(l)      = toFit_spatial.a;
        intercept_spatial(l)  = toFit_spatial.b;
        rmse_spatial(l)       = gof_s.rmse;
        rsq_spatial(l)        = gof_s.rsquare;

        % Fit temporal marginals
        [toFit_temporal,gof_t]= fit(log10(Xtf_centers)',log10(temporal_marg)',ft);
        slope_temporal(l)     = toFit_temporal.a;
        intercept_temporal(l) = toFit_temporal.b;
        rmse_temporal(l)      = gof_t.rmse;
        rsq_temporal(l)       = gof_t.rsquare;

        % plot it
        figure(fig_sp); hold on;
        subplot(6,6,l); hold on;
        plot(toFit_spatial,log10(Xsf_centers),log10(spatial_marg))
        legend off;

        figure(fig_tm); hold on;
        subplot(6,6,l); hold on;
        plot(toFit_temporal,log10(Xtf_centers),log10(temporal_marg))
        legend off;
    end

    % Save the stats
    save(['./powerSpectra/fitLin_marg_' folders{f} '.mat'],...
        'slope_spatial','slope_temporal','intercept_spatial','intercept_temporal',...
        'rmse_spatial','rmse_temporal','rsq_spatial','rsq_temporal');

    % save plot
    saveas(fig_sp,['./plots/marginal_fits_spatial_' folders{f} '.png']);
    saveas(fig_tm,['./plots/marginal_fits_temporal_' folders{f} '.png']);

end