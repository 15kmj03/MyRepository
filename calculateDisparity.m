function [ disparity ] = calculateDisparity( grayL,grayR,bbox )
%CALCULATEDISPARITY ΆJbboxΜζΜ·πvZ·ι
%
%   [ disparity ] = calculateDisparity( grayL,grayR,bbox )
%
%   input
%   grayL : ΆO[ζ
%   grayR : EO[ζ
%   bbox : bounding box
%
%   output
%   disparity : ·

%%
x=bbox(1);  % x
y=bbox(2);  % y
w=bbox(3);  % width
h=bbox(4);  % height

absdiff=zeros(1,x); % ·ΜaπΫΆ·ιΧΜΟ

imgFace=bbox2ROI(grayL,bbox);  % bboxΜζπΨθo·

for i=1:x
    bboxROI=[i,y,w,h];                              % ROIΜέθ
    ROI=bbox2ROI(grayR,bboxROI);                    % ROIΜζπΨθo·
    absdiff(i)=sum(sum(imabsdiff(imgFace,ROI)));    % ·ΜaπvZ
end

[~,I]=min(absdiff); % Ε¬ΜCfbNXπT·

disparity=abs(x-I);

% figure(1)
% plot(absdiff)
% drawnow

% figure
% bbox=[I,y,w,h];
% ROI=bbox2ROI(grayL,bbox);
% imshow(ROI)

end

