function [ipnest] = ring2nest(nside, ipring)
%Takes pixel values in a ring scheme and converts to pixel values in nest
%
%Inputs:
%nside: Pixel resolution, power of 2 less than 30
%ipring: Pixel values in ring
%
%Outputs:
%ipnest: Pixel values in nest

if size(ipring, 1) > size(ipring, 2)
    ipring = ipring';
end

%Initilization
npix = nside2npix(nside);
jrll = [2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4];
jpll = [1, 3, 5, 7, 0, 2, 4, 6, 1, 3, 5, 7];

np = length(ipring);
nl1 = nside(1);
nl2 = 2*nl1;
nl4 = 4*nl1;
nl8 = 8*nl1;
ncap = nl2*(nl1-1);
nsup = nl2*(5*nl1+1);
npface = nl1*nl1;

iphi = zeros(1, np);
iring = zeros(1, np);
nr = zeros(1, np);

face_num = zeros(1, np);
kshift = zeros(1, np);

[x2pix, y2pix] = xy2pix;

%% North Pole Cap

np_index = ipring < ncap;
pix_npl = ipring(np_index);

if length(pix_npl) > 0
    
   ip = round(pix_npl) + 1;
   irn = fix( sqrt( ip/2 - sqrt(ip/2))) + 1;
   iring(np_index) = irn;
   iphi(np_index) = ip - 2*irn.*(irn-1);
   
   kshift(np_index) = 0;
   nr(np_index) = irn;
   face_num(np_index) = fix((iphi(np_index)-1)./irn);
   ip = 0; irn = 0;
   pix_npl = 0;
   
end

%% Equitorial Strip

eq_index = (ipring >= ncap) & (ipring < nsup);
pix_eq = ipring(eq_index);

if length(pix_eq) > 0
    
    ip = round(pix_eq) - ncap;
    iring(eq_index) = fix(ip/nl4) +nl1;
    iphi(eq_index) = mod(ip, nl4) + 1;
    
    kshift(eq_index) = mod(iring(eq_index) + nl1 , 2);
    nr(eq_index) = nl1;
    ip = 0;
    
    ire =  iring(eq_index) - nl1 + 1 ;
    irm =  nl2 + 2 - ire;
    ifm = fix((iphi(eq_index) - fix(ire/2) + nl1 -1) / nl1);
    ifp = fix((iphi(eq_index) - fix(irm/2) + nl1 -1) / nl1);
    ire = 0; irm = 0;
    ifd = ifp - ifm; 
    ifm = 0;
    
    sub1 = mod(ifp, 4)+4 .* (ifd == 0);
    sub2 = ifp .* (ifd == -1);
    sub3 = (ifp + 7) .* (ifd == 1);
    
    face_num(eq_index) = sub1 + sub2 + sub3;
    sub1 = 0 ; sub2 = 0 ; sub3 = 0 ; ifd = 0 ; ifp = 0;
    pix_eq = 0;
end

%% South Polar Region

sp_index = ipring >= nsup;
pix_sp = ipring(sp_index);

if length(pix_sp) > 0
    
    ip = npix - round(pix_sp);
    irs = fix(sqrt(ip/2 - sqrt(ip/2))) + 1;
    iring(sp_index) = nl4 - irs;
    iphi(sp_index)  = 1 - ip + 2*irs.*(irs+1);
    kshift(sp_index) = 0;
    
    nr(sp_index) = fix(irs);
    face_num(sp_index) = fix((iphi(sp_index)-1) ./ irs) + 8;
    ip = 0; irs = 0;
    pix_sp =0;
    
end

%% Find the x and y on the face

irt = fix(iring - jrll(face_num+1).*nl1 + 1);
ipt = fix(2.*iphi - jpll(face_num+1).*nr-kshift -1);
iring = 0; kshift = 0;; nr = 0;
ipt = ipt - nl8 * (ipt >= nl2);
ix = fix((ipt - irt) / 2);
iy = -fix((ipt + irt) / 2);
ipt = 0; irt = 0; iphi = 0;

smax = 1;
scale = 1;
ipnest = 0;

for i=0:smax
    ix_low = mod(ix, 128);
    iy_low = mod(iy, 128);
    
    ipnest = fix(ipnest + (x2pix(ix_low+1) + y2pix(iy_low+1)) * scale);
    ix = fix(ix/128);
    iy = fix(iy/128);
    
end

ipnest = ipnest + (x2pix(ix+1) + y2pix(iy+1)) * scale;
ix_low = 0; ix = 0; iy = 0; iy_low = 0; 

ipnest = ipnest + face_num' * npface;
    
     
end
