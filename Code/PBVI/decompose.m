function decomposition = decompose(im, params)
%Convert image to LAB
cform = makecform('srgb2lab');
im = applycform(im, cform);
im = im2single(im);
im_dims = size(im);
%For each color channel
for i = 1 : size(im, 3)
    %Build pyramid
    [pyr, pind] = buildSCFpyr_scale(im(:, :, i), params.nScales,...
        params.nOrientations-1, params.tWidth, params.scale,...
        params.nScales, im_dims);
    %Store decomposition residuals
    high_pass = spyrHigh(pyr, pind);
    low_pass = pyrLow(pyr, pind);
    decomposition.high_pass(:, i) = high_pass(:);
    decomposition.low_pass(:, i) = low_pass(:);
    %Store decomposition phase and magnitudes
    pyr_levels = pyr(numel(high_pass) + 1 : numel(pyr) - numel(low_pass));        
    decomposition.phase(:, i) = angle(pyr_levels);
    decomposition.amplitude(:, i) = abs(pyr_levels);  
    %Store indices
    decomposition.pind = pind;
end



end

