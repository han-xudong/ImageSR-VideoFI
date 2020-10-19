function psnr_im = ImageSR(filePath, targetPath, model, preset)
addpath('SRCNN');
addpath('Bicubic');
psnr_im = 0;
%SR by SRCNN model
if strcmp(model, 'SRCNN')
    psnr_im = SRCNNFunc(filePath, targetPath, preset);
elseif strcmp(model, 'Bicubic')
    psnr_im = BicubicFunc(filePath, targetPath, preset);
end
end