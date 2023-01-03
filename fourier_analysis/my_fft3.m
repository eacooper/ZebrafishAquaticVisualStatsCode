function [Fim,midx,midy] = my_fft3(cube, hanning)
% compute fourier transform with:
%
% -correct image center handling
% -mean zeroing
% -hanning
% -centering

[ydim,xdim,tdim] = size(cube); % video cube dimensions

if mod(xdim,2) == 0
    midx = xdim/2 + 1;         % if xdim is even, x center is right of center line
else
    midx = ceil(xdim/2);       % if xdim is odd,  x center is center column
end                 

if mod(ydim,2) == 0
    midy = ydim/2 + 1;         % if ydim is even, y center is below center line
else
    midy = ceil(ydim/2);      % if ydim is odd,  y center is center row
end   

% make a 3D hanning window
if hanning
    hannx=hann(xdim); %1D window
    hanny=hannx';
    hannt=hann(tdim);
    hann3=ones(xdim, ydim, tdim);
    hann2 = hannx.*hanny;
    for jj=1:tdim
        hann3(:, :, jj)=hann2.*hannt(jj);
    end
    
    cube = cube .* hann3; % apply 3D hanning window to video cube
end

cube = cube - mean(cube(:)); % zero mean the video cube

if ~hanning % if not windowing, then we need to mirror the cube in 3D, do fft, and crop the core out
    cube = single(cube);
    cube_mid_row = cat(2,fliplr(cube),cube,fliplr(cube));
    
    cube_mid_layer = cat(1, flipud(cube_mid_row), cube_mid_row, flipud(cube_mid_row));
    
    cube_mid_layer_perm = permute(cube_mid_layer,[1 3 2]);
    cube_3Dmirror_perm = cat(2,fliplr(cube_mid_layer_perm),cube_mid_layer_perm,fliplr(cube_mid_layer_perm));
    cube_3Dmirror = permute(cube_3Dmirror_perm,[1 3 2]);
    
    Fim_3Dmirror = fftshift( abs(fftn( cube_3Dmirror ) ) );
    Fim = Fim_3Dmirror((ydim+1):(ydim*2), (xdim+1):(xdim*2), (tdim+1):(tdim*2));
else
    Fim  = fftshift( abs( fftn( cube ) ) ); % FT of video cube
end