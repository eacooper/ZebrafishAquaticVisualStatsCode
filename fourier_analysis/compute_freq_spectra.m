function [Xsf,SF] = compute_freq_spectra(im,mincpd,maxcpd,edges)
%
% Takes in an image and optionally a cpd value and computes the
% spectrum over spatial frequency. Beware that if you don't
% input cpd, this function will assume 1 arcmin per pixel, and will return
% the spatial frequency bins in cpd, not cycles per image.
%
% Xsf, Xth : center locations of Fourier domain rings and wedges
% SF, TH   : mean amplitude in each bin
%
% Emily Cooper


%%% image informatiom
if isempty(maxcpd), maxcpd = 30; end  % default assumption of 1 arcmin per pixel
Fim         = im;                     % Fourier transform with image center handling, mean zeroing, hanning, and re-centering
[ydim,xdim] = size(im);               % image dimensions
sc          = 3;                      % up-sample ramps by this much (to create anti-aliased masks) ALWAYS ODD

% centered coords at each point, supersize for antialiasing
[xramp,yramp] = meshgrid( (1:sc*xdim), (1:sc*ydim));

% handle center in scaled image
[ydim2,xdim2]   = size(xramp); % image dimensions
if mod(xdim2,2) == 0
    midx2 = xdim2/2 + 1;       % if xdim is even, x center is right of center line
else
    midx2 = ceil(xdim2/2);     % if xdim is odd,  x center is center column
end
if mod(ydim2,2) == 0
    midy2 = ydim2/2 + 1;       % if ydim is even, y center is below center line
else
    midy2 = ceil(ydim2/2);     % if ydim is odd,  y center is center row
end
xramp = xramp - midx2;
yramp = yramp - midy2;

%%% compute amplitude spectrum as a function of spatial frequency
dist = sqrt( xramp.^2 + yramp.^2 );  % radial distance from center at each point, use this to select rings in FT

% max of smallest dimension
maxdist = min( xdim2, ydim2 ) / 2;                     

% convert all dists to cpd
dist = maxcpd*dist/maxdist;                         

c = 1; % counter

% for each bin
for k = 2:length(edges)
    
    ind    = find( dist >= edges(k-1) & dist <= edges(k) );   % select a ring of values at k with width wk
    mask   = make_FT_mask(dist,ind,sc);                       % make ring mask for range of frequencies
    Xsf(c) = edges(k);                                        % store sf value
    SF(c)  = sum( Fim(:).*mask(:) ) / sum( mask(:) );         % mean in image
    c      = c + 1;
    
end

