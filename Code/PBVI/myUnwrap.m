function q = myUnwrap(p,cutoff,dim)
ni = nargin;
%Treat row vector as a column vector
rflag = 0;
if ni < 3 && (ndims(p) == 2) && (size(p, 1) == 1) 
   rflag = 1; 
   p = p.';
end
%Initialize parameters
nshifts = 0;
perm = 1 : ndims(p);
switch ni
case 1
   [p, nshifts] = shiftdim(p);
   cutoff = pi;
case 2
   [p, nshifts] = shiftdim(p);
otherwise    % nargin == 3
   perm = [dim : max(ndims(p), dim) 1 : dim-1];
   p = permute(p, perm);
   if isempty(cutoff)
      cutoff = pi; 
   end
end
% Reshape p to a matrix.
siz = size(p);
p = reshape(p, [siz(1) prod(siz(2 : end))]);
% Unwrap each column of p
q = LocalUnwrap(p, cutoff);
% Reshape output
q = reshape(q, siz);
q = ipermute(q, perm);
q = shiftdim(q, -nshifts);
if rflag
   q = q.'; 
end
end
function p = LocalUnwrap(p,cutoff)
% Incremental phase variations
dp = p(2, :) - p(1, :);
% Equivalent phase variations in [-pi,pi)
dps = mod(dp+pi, 2 * pi) - pi;
% Preserve variation sign for pi vs. -pi
dps(dps == -pi & dp > 0, :) = pi;
% Incremental phase corrections
dp_corr = dps - dp;
% Ignore correction when incr. variation is < CUTOFF
dp_corr(abs(dp) < cutoff) = 0;
% Integrate corrections and add to P to produce smoothed phase values
p(2, :) = p(2, :) + dp_corr;
end