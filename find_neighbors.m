function [neighbors] = find_neighbors(varargin)
% find_neighbors(nside, theta, phi, nest, lonlat)
% Get all neighbours for a given pixel
%
% Inputs:
% nside: Pixel resolution, power of 2 less than 30
% theta, phi: lon lat
%   If only a theta is given, assumed to be pixel index instead
% nest: Bool, if none given default is false
% lonlat: Bool, if none given default is false
%   If true, angle inputs assumed to be lat and lon, 
%   If false, angle inputs assumed to be co-lat and lon
%
% Outputs:
% neighbors: Neighboring pixels of input. 6, 7 or 8 depending on location

p = inputParser;
p.addRequired('nside')
p.addRequired('theta')
p.addOptional('phi', [])
p.addOptional('nest', false);
p.addOptional('lonlat', false);
p.parse(varargin{:});
nside = p.Results.nside;
theta = p.Results.theta;
phi = p.Results.phi;
nest = p.Results.nest;
lonlat = p.Results.lonlat;

if not(isempty(phi))
    theta = ang2pix(nside, theta, phi, nest, lonlat);
end

if nest == true
    neighbors = neighbor_ring(nside, theta);
elseif nest == false
    neighbors = neighbor_nest(nside, theta);
else
    error('nest must be set to true or false')
end


end

