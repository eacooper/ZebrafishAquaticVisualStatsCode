function greenblue = make_green_blue_colormap
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

hsvgreen = rgb2hsv([0.5 0.75 0.4]);
hsvgreen = repmat(hsvgreen,256,1).* cat(2,ones(256,1),linspace(1,0,256)',ones(256,1));
rgbgreen = hsv2rgb(hsvgreen);

hsvblue = rgb2hsv([0.5 0.5 0.75]);
hsvblue = repmat(hsvblue,256,1).* cat(2,ones(256,1),linspace(1,0,256)',ones(256,1));
rgbblue = hsv2rgb(hsvblue);

% combine
greenblue = [rgbgreen; flipud(rgbblue)];
