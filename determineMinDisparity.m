function [ minDisparity,prevBbox ] = determineMinDisparity( grayL,grayR )
%DETERMINEDISPARITYRANGE ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q
%
% �����v�Z�͈� 64
% disp-32 < disp < disp+32

faceDetector = vision.CascadeObjectDetector('MinSize',[200,200],...
    'MaxSize',[400,400]);

bboxs=step(faceDetector,grayL);
if ~isempty(bboxs)
    bbox=bboxs(1,:);
    disp=calculateDisparity(grayL,grayR,bbox);
    minDisparity=disp-(8*4);
    prevBbox=bbox;
end
    
end

