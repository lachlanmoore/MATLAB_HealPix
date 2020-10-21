function [pix2x, pix2y] = pix2xy
%For converting pixel numbers to xy

pix2x = zeros(1024, 1);
pix2y = zeros(1024, 1);

for kpix = 0:1023
    jpix = kpix;
    ix = 0;
    iy = 0;
    ip = 1;
    while 1
        if jpix == 0
            break
        else
            id = mod(jpix, 2);
            jpix = fix(jpix/2);
            ix = id.*ip+ix;

            id = mod(jpix, 2);
            jpix = fix(jpix/2);
            iy = id.*ip+iy;

            ip = 2*ip;
        end
        
    end
    
    pix2x(kpix+1) = ix;
    pix2y(kpix+1) = iy;
    
end
end