function PSNR = compute_PSNR(im1, im2)
im1 = rgb2ycbcr(im1);
im1 = im1(:, :, 1);
im2 = rgb2ycbcr(im2);
im2 = im2(:, :, 1);
im1 = double(im1);
im2 = double(im2);
[h, w] = size(im2);
im1 = imresize(im1, [h, w]);
MSE = double(sum(sum((im1 - im2).^ 2)) / (h * w));
PSNR = 20 * log10(double(255 / (MSE^0.5)));
end

