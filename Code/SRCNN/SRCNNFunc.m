function psnr_im = SRCNNFunc(filePath, targetPath, preset)
%Read image
im  = imread(filePath);
%Set up_scale
up_scale = str2num(preset(1));
%Set model
model = '';
switch up_scale
    case 2
        model = 'SRCNNmodel\ImageNet\x2.mat';
    case 3
        model = 'SRCNNmodel\ImageNet\x3.mat';
    case 4
        model = 'SRCNNmodel\ImageNet\x4.mat';
end
%Resize image
im = double(im) / 255;
%Magnify LR image to target size using bicubic
im = imresize(im, up_scale, 'bicubic');
if size(im, 3) > 1
    im = rgb2ycbcr(im);
    %1, 2, 3 is Y, Cr, Cb
    im_b = im(:, :, 1);
    im2 = im(:, :, 2);
    im3 = im(:, :, 3);
else
    im_b = im;
end
%Only rebuild Y channel in YCbCr space
im_h = SRCNN(model, im_b);
if size(im, 3) > 1
    [m,n]=size(im_h);
    %Compound 3 channel
    im_h1=zeros(m,n,3);
    im_h1(:, :, 1) = im_h;
    im_h1(:, :, 2) = im2;
    im_h1(:, :, 3) = im3;
    %Turn back to uint8
    im_h1 = uint8(im_h1 * 255);
    %Turn back to RGB
    im_h1 = ycbcr2rgb(im_h1);
else
    im_h1 = uint8(im_h * 255);
end
%Write image file
imwrite(im_h1, targetPath);
%Calculate PSNR
psnr_im = compute_psnr(imread(filePath),im_h1);
end