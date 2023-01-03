function redblue = make_red_blue_colormap(minmax_ratio)
%
% make a (potentially asymmetric) colormap from blue to white to red
%
% minmax_ratio is the ratio between the min and max points to be plotted
% (the input to caxis[min max])). this can be used to ensure that 0 in the
% data maps to white in the colormap
%
% if minmax_ratio is 1, the range of red and blue values are equal, so if
% caxis is symmetric (i.e., caxis([-1 1])), 0 will be white
%
% for example, if minmax_ratio is < 1, there will be fewer blue values,
% this can be used if, for instance, the range of negative values is very
% compressed relative to the range of positive values (i.e., caxis([-0.1
% 1])

% 256 values from red to white
red = gray(256);
red = [ones(length(red),1) red(:,1) red(:,1)];

% values from blue to white
blue = gray(round(256*(minmax_ratio)));
blue = [blue(:,1) ones(length(blue),1) ones(length(blue),1)];

% combine
redblue = [blue; [1 1 1]; flipud(red)];
