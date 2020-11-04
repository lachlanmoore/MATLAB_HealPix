function npix = nside2npix(nside)
%nside2npix(nside)
%Returns the number of pixels based on the nside value
%nside must be a power of 2 less than 30


if nside > 29
    error('Not a valid nside.')
elseif mod(log2(nside), 1) == 0 
    npix = 12 * nside^2;
else
    error('Not a valid nside.')
end

end