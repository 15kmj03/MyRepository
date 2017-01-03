function [ stereoParams,ROIBbox ] = modifyStereoParams( stereoParams,faceBbox )
%MODIFYSTEREOPARAMS この関数の概要をここに記述
%   詳細説明をここに記述

%% ステレオ画像のROIを設定
PP=stereoParams{1, 1}.CameraParameters1.PrincipalPoint;

y=faceBbox(2);
h=faceBbox(4);

xx=1;
yy=y-round(h/2);
ww=2047;
hh=y+round(h/2);

% 無効なインデックスを参照しないように調整
if yy<1
    yy=1;
end
if yy+hh>768
    hh=768-yy;
end

% 画像中心を含むように調整
if PP(2)<yy
    yy=floor(PP(2));
end

if PP(2)>yy+hh
    hh=ceil(pp(2)-yy);
end   

ROIBbox=[xx,yy,ww,hh];

%% ROIに合わせてステレオパラメーターを調整
params11 = toStruct(stereoParams{1, 1});
params12 = toStruct(stereoParams{1, 2});

params11.CameraParameters1.IntrinsicMatrix(3,2)=params11.CameraParameters1.IntrinsicMatrix(3,2)-(yy-1);
params11.CameraParameters2.IntrinsicMatrix(3,2)=params11.CameraParameters2.IntrinsicMatrix(3,2)-(yy-1);

params12.CameraParameters1.IntrinsicMatrix(3,2)=params12.CameraParameters1.IntrinsicMatrix(3,2)-(yy-1);
params12.CameraParameters2.IntrinsicMatrix(3,2)=params12.CameraParameters2.IntrinsicMatrix(3,2)-(yy-1);

stereoParamsL1R2 = stereoParameters(params11);
stereoParamsR1L2 = stereoParameters(params12);

stereoParams={stereoParamsL1R2,stereoParamsR1L2};
end

