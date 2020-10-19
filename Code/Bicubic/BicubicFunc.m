function psnr_im = BicubicFunc(filePath, targetPath, preset)
img = imread(filePath);
flag = size(img);
up_scale = str2num(preset(1));
if numel(flag) > 2
    r = img(:, :, 1);
    g = img(:, :, 2);
    b = img(:, :, 3);
    [m,n] = size(r);
    output(:, :, 1) = bicubic(r, m * up_scale, n * up_scale);
    output(:, :, 2) = bicubic(g, m * up_scale, n * up_scale);
    output(:, :, 3) = bicubic(b, m * up_scale, n * up_scale);
    imwrite(output, targetPath);  
else
    [m,n] = size(img);
    output = bicubic(img, m * up_scale, n * up_scale);
    imwrite(output, targetPath);
end
psnr_im = compute_PSNR(img, output);
end

