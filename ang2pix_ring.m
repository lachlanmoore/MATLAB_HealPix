function [ipring] = ang2pix_ring(nside, theta, phi)
%Find the pixel index of a given latitude and longitude in the ring scheme

%Inputs:
%nside: Pixel resolution, power of 2 less than 30
%theta, phi: Angular coordinates of a point on a sphere

%Outputs:
%ipring: Pixel index


npix = nside2npix(nside);

np = length(theta);
np1 = length(phi);

nl1 = nside(1);
nl2 = 2*nl1;
nl4 = 4*nl1;
ncap = nl2*(nl1-1);
ipring = zeros(1, np);
    
    
if np ~= np1
    error('The size of theta and phi must match')
end

if min(theta)<0 || max(theta)>pi
    error('Theta out of range')
end

cth_in = cos(theta);
phi_in = mod(phi, 2*pi);
phi_in = phi_in + (phi <= 0)*2*pi;
    
n = histcounts(cth_in*1.5, linspace(-3, 3, 4));
n_sp = n(1);
n_eq = n(2);
n_np = n(3);

if n_sp+n_eq+n_np ~= np
    error('Error in routine.')
end

band_index = discretize(cth_in*1.5, linspace(-3, 3, 4)); 


cth_index = 1;
sp_in = []; np_in = []; eq_in = [];

for j = 1:np
    if band_index(j) == 1
        sp_in = horzcat(sp_in, j);
    elseif band_index(j) == 2
        eq_in = horzcat(eq_in, j);
    else
        np_in = horzcat(np_in, j);
    end
    cth_index = cth_index + 1;
end
    
if n_eq > 0  %Equatorial Band
 tt = 0.5 + phi_in(eq_in) / (pi * 0.5);
 zz = cth_in(eq_in) * 0.75; 
 
 jp = floor(nl1*(tt-zz));
 jm = floor(nl1*(tt+zz));
 
 ir = (nl1 + 1) + jp - jm;
 k = ~(bitand(ir, 1));
 
 ip = bitand(((1-nl1) + jm + jp + k)/ 2 ,  (nl4-1));
 
 ipring(eq_in) = ncap + nl4*(ir-1) + ip;
 tt = 0; zz=0; jp=0; jm=0; ir=0; k=0; ip=0;
 
 fprintf('%d\n', ipring)
end

if n_np > 0 %North Polar Cap
   tt = phi_in(np_in)/(pi*0.5);
   tp = mod(tt, 1);
   tmp = sqrt(6) * sin(theta(np_in) * 0.5);
   
   jp = nl1 * tp     * tmp;
   jm = nl1 * (1-tp) * tmp;
   
   ir = jp + jm + 1;
   ip = (tt * ir) + 1;
   ir4 = ir*4;
   ip = ip - ir4*(ip > ir4);
   
   ipring(np_in) = 2*ir*(ir-1) + ip - 1;
   
    
   tt = 0; zz=0; jp=0; jm=0; ir=0; k=0; ip=0;
    
end

if n_sp>0 %South Polar Cap
    tt = phi_in(sp_in) / (pi*0.5);
    tp = mod(tt, 1);
    
    tmp = sqrt(6) * cos(theta(sp_in) * 0.5);
    
    jp = nl1 .* tp .* tmp; 
    jm = nl1 .* (1 - tp) .* tmp;
    
    ir = jp + jm + 1;
    ip = (tt .* ir) + 1;
    ir4 = 4 .* ir;
    ip = ip - ir4.*(ip > ir4);
    
    ipring(sp_in) = npix - 2*ir.*(ir+1) + ip - 1;
    tt = 0; zz=0; jp=0; jm=0; ir=0; k=0; ip=0;
    
end

end