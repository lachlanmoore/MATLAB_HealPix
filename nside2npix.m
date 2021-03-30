function npix = nside2npix(nside)
%nside2npix(nside)
%Returns the number of pixels based on the nside value
%nside must be a power of 2 less than 30


powers = 2.^[1:1:29];

if ~ismember(nside, powers)
    error('Not a valid nside.')
else
 npix = 12 * nside^2;
end

end