function [neighbors] = neighbor_nest(nside, ipix)

npix = nside2npix(nside);

if ipix > npix
    error('Invalid Pixel')
end

ipix1 = ipix(1);


if nside == 1
   switch ipix1
       case 0
           neighbors = [ 8, 4, 3, 2, 1, 5 ];
       case 1
           neighbors = [  9, 5, 0, 3, 2, 6 ];
       case 2
           neighbors = [ 10, 6, 1, 0, 3, 7 ];
       case 3
           neighbors = [ 11, 7, 2, 1, 0, 4 ];
       case 4
           neighbors = [ 11, 7, 3, 0, 5, 8 ];
       case 5
           neighbors = [  8, 4, 0, 1, 6, 9 ];
       case 6
           neighbors = [  9, 5, 1, 2, 7,10 ];
       case 7
           neighbors = [ 10, 6, 2, 3, 4,11 ];
       case 8
           neighbors = [ 10,11, 4, 0, 5, 9 ];
       case 9
           neighbors = [ 11, 8, 5, 1, 6,10 ];
       case 10
           neighbors = [  8, 9, 6, 2, 7,11 ];
       case 11
           neighbors = [  9,10, 7, 3, 4, 8 ];  
   end
   
   return
   
end

[x2pix, y2pix] = xy2pix();

nsidesq = npix/12;
face_num = fix(ipix1/nsidesq);
localmagic1 = (nsidesq-1)/3;
localmagic2 = localmagic1*2;

ipf = mod(ipix1, nsidesq);

[ix, iy] = pix2xy_nest(nside, ipf);

ixm = ix-1;
ixp = ix+1;
iym = iy-1;
iyp = iy+1;

neigh = 8;
icase = 0;

if ipf == localmagic2
    icase = 5;
elseif ipf == (nsidesq -1)
    icase = 6;
elseif ipf == 0
    icase = 7;
elseif ipf == localmagic1
    icase = 8;
elseif icase == 0
    if (ipf & localmagic1) == localmagic1
        icase = 1;
    elseif ( ipf & localmagic1) == 0
        icase = 1;
    elseif (ipf & localmagic2) == localmagic2
        icase = 3;
    elseif (ipf & localmagic2) == 0
        icase == 4;
    end
    
    if icase == 0
       vx = [ixm, ixm, ixm, ix , ixp, ixp, ixp, ix];
       vy = [iym, iy , iyp, iyp, iyp, iy , iym, iym];
       [neighbors] = xy2pix_nest(nside, vx, vy, face_num);
       neighbors = neighbors';
       return
    end
end

ia = fix(face_num/4);
ib = fix(mod(face_num, 4));
ibp = fix(mod(ib+1, 4));
ibm = fix(mod(ib-1, 4));
ib2 = 2*ib;

if ia == 0
    switch icase 
        case 1
            other_face = ibp;
            n_8 = xy2pix_nest(nside, ix, iym, face_num);
            n_1 = xy2pix_nest(nside, ixm, iym, face_num);
            n_2 = xy2pix_nest(nside, ixm, iy, face_num);
            n_3 = xy2pix_nest(nside, ixm, iyp, face_num);
            n_4 = xy2pix_nest(nside, ix, iyp, face_num);
            
            ipo = fix(mod(swapbytes(ipf), nsidesq));
            [ixo, iyo] = pix2xy_nest(nside, ipo);
            n_5 = xy2pix_nest(nside, ixo+1, iyo, other_face);
            n_6 = other_face * nsidesq + ipo;
            n_7 = xy2pix_nest(nside, ixo-1, iyo, other_face);
        case 2
            other_face = 4+ib;
            ipo = fix(mod(swapbytes(ipf), nsidesq));
            [ixo, iyo] = pix2xy_nest(nside, ipo);
            n_1 = xy2pix(nside, ixo, iyo-1, other_face);
            n_2 = other_face * nsidesq + ipo;
            n_3 = xy2pix_nest(nside, ixo, iyo+1, other_face);
            
            n_8 = xy2pix_nest(nside, ix, iym, face_num);
            n_7 = xy2pix_nest(nside, ixm, iyp, face_num);
            n_6 = xy2pix_nest(nside, ixp, iy, face_num);
            n_5 = xy2pix_nest(nside, ixp, iyp, face_num);
            n_4 = xy2pix_nest(nside, ix, iyp, face_num);  
        case 3
            other_face = ibm;
            ipo = fix(mod(swapbytes(ipf), nsidesq));
            [ixo, iyo] = pix2xy_nest(nside, ipo);
            n_3 = xy2pix(ixo, iyo-1, other_face);
            n_4 = other_face * nsidesq + ipo;
            n_5 = xy2pix_nest(nside, ixo, iyo+1, other_face);
            
            n_1 = xy2pix_nest(nside, ixm, iym, face_num);
            n_2 = xy2pix_nest(nside, ixm, iy, face_num);
            n_8 = xy2pix_nest(nside, ix, iym, face_num);
            n_7 = xy2pix_nest(nside, ixp, iym, face_num);
            n_6 = xy2pix_nest(nside, ixp, iy, face_num);
        case 4
            other_face = 4+ibp;
            n_2 = xy2pix(nside, ixm, iy, face_num);
            n_3 = xy2pix_nest(nside, ixm, iyp, face_num); 
            n_4 = xy2pix_nest(nside, ix, iyp, face_num);
            n_5 = xy2pix_nest(nside, ixp, iyp, face_num); 
            n_6 = xy2pix_nest(nside, ixp, iy, face_num);
            
            ipo = fix(mod(swapbytes(ipf), nsidesq));
            [ixo, iyo] = pix2xy_nest(nside, ipo);
            n_7 = xy2pix_nest(nside, ixo+1, iyo, other_face);
            n_8 = other_face * nsidesq + ipo;
            n_1 = xy2pix_nest(nside, ixo-1, iyo, other_face);
        case 5
            neighbors = 7;
            other_face = 4+ib;
            n_2 = other_face*nsidesq+nsidesq-1;
            n_1 = n_2-2;
            other_face = ibm;
            n_3 = other_face*nsidesq+localmagic1;
            n_4 = n_3+2;
            n_5 = ipix1+1;
            n_6 = ipix1-1;
            n_7 = ipix1-2;
        case 6
            n_1 = ipix1-3;
            n_2 = ipix1-1;
            n_8 = ipix1-2;
            other_face = ibm;
            n_4 = other_face*nsidesq+nsidesq-1;
            n_3 = n_4-2;
            other_face = ib2;
            n_5 = other_face*nsidesq+nsidesq-1;
            other_face = ibp;
            n_6 = other_face*nsidesq+nsidesq-1;
            n_7 = n_6-1;
        case 7
            other_face = 8+ib;
            n_1 =other_face*nsidesq+nsidesq-1;
            other_face=4+ib;
            n_2 = other_face*nsidesq+localmagic1;
            n_3 = n_2+2;
            n_4 = ipix1+2;
            n_5 = ipix1+3;
            n_6 = ipix1+1;
            other_face = 4+ibp;
            n_8 = other_face*nsidesq+localmagic2;
            n_7 = n_8+1;
        case 8
            neigh = 7;
            n_2 = ipix1-1;
            n_3 = ipix1+1;
            n_4 = ipix1+2;
            other_face = ibp;
            n_6 = other_face*nsidesq+localmagic2;
            n_5 = n_6+1;
            other_face = 4+ibp;
            n_7 = other_face*nsidesq+nsidesq-1;
            n_1 = n_7-1;     
    end
end

if ia == 1
    switch icase 
        case 1
            other_face = ib;
            n_8 = xy2pix_nest(nside, ix, iym, face_num);
            n_1 = xy2pix_nest(nside, ixm, iym, face_num);
            n_2 = xy2pix_nest(nside, ixm, iy, face_num);
            n_3 = xy2pix_nest(nside, ixm, iyp, face_num);
            n_4 = xy2pix_nest(nside, ix, iyp, face_num);
            
            ipo = fix(mod(swapbytes(ipf), nsidesq));
            [ixo, iyo] = pix2xy_nest(nside, ipo);
            n_5 = xy2pix_nest(nside, ixo, iyo+1, other_face);
            n_6 = other_face * nsidesq + ipo;
            n_7 = xy2pix_nest(nside, ixo, iyo-1, other_face); %
        case 2%
            other_face = 8+ibm;
            ipo = fix(mod(swapbytes(ipf), nsidesq));
            [ixo, iyo] = pix2xy_nest(nside, ipo);
            n_1 = xy2pix(nside, ixo, iyo-1, other_face);
            n_2 = other_face * nsidesq + ipo;
            n_3 = xy2pix_nest(nside, ixo, iyo+1, other_face);
            
            n_8 = xy2pix_nest(nside, ix, iym, face_num);
            n_7 = xy2pix_nest(nside, ixm, iyp, face_num);
            n_6 = xy2pix_nest(nside, ixp, iy, face_num);
            n_5 = xy2pix_nest(nside, ixp, iyp, face_num);
            n_4 = xy2pix_nest(nside, ix, iyp, face_num);  
        case 3 %
            other_face = ibm;
            ipo = fix(mod(swapbytes(ipf), nsidesq));
            [ixo, iyo] = pix2xy_nest(nside, ipo);
            n_3 = xy2pix(ixo-1, iyo, other_face);
            n_4 = other_face * nsidesq + ipo;
            n_5 = xy2pix_nest(nside, ixo+1, iyo, other_face);
            
            n_1 = xy2pix_nest(nside, ixm, iym, face_num);
            n_2 = xy2pix_nest(nside, ixm, iy, face_num);
            n_8 = xy2pix_nest(nside, ix, iym, face_num);
            n_7 = xy2pix_nest(nside, ixp, iym, face_num);
            n_6 = xy2pix_nest(nside, ixp, iy, face_num);
        case 4 %
            other_face = 8 + ib;
            n_2 = xy2pix(nside, ixm, iy, face_num);
            n_3 = xy2pix_nest(nside, ixm, iyp, face_num); 
            n_4 = xy2pix_nest(nside, ix, iyp, face_num);
            n_5 = xy2pix_nest(nside, ixp, iyp, face_num); 
            n_6 = xy2pix_nest(nside, ixp, iy, face_num);
            
            ipo = fix(mod(swapbytes(ipf), nsidesq));
            [ixo, iyo] = pix2xy_nest(nside, ipo);
            n_7 = xy2pix_nest(nside, ixo+1, iyo, other_face);
            n_8 = other_face * nsidesq + ipo;
            n_1 = xy2pix_nest(nside, ixo-1, iyo, other_face);
        case 5
            other_face = 8+ibm;
            n_2 = other_face*nsidesq+nsidesq-1;
            n_1 = n_2-2;
            other_face = 4+ibm;
            n_3 = other_face*nsidesq+localmagic1;
            other_face = ibm;
            n_4 = other_face*nsidesq;
            n_5 = n_4+1;
            n_6 = ipix1+1;
            n_7 = ipix1-1;
            n_8 = ipix1-2
        case 6 %
            neighb = 7;
            n_1 = ipix1-3;
            n_2 = ipix1-1;
            other_face = 0+ibm;
            n_4 = other_face*nsidesq+localmagic1;
            n_3 = n_4-1;
            other_face = ib;
            n_5 = other_face*nsidesq+localmagic2;
            n_6 = n_5-2;
            n_7 = ipix1-2;
        case 7
            neigh = 7;
            other_face = 8+ibm; 
            n_1 = other_face*nsidesq+localmagic1;
            n_2 = n_1+2;
            n_3 = ipix1+2;
            n_4 = ipix1+3;
            n_5 = ipix1+1;
            other_face = 8+ib;
            n_7 = other_face*nsidesq+localmagic2;
            n_6 = n_7+1;
        case 8
            other_face = 8+ib;
            n_8 = other_face*nsidesq+nsidesq-1;
            n_1 = n_8-1;
            n_2 = ipix1-1;
            n_3 = ipix1+1;
            n_4 = ipix1+2;
            other_face = ib;
            n_6 = other_face*nsidesq;
            n_5 = n_6+2;
            other_face = 4+ibp;
            n_7 = other_face*nsidesq+localmagic2;   
    end  
end

if ia == 2
    switch icase 
        case 1
            other_face = 4+ibp;
            n_8 = xy2pix_nest(nside, ix, iym, face_num);
            n_1 = xy2pix_nest(nside, ixm, iym, face_num);
            n_2 = xy2pix_nest(nside, ixm, iy, face_num);
            n_3 = xy2pix_nest(nside, ixm, iyp, face_num);
            n_4 = xy2pix_nest(nside, ix, iyp, face_num);
            
            ipo = fix(mod(swapbytes(ipf), nsidesq));
            [ixo, iyo] = pix2xy_nest(nside, ipo);
            n_5 = xy2pix_nest(nside, ixo, iyo+1, other_face);
            n_6 = other_face * nsidesq + ipo;
            n_7 = xy2pix_nest(nside, ixo, iyo-1, other_face); %
        case 2%
            other_face = 8+ibm;
            ipo = fix(mod(swapbytes(ipf), nsidesq));
            [ixo, iyo] = pix2xy_nest(nside, ipo);
            n_1 = xy2pix(nside, ixo-1, iyo, other_face);
            n_2 = other_face * nsidesq + ipo;
            n_3 = xy2pix_nest(nside, ixo+1, iyo, other_face);
            
            n_8 = xy2pix_nest(nside, ix, iym, face_num);
            n_7 = xy2pix_nest(nside, ixm, iyp, face_num);
            n_6 = xy2pix_nest(nside, ixp, iy, face_num);
            n_5 = xy2pix_nest(nside, ixp, iyp, face_num);
            n_4 = xy2pix_nest(nside, ix, iyp, face_num);  
        case 3 %
            other_face = 4+ib;
            ipo = fix(mod(swapbytes(ipf), nsidesq));
            [ixo, iyo] = pix2xy_nest(nside, ipo);
            n_3 = xy2pix(ixo-1, iyo, other_face);
            n_4 = other_face * nsidesq + ipo;
            n_5 = xy2pix_nest(nside, ixo+1, iyo, other_face);
            
            n_1 = xy2pix_nest(nside, ixm, iym, face_num);
            n_2 = xy2pix_nest(nside, ixm, iy, face_num);
            n_8 = xy2pix_nest(nside, ix, iym, face_num);
            n_7 = xy2pix_nest(nside, ixp, iym, face_num);
            n_6 = xy2pix_nest(nside, ixp, iy, face_num);
        case 4 %
            other_face = 8 + ibp;
            n_2 = xy2pix(nside, ixm, iy, face_num);
            n_3 = xy2pix_nest(nside, ixm, iyp, face_num); 
            n_4 = xy2pix_nest(nside, ix, iyp, face_num);
            n_5 = xy2pix_nest(nside, ixp, iyp, face_num); 
            n_6 = xy2pix_nest(nside, ixp, iy, face_num);
            
            ipo = fix(mod(swapbytes(ipf), nsidesq));
            [ixo, iyo] = pix2xy_nest(nside, ipo);
            n_7 = xy2pix_nest(nside, ixo, iyo+1, other_face);
            n_8 = other_face * nsidesq + ipo;
            n_1 = xy2pix_nest(nside, ixo, iyo-1, other_face);
        case 5
            neigh = 7;
            other_face = 8+ibm;
            n_2 = other_face*nsidesq+localmagic1;
            n_1 = n_2-1;
            other_face = 4+ib;
            n_3 = other_face*nsidesq;
            n_4 = n_3+1;
            n_5 = ipix1+1;
            n_6 = ipix1-1;
            n_7 = ipix1-2;
        case 6 %
            n_1 = ipix1-3;
            n_2 = ipix1-1;
            other_face = 4+ib;
            n_4 = other_face*nsidesq+localmagic1;
            n_3 = n_4-1;
            other_face= ib;
            n_5 = other_face*nsidesq;
            other_face = 4+ibp;
            n_6 = other_face*nsidesq+localmagic2;
            n_7 = n_6-2;
            n_8 = ipix1-2;
        case 7
            other_face = 8+ib2;
            n_1 = other_face*nsidesq;
            other_face = 8+ibm;
            n_2 = other_face*nsidesq;
            n_3 = n_2+1;
            n_4 = ipix1+2;
            n_5 = ipix1+3;
            n_6 = ipix1+1;
            other_face = 8+ibp;
            n_8 = other_face*nsidesq;
            n_7 = n_8+2;
        case 8
            neigh = 7;
            other_face = 8+ibp;
            n_7 = other_face*nsidesq+localmagic2;
            n_1 = n_7-2;
            n_2 = ipix1-1;
            n_3 = ipix1+1;
            n_4 = ipix1+2;
            other_face = 4+ibp;
            n_6 = other_face*nsidesq;
            n_5 = n_6+2;  
    end  
end


if neigh == 8
    neighbors = [n_1, n_2, n_3, n_4, n_5, n_6, n_7, n_8];
else
    neighbors = [n_1, n_2, n_3, n_4, n_5, n_6, n_7];
end

end