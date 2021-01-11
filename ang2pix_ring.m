function [ipring] = ang2pix_ring(nside, theta, phi)
%ang2pix_ring(nside, theta, phi)
%Find the pixel index of a given latitude and longitude in the ring scheme
%
%Inputs:
%nside: Pixel resolution, power of 2 less than 30
%theta, phi: Angular coordinates of a point on a sphere
%
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
%acth_in = abs(cth_in);

phi_in = mod(phi, 2*pi);
%phi_in = phi_in + (phi <= 0)*2*pi;

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

n_sp = length(sp_in);
n_eq = length(eq_in);
n_np = length(np_in);

if n_sp+n_eq+n_np ~= np
    error('Error in routine.')
end
    
if n_eq > 0  %Equatorial Band
 tt = 0.5 + phi_in(eq_in) / (pi * 0.5);
 zz = cth_in(eq_in) * 0.75;
 
 jp = fix(nl1*(tt-zz));
 jm = fix(nl1*(tt+zz));
 
 ir = fix((nl1 + 1) + jp - jm);
 k = fix(1 - mod(ir,2));
 
 ip = bitand(fix(((1-nl1) + jm + jp + k)/ 2), (nl4-1));
 %ip = fix(fix((jp+jm-nl1+k+1)/2));
 
 ipring(eq_in) = fix(ncap + nl4*(ir-1) + ip);
end

if n_np > 0 %North Polar Cap
   tt = phi_in(np_in)/(pi*0.5);
   tp = mod(tt, 1);
   tmp = sqrt(3 * (1-abs(cth_in(np_in))));
   
   jp = fix(nl1 .* tp    .* tmp);
   jm = fix(nl1 .* (1-tp) .* tmp);
   
   ir = jp + jm + 1;
   ip = fix(tt .* ir) + 1;
   ir4 = 4 .* ir;
   ip = fix(ip - ir4.*(ip > ir4));
   
   ipring(np_in) = 2*ir.*(ir-1) + ip - 1;
end

if n_sp>0 %South Polar Cap
    tt = phi_in(sp_in) / (pi*0.5);
    tp = mod(tt, 1);
    
    tmp = sqrt(3 * (1-abs(cth_in(sp_in))));
    
    jp = fix(nl1 .* tp .* tmp); 
    jm = fix(nl1 .* (1 - tp) .* tmp);
    
    ir = jp + jm + 1;
    ip = fix(tt .* ir) + 1;
    ir4 = 4 .* ir;
    ip = fix(ip - ir4.*(ip > ir4));
    
    ipring(sp_in) = npix - 2*ir.*(ir+1) + ip - 1;  
end

end %ang2pix_ring