function [pix] = ang2pix(nside, theta, phi, nest, lonlat)
%ang2pix(nside, theta, phi, nest, lonlat)
%Find the pixel index given a latitude and longitude in either a ring or
%nested scheme
%
%Inputs:
%nside: Pixel resolution, power of 2 less than 30
%theta, phi: Angular coordinates of a point on a sphere
%nest: Boolean, nested, or default is ring
%lonlat: Boolean, inputs are default in radians, == true will take in degrees
    %in colat and lon
%
%Test: 
%ang2pix(16, pi/2, 0, false, false)
%ang2pix(16, [pi/2, pi/4, pi/2, 0, pi], [0 ,pi/4, pi/2+1e-15, 0, 0], false, false)

if lonlat == true
    [theta, phi] = lonlat2thetaphi(theta, phi);
end

if nest == true
    pix = ang2pix_nest(nside, theta, phi);
else
    pix = ang2pix_ring(nside, theta, phi);
end
    
end