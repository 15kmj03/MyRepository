function [ disparity ] = calculateDisparity( grayL,grayR,bbox )
%CALCULATEDISPARITY 左カメラbbox領域の視差を計算する
%
%   [ disparity ] = calculateDisparity( grayL,grayR,bbox )
%
%   input
%   grayL : 左グレー画像
%   grayR : 右グレー画像
%   bbox : bounding box
%
%   output
%   disparity : 視差

%%
x=bbox(1);  % x
y=bbox(2);  % y
w=bbox(3);  % width
h=bbox(4);  % height

absdiff=zeros(1,x); % 差の総和を保存する為の変数

imgFace=bbox2ROI(grayL,bbox);  % bbox領域を切り出す

for i=1:x
    bboxROI=[i,y,w,h];                              % ROIの設定
    ROI=bbox2ROI(grayR,bboxROI);                    % ROI領域を切り出す
    absdiff(i)=sum(sum(imabsdiff(imgFace,ROI)));    % 差の総和を計算
end

[~,I]=min(absdiff); % 最小のインデックスを探す

disparity=abs(x-I);

% figure(1)
% plot(absdiff)
% drawnow

% figure
% bbox=[I,y,w,h];
% ROI=bbox2ROI(grayL,bbox);
% imshow(ROI)

end

