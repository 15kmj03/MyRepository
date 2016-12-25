function [ minDisparity ] = determineMinDisparity( grayL,grayR,bbox )
%DETERMINEDISPARITYRANGE この関数の概要をここに記述
%   詳細説明をここに記述
%
% 視差計算範囲 64
% disp-32 < disp < disp+32

disp=calculateDisparity(grayL,grayR,bbox);
minDisparity=disp-(8*4);
    
end

