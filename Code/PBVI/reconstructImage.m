function out_img = reconstructImage(pyr,param,pind)
%Reconstruct an image from the interpolated pyramid
imSize = pind(1, :);
dim = size(pyr, 2);
out_img = zeros(imSize(1), imSize(2), dim);
%Reconstruct each color channel
for i = 1 : dim
    out_img(:, :, i) = reconSCFpyr_scale(pyr(:, i), pind, ...
        'all', 'all', param.tWidth, param.scale, param.nScales);
end
%Convert to RGB
out_img = im2uint8(out_img);
cform = makecform('lab2srgb');
out_img = applycform(out_img, cform);
end

