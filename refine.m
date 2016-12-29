function [ xyzPoints ] = refine( xyzPoints )
%REFINE この関数の概要をここに記述
%   詳細説明をここに記述

Xdata=xyzPoints(:,:,1);
Ydata=xyzPoints(:,:,2);
Zdata=xyzPoints(:,:,3);

% 標準偏差
S=nanstd(Zdata(:));
% 平均
M=nanmean(Zdata(:));

% 残す点群
bw=Zdata<M+S;

Xdata(~bw)=nan;
xyzPoints(:,:,1)=Xdata;

Ydata(~bw)=nan;
xyzPoints(:,:,2)=Ydata;

Zdata(~bw)=nan;
xyzPoints(:,:,3)=Zdata;

end

