function VideoIP(filePath1, filePath2, ~, up_rate)
addpath('matlabPyrTools');
addpath('matlabPyrTools/Mex');
addpath('PBVI');
%Initialize images
im1 = (imread(filePath1));
im2 = (imread(filePath2));
%Set size
[h, w, ~] = size(im1);
%Set number of frames to interpolate
if strcmp(up_rate, '2x')
    params.nFrames = 1;
elseif strcmp(up_rate, '3x')
    params.nFrames = 2;
else
    params.nFrames = 3;
end
%Set number of orientations in the steerable pyramid
params.nOrientations = 8;
%Set width of transition region
params.tWidth = 1;
%Set steepness of the pyramid
params.scale = 0.5^(1 / 4);
%Set maximum allowed shift in radians
params.limit = 0.4;
%Set number of levels of the pyramid
params.min_size = 15;
params.max_levels = 23;
params.nScales = min(ceil(log2(min([h w]))/log2(1 / params.scale) - ...
    (log2(params.min_size) / log2(1 / params.scale))), params.max_levels);
%Decompose images using steerable pyramid
L = decompose(im1,params);
R = decompose(im2,params);
%Compute shift corrected phase difference
phase_diff = computePhaseDifference(L.phase, R.phase, L.pind, params);
%Generate inbetween images
step = 1 / (params.nFrames + 1);
for f=1:params.nFrames
    alpha = step * f;
    %Interpolate pyramid
    inter_pyr = interpolatePyramid(L, R, phase_diff, alpha);
    %Reconstruct image from steerable pyramid
    recon_image = reconstructImage(inter_pyr, params, L.pind);
    imwrite(recon_image, num2str(((params.nFrames + 1) * (str2num(erase(erase(filePath1, 'Temp\frame'), '.png')) - 1) + 1 + f), 'Temp\\newframe%d.png'));
end
imwrite(im1, num2str(((params.nFrames + 1) * (str2num(erase(erase(filePath1, 'Temp\frame'), '.png')) - 1) + 1), 'Temp\\newframe%d.png'));
end