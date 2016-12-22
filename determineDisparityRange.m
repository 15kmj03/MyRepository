function [ dispRange,prevBbox ] = determineDisparityRange( grayL,grayR )
%DETERMINEDISPARITYRANGE この関数の概要をここに記述
%   詳細説明をここに記述

faceDetector = vision.CascadeObjectDetector('MinSize',[200,200],...
    'MaxSize',[400,400]);

bboxs=step(faceDetector,grayL);
if ~isempty(bboxs)
    bbox=bboxs(1,:);
    disp=calculateDisparity(grayL,grayR,bbox);
    dispRangeMin=disp-(8*3);
    dispRangeMax=disp+(8*5);
    dispRange=[dispRangeMin dispRangeMax];
    prevBbox=bbox;
end
    
end

