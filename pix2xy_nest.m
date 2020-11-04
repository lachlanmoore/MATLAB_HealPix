function [ix, iy] = pix2xy_nest(nside, ipf)
%pix2xy_nest(nside, ipf)
%Takes pixel input and converts to x and y, nested 

nsidesq = nside^2;
ipf = fix(mod(ipf,nsidesq));

[pix2x, pix2y] = pix2xy;

ipf_tmp = ipf;
scale = 1;
ix = 0; iy = 0;
smax = 2;

for i = 0:smax-1;
    ip_low = fix(mod(ipf_tmp, 1024));
    ix = ix + scale * pix2x(ip_low+1);
    iy = iy + scale * pix2y(ip_low+1);
    scale = scale*32;
    ipf_tmp = fix(ipf_tmp/1024);
end
ix = ix + scale * pix2x(ipf_tmp+1);
iy = iy + scale * pix2y(ipf_tmp+1);

end