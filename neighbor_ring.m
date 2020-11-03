function [neighbors] = neighbor_ring(nside, ipix)
% Find the pixel neighbors in a ring scheme
%
% Inputs:
% nside: Pixel resolution, power of 2 less than 30
% ipix: Pixel values in nest
%
% Output:
% neighbors in ring scheme


npix = nside2npix(nside);

if ipix > npix
   error('Not a valid pixel. ipix greater than number of pixels') 
end

ipnest = ring2nest(nside, ipix);
neighbors_nest = neighbor_nest(nside, ipnest); 
neighbors = nest2ring(nside, neighbors_nest);

end