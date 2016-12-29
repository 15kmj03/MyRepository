function [ minDisparity ] = determineMinDisparity( grayL,grayR,bbox )
%DETERMINEDISPARITYRANGE 視差の最小値を決定する
%   第1引数は左カメラ画像、第2引数は右カメラ画像で固定
%
%   [ minDisparity ] = determineMinDisparity( grayL,grayR,bbox )
%
%   input
%   grayL : 左グレー画像
%   grayR : 右グレー画像
%   bbox : bounding box
%
%   output
%   minDisparity : 視差の最小値

disp=calculateDisparity(grayL,grayR,bbox);
minDisparity=disp-(8*4);
    
end

