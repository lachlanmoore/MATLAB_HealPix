function [x2pix, y2pix] = xy2pix
%xy2pix
%For converting x and y into pixel numbers

x2pix = zeros(128, 1);
y2pix = zeros(128, 1);

for i = 1:128 
    
    j  = i-1;                    
    k  = 0;
    ip = 1;
      while 1
          if j == 0
              x2pix(i) = k;
              break
          else
              id = mod(j,2);
              j  = fix(j/2);
              k  = ip*id+k;
              ip = ip*4;
          end
      end
end
y2pix = 2 * x2pix;
end