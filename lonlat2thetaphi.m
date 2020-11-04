function [theta, phi] = lonlat2thetaphi(lon, lat)
%lonlat2thetaphi(lon, lat)
%Transform longitude and latitude (deg) into co-latitude and longitude (rad)
%
%Inputs:
%lon: Longitude in degrees
%lat: Latitude in degrees
%
%Outputs: 
%theta, phi: Co-latitude and longitude in radians


theta = pi/2 - (lat * pi/180); 
phi = lon * pi/180;
end