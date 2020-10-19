function psnr = compute_psnr(im1, im2)
%Only consider Y channel
if size(im1, 3) == 3
    im1 = rgb2ycbcr(im1);
    im1 = im1(:, :, 1);
end
if size(im2, 3) == 3
    im2 = rgb2ycbcr(im2);
    im2 = im2(:, :, 1);
end
%Compute PSNR
[h, w] = size(im2);
im1 = imresize(im1, [h, w]);
mse = double(sum(sum((im1 - im2).^ 2)) / (h * w));
psnr = 20 * log10(255 / sqrt(mse));