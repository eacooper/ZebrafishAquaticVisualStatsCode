function make_cubes_from_pngs_demo(work_dir, pngFolder)
% This is a demo version of video cube pipeline. This pipeline was 
% modified from make_cubes_from_calibframes.m  (6/5/20) and 
% make_cubes_from_calibframes_brc.m (8/1/20). 
%
%  Input:
%     work_dir: the full path to the working directory to run this demo.
%     pngFolder: the name of the png folder. The png folder name 
%                       should specify device name as 'insta1' or 'insta2', 
%                       and specify if the video was in 'water' or 'air'.
%                       e.g., 'Oct11_insta2_water_S3_5'
%  Prequisition:
%     Please download the 'calibration_data' and the 'helper_functions'
%     folders to the working directory.
%
%  Output:
%     Preprocessed video cubes will be stored as mat files in the output
%     directory
%
%  NOTE: the pngs were generated from a raw video MP4 file using 
%              FFMPEG software.
%
% -Lanya T. Cai 1/3/2022

%% Initialize variables and file paths
disp('Initializing variables and file paths...');

% Check input 
if nargin < 2
    warning('Not enough inputs! Please provide (1) the full path to the working directory and (2) the png folder name, e.g., Oct11_insta2_water_S3_5.');
    return
end

calib_data_dir = [work_dir '/calibration_data'];
pngs_dir = [work_dir '/' pngFolder];

% Check if the provided folder paths exist
if exist(work_dir, 'dir')~=7  % Category 7 of the exist function is for a directory
    warning('The input working directory does not exist.'); 
    return
else
    if exist(pngs_dir, 'dir')~=7
        warning('The input png folder does not exist.');
        return
    end
    if exist(calib_data_dir, 'dir')~=7
        warning('The calibration data folder does not exist.');
        return
    end
end

% Determine device number and water flag from folder name
if contains(pngFolder, 'insta1')
    device    = 'insta1';
elseif contains(pngFolder, 'insta2')
    device    = 'insta2';
end

if contains(pngFolder,'water')
    waterFlag = 1;
else
    waterFlag = 0;
end

% Width and height of the raw video frames
h = 1504;
w = 3008;

% Specify Gaussian filter size and sigma for reducing compression artifacts
blursigma_cam1 = 2;
blursigma_cam2 = 3; % reduce cam2 contrast gain to match cam1, by applying a larger sigma to cam2
blurfiltersize = 9;

% Add path to calibration data folder
addpath(calib_data_dir);
addpath(pngs_dir);

% make directory for results as a subfolder of the current dir
outFolder = [work_dir '/' pngFolder '_output'];

if exist(outFolder, 'dir')~=7
    mkdir(outFolder);
end

addpath(outFolder);

%% Load calibration files
disp('Loading calibration files...');

% % diving case mask
load([calib_data_dir '/dive_case_mask_' device '.mat'], 'dive_case_mask');
% 
% % Rotate dive case mask
dcmask_d1   = imrotate(dive_case_mask(:,1505:3008),-90);
dcmask_d2   = imrotate(dive_case_mask(:,1:1504),90);

% linearization coefficients for the green channel (converts RGB from 0-255 into values that are linear wrt light power in each spectral band)
load([calib_data_dir '/pixel_value_LUT_' device '.mat'], 'LUT_G');
disp('Done.');

%% Process frames (this step will be skipped if calibrated_frames.mat is detected in the outFolder)

if exist([outFolder '/calibrated_frames.mat'],'file')~=2
    disp('No calibrated frames were found. Now processing uncalibrated frames...');

    % Get png file name list
    fileinfo = dir([pngs_dir '/*.png']);
    numPngs  = length(fileinfo);
    
    % Preallocate output variables for the process_frames step
    % WARNING: matlab may have memory issue with an array of
    % 1504-1504-1001 (requires approx. 17G). We process the 
    % 1001 frames from each camera in 2 variables instead of 1 
    % huge variable here, to handle the memory stall risk. In the
    % following, frames_1G_1 and frames_1G_2 are from cam1, and
    % frames_2G_1 and frames_2G_2 are from cam2.
    frames_1G_1 = zeros(h,h,floor(numPngs/2));
    frames_1G_2 = zeros(h,h,numPngs-floor(numPngs/2));
    frames_2G_1 = zeros(h,h,floor(numPngs/2));
    frames_2G_2 = zeros(h,h,numPngs-floor(numPngs/2));
    
    % Loop through pngs for linearization
    for iFrame = 1:numPngs
        
        frame = imread([pngs_dir '/' fileinfo(iFrame).name]);
        if mod(iFrame,50)==1, disp(num2str(iFrame));end
        
        % --- Linearize frame ---
        
        % subtract normalize to 0-1
        frame_norm = double(frame)/255; clear frame;
        
        % linearize pixel values of the green channel by converting to camera photometric power unit
        lin_frame = LUT_G(frame_norm(:, :, 2));
        clear frame_norm;
        
        % --- Separate cams ---
        lin_frame_1 = lin_frame(:, (w/2+1):w, :);
        lin_frame_2 = lin_frame(:, 1:w/2, :);
        clear lin_frame;
        
        % rotate single camera images upright to align with calibrated spherical coordinates
        lin_frame_1 = imrotate(lin_frame_1, -90);
        lin_frame_2 = imrotate(lin_frame_2, 90);
        
        % --- Blur compression artifacts ---
        frame_blur_1 = imgaussfilt(lin_frame_1, blursigma_cam1, 'FilterSize', blurfiltersize);
        frame_blur_2 = imgaussfilt(lin_frame_2, blursigma_cam2, 'FilterSize', blurfiltersize);
        clear lin_frame_1; clear lin_frame_2;
        
        % --- Apply the dive case mask ---
        frame_1 = frame_blur_1; clear frame_blur_1;
        frame_2 = frame_blur_2; clear frame_blur_2;
        
        frame_1(~dcmask_d1) = NaN;
        frame_2(~dcmask_d2) = NaN;
        
        % --- Add to output matrix ---
        if iFrame < (numPngs/2)
            frames_1G_1(:,:,iFrame) = frame_1;
            frames_2G_1(:,:,iFrame) = frame_2;
        else
            frames_1G_2(:,:,iFrame-floor(numPngs/2)) = frame_1;
            frames_2G_2(:,:,iFrame-floor(numPngs/2)) = frame_2;
        end
        clear frame_1; clear frame_2;
        
    end
    
    % Save calibrated frames of the green channel
    disp('Frames have been processed. Saving them...');
    save([outFolder '/calibrated_frames.mat'],'frames_1G_1','frames_2G_1','frames_1G_2','frames_2G_2','-v7.3');
    disp('Done.');
else
    disp('Calibrated frames already exist. Skipping frames preprocessing.');
end

%%
%--------------------------------------------%
% Generate rectilinear frames and make cubes %
%--------------------------------------------%

% Load calibrated frames
%WARNING: the following loading process may take a few minutes.
disp('Now loading calibrated frames. This may take a few minutes...');
load([outFolder '/calibrated_frames.mat'],'frames_1G_1','frames_2G_1','frames_1G_2','frames_2G_2');
numPngs = size(frames_1G_1,3) + size(frames_1G_2,3);
disp('Done.');

% Load spherical coordinate map for the green channel
switch waterFlag
    case 1, load([calib_data_dir '/spherical_coordinates_' device '_water.mat'], 'sphericalCam1G', 'sphericalCam2G');
    case 0, load([calib_data_dir '/spherical_coordinates_' device '_air.mat'],  'sphericalCam1G', 'sphericalCam2G');
end

% Virtual rectilinear cam parameters
half_fov_deg       = 37.5; % unit: deg
dong_interp_buffer = 2;    % unit: deg
dong_samp_per_deg  = 3;

%% Main loop to create 4 non-overlapping cubes from each png folder

el = 0;

sphericalCam1 = sphericalCam1G; sphericalCam2 = sphericalCam2G;

for cubeIdx = 1:4
    disp(['Now generating cube #' num2str(cubeIdx) '...']);
    
    switch cubeIdx
        case 1, camInd = 1; az = -38; 
        case 2, camInd = 1; az = 38; 
        case 3, camInd = 2; az = -38; 
        case 4, camInd = 2; az = 38; 
    end
    
    % Initialize cube
    cubeSize = dong_samp_per_deg * half_fov_deg * 2;
    cube = zeros(cubeSize, cubeSize, numPngs);
    
    % Put camera coords into homogenous coordinates
    switch camInd
        case 1
            pts = cat(2,sphericalCam1.x(:),sphericalCam1.y(:),sphericalCam1.z(:),ones(size(sphericalCam1.z(:))));
            theta = sphericalCam1.thetam;
            phi = sphericalCam1.phim;
        case 2
            pts = cat(2,sphericalCam2.x(:),sphericalCam2.y(:),sphericalCam2.z(:),ones(size(sphericalCam2.z(:))));
            theta = sphericalCam2.thetam;
            phi = sphericalCam2.phim;
    end
    
    xyz = pts(:,1:3);
    
    % Get index of center, adjusting for rounding issues
    centerInd_el = find(phi(:)==0);
    centerInd = find( abs(theta(centerInd_el) - az) == min(abs(theta(centerInd_el) - az)) );
    centerInd = (centerInd(1) - 1) * h + centerInd_el(1);
    
    % normed vectors pointing to old and new center
    newCenter = xyz(centerInd,:) ./ norm(xyz(centerInd,:));
    oldCenter = [0 0 1];
    
    % axis/angle rotation between them
    rotAngle = acosd(dot(newCenter,oldCenter));
    axs = cross(newCenter,oldCenter);
    axs = axs./norm(axs);
    
    % apply this via Rodriguez rotation to all xyz coordinates
    if rotAngle==0
        R = eye(3);
    else
        R = axang2rotm([axs rotAngle*(pi/180)]);
    end
    
    E = [1 0 0 ; 0 1 0 ; 0 0 1];
    t = [0 ; 0 ; 0];
    Rt = cat(2,R,t);
    virtCam = E*Rt;
    
    % perform projection
    P = virtCam * pts'; clear pts;
    
    focalLength = 1; % arbituary value
    Px = (focalLength .* P(1,:)) ./ P(3,:);
    Py = (focalLength .* P(2,:)) ./ P(3,:);
    
    Px = reshape(Px, [h h]);
    Py = reshape(Py, [h h]);
    
    validInd = abs(Px) < tand(half_fov_deg + dong_interp_buffer) & abs(Py) < tand(half_fov_deg + dong_interp_buffer);
    xxp = Px(validInd);
    yyp = Py(validInd);
    xxp = double(xxp); % required by scatteredInterpolant function
    yyp = double(yyp);
    
    [newx,newy] = meshgrid(linspace(-tand(half_fov_deg),tand(half_fov_deg),dong_samp_per_deg*2*half_fov_deg), ...
        linspace(-tand(half_fov_deg),tand(half_fov_deg),dong_samp_per_deg*2*half_fov_deg));
    
    clear P; clear Px; clear Py;
    
    % Make a video cube
    for iFrame = 1:numPngs
        
        % Get the calibrated frame of the color channel being processed
        switch camInd
            case 1
                if iFrame<(numPngs/2)
                    im = frames_1G_1(:,:,iFrame);
                else
                    im = frames_1G_2(:,:,iFrame-floor(numPngs/2));
                end
            case 2
                if iFrame<(numPngs/2)
                    im = frames_2G_1(:,:,iFrame);
                else
                    im = frames_2G_2(:,:,iFrame-floor(numPngs/2));
                end
        end
        
        % crop to square fov
        lum = im(validInd); 
        
        % create interpolation object for rectilinear sampling of xyz in
        % cam0, getting 3 samples per degree.
        F_dong = scatteredInterpolant(xxp(~isnan(lum)), yyp(~isnan(lum)), lum(~isnan(lum)), 'linear','none');
        
        % Crop and save to frames cube
        cube(:,:,iFrame) = F_dong(newx,newy);        
    end
     
    % the Oct 19 example needs to be rotated because camera was mounted upside down
    if any(strfind(pngFolder,'Oct19_insta1_water_S1'))
        cube = rot90(cube,2);
    end

    % Store the cube
    save([outFolder '/demo_' num2str(cubeIdx) '_g_cube.mat'], 'cube','camInd','az','el'); 
    disp(['Cube #' num2str(cubeIdx) ' has been saved.']);
    
    clear cube; 
end
