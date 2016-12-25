function [ xyzPoints ] = denoise2( xyzPoints )
%DENOISE �����������T�v���������L�q
%   �����������������L�q

%     % �m�C�Y����
Xdata=xyzPoints(:,:,1);
Ydata=xyzPoints(:,:,2);
Zdata=xyzPoints(:,:,3);

S=nanstd(Zdata(:));
M=nanmean(Zdata(:));

bw=M-2*S<data&Zdata<M+2*S;

Xdata(~bw)=nan;
xyzPoints(:,:,1)=Xdata;

Ydata(~bw)=nan;
xyzPoints(:,:,2)=Ydata;

Zdata(~bw)=nan;
xyzPoints(:,:,3)=Zdata;

end

