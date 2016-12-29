function [ xyzPoints ] = denoise( xyzPoints )
%DENOISE 点群のノイズを除去する
%   Z座標の標準偏差を計算し、-2sigamから+2sigma以内の点だけを残す
%
%   [ xyzPoints ] = denoise( xyzPoints )
%
%   input
%   xyzPoints : 3次元座標
%
%   output
%   xyzPoints : 3次元座標

%%
Xdata=xyzPoints(:,:,1);
Ydata=xyzPoints(:,:,2);
Zdata=xyzPoints(:,:,3);

% 標準偏差
S=nanstd(Zdata(:));
% 平均
M=nanmean(Zdata(:));

% 残す点群
bw=M-2*S<Zdata&Zdata<M+2*S;

Xdata(~bw)=nan;
xyzPoints(:,:,1)=Xdata;

Ydata(~bw)=nan;
xyzPoints(:,:,2)=Ydata;

Zdata(~bw)=nan;
xyzPoints(:,:,3)=Zdata;

end

