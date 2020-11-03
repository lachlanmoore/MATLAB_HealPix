function [ipring] = nest2ring(nside, ipnest)
% Convert pixels in a nested scheme into a ring scheme
%
% Inputs:
% nside: Pixel resolution, power of 2 less than 30
% ipnest: Pixel values in nest
%
% Output:
% Pixel values in ring

if size(ipnest, 1) > size(ipnest, 2)
    ipix = ipix';
end

jrll = [2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4];
jpll = [1, 3, 5, 7, 0, 2, 4, 6, 1, 3, 5, 7];

np = length(ipnest);
nl1 = fix(nside(1));
nl3 = 3*nl1;
nl4 = 4*nl1;
npface = nside^2;
ncap = 2*nl1*(nl1-1);
n_before = np;
nr = np;
kshift = np;

[pix2x, pix2y] = pix2xy();

ipf = fix(ipnest);
face_num = fix(ipf/npface);
ipf = mod(ipf, npface);

ix = 0; iy = 0;
smax = 5;
scale = 1;

for i = 1:smax
    ip_low = mod(ipf, 1024);
    ix = fix(ix + scale*pix2x(ip_low+1));
    iy = fix(iy + scale*pix2y(ip_low+1));
    scale = scale*32;
    ipf = fix(ipf/1024);
end

ix = ix + scale * pix2x(ipf+1);
iy = iy + scale * pix2y(ipf+1);

ip_low = 0; ipf = 0;
jrt = ix + iy;
jpt = ix - iy;

jr = fix(jrll(face_num+1).*nl1- jrt' - 1);
jrt = 0;

%Equitorial Region
pix_eqt_index = jr >= nl1 & jr <= nl3;
pix_eqt = jr(pix_eqt_index);
if length(pix_eqt) > 0
   nr(pix_eqt_index) = nl1;
   n_before(pix_eqt_index) = fix(ncap + nl4 * (jr(pix_eqt_index) - nl1));
   kshift(pix_eqt_index) = mod(jr(pix_eqt_index), 2);
end

%North Pole Region
pix_npl_index = jr < nl1;
pix_npl = jr(pix_npl_index);
if length(pix_npl) > 0
   nr(pix_npl_index) = jr(pix_npl_index);
   n_before(pix_npl_index) = fix(2 * nr(pix_npl_index) .* (nr(pix_npl_index) - 1));
   kshift(pix_npl_index) = 0;
end

%South Pole Region
pix_spl_index = jr > nl3;
pix_spl = jr(pix_spl_index);
if length(pix_spl) > 0
   nr(pix_spl_index) = nl4 - jr(pix_spl_index);
   n_before(pix_spl_index) = fix(npix - 2*(nr(pix_spl_index) + 1) .* nr(pix_spl_index));
   kshift(pix_spl_index) = 0;
end

jp = fix((jpll(face_num+1).*nr + jpt' + 1 + kshift)/2);

jp = jp - nl4 * (jp > nl4);
jp = jp + nl4 * (jp < 1);
ipring = n_before + jp - 1;

end