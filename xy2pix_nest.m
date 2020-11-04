function [ipnest] = xy2pix_nest(nside, ix, iy, face_num)
%xy2pix_nest(nside, ix, iy, face_num)
%Takes x and y and converts to pixel, nested

[x2pix, y2pix] = xy2pix;

ix_tmp = ix;
iy_tmp = iy;

smax = 1;
scale = 1;
ipnest = 0;
scale_factor = 128^2;
npface = fix(nside)^2;

for i = 0:smax-1
    ix_low = fix(mod(ix_tmp, 128));
    iy_low = fix(mod(iy_tmp, 128));
    
    ipnest = ipnest + (x2pix(ix_low+1) + y2pix(iy_low+1)) * scale;
    scale = scale * scale_factor;
    ix_tmp = fix(ix_tmp/128);
    iy_tmp = fix(iy_tmp/128);
end

ipnest = ipnest + fix((x2pix(ix_tmp+1) + y2pix(iy_tmp+1)) * scale);
ipnest = ipnest + face_num' * npface;
end