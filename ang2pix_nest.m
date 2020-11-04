function [ipnest] = ang2pix_nest(nside, theta, phi)
%ang2pix_nest(nside, theta, phi)
%Find the pixel index of a given latitude and longitude in the nest scheme
%
%Inputs:
%nside: Pixel resolution, power of 2 less than 30
%theta, phi: Angular coordinates of a point on a sphere
%
%Outputs:
%ipnest: Pixel index

npix = nside2npix(nside);

ipring = ang2pix_ring(nside, theta, phi);
ipnest = ring2nest(nside, ipring);

end