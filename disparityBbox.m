function [ disparityMap ] = disparityBbox( grayL, grayR, bbox, minDisparity, camera )
%DISPARITYBBOX 左カメラ画像で検出されたBbox領域内の視差を計算する
%
%   [ disparityMap ] = disparityBbox( imgL, imgR, bbox, dispRange )
%
%   input
%   imgL : 左カメラ画像
%   imgR : 右カメラ画像
%   bbox : 顔領域
%   dispRange : 視差計算範囲
%
%   output
%   disparityMap : 視差画像


%%
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
        error('error')
end

% disparityMap=medfilt2(disparityMap,[7,7]);
% figure(1)
% imshow(disparityMap,dispRange,'ColorMap',jet)

end
