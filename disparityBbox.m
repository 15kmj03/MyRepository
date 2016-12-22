function [ disparityMap ] = disparityBbox( grayL, grayR, bbox, minDisparity, camera )
%DISPARITYBBOX ???J??????????o????Bbox?????????????v?Z????
%
%   [ disparityMap ] = disparityBbox( imgL, imgR, bbox, dispRange )
%
%   input
%   imgL : ???J??????
%   imgR : ?E?J??????
%   bbox : ?????
%   dispRange : ?????v?Z???
%
%   output
%   disparityMap : ??????

x=bbox(1);  % x
y=bbox(2);  % y
w=bbox(3);  % width
h=bbox(4);  % height

disparityMap=ones(size(grayL))*-realmax('single');

bm = cv.StereoSGBM('BlockSize',5,'P1',100,'P2',1600,'UniquenessRatio',1);

switch camera
    case 1
        ROIL=grayL(y:y+h,1:x+w);
        ROIR=grayR(y:y+h,1:x+w);
        
        bm.MinDisparity=minDisparity;
        dispMapROI=bm.compute(ROIL, ROIR);
        dispMapROI=single(dispMapROI)/16;
        disparityMap(y:y+h,x:x+w)=dispMapROI(:,x:x+w);
        
    case 2
        ROIL=grayL(y:y+h,x:end);
        ROIR=grayR(y:y+h,x:end);
        
        bm.MinDisparity=-(minDisparity+64);
        dispMapROI=bm.compute(ROIR, ROIL);
        dispMapROI=single(dispMapROI)/16;
        disparityMap(y:y+h,x:x+w)=dispMapROI(:,1:1+w);
    otherwise
end

% disparityMap=medfilt2(disparityMap,[7,7]);
% figure(1)
% imshow(disparityMap,dispRange,'ColorMap',jet)

end
