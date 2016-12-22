function [ dispRange,prevBbox ] = determineDisparityRange( grayL,grayR )
%DETERMINEDISPARITYRANGE ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

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

