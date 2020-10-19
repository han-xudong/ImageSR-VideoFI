%Compute shift corrected phase differences
%Interpolating unreliable phase estimates from previous levels
function phaseDiff = computePhaseDifference(phaseL, phaseR, pind, params)
%Compute phase difference
phaseDiff = atan2(sin(phaseR - phaseL), cos(phaseR - phaseL));
%Save original phase difference for last step
phaseDiffOriginal = phaseDiff;
%For each level of pyramid
for i = 1 : size(phaseL, 2)
    %Compute shift correction
    phaseDiff(:, i) =  shiftCorrection(phaseDiff(:, i), pind, params);
    %Unwrap phase difference to allow smooth interpolation
    unrappedPhaseDifference = myUnwrap([phaseDiff(:, i),phaseDiffOriginal(:, i)], [], 2);
    %Save and go to next level
    phaseDiff(:, i) = unrappedPhaseDifference(:, 2);
end
end

