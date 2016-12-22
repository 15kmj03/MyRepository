function [ xyzPoints ] = denoise( xyzPoints )
%DENOISE ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

%     % �m�C�Y����
Xdata=xyzPoints(:,:,1);
Ydata=xyzPoints(:,:,2);
Zdata=xyzPoints(:,:,3);

s=nansum(Zdata(:));
g=s/sum(sum(~isnan(Zdata)));
bw=g-100<Zdata&Zdata<g+100;

Xdata(~bw)=nan;
xyzPoints(:,:,1)=Xdata;

Ydata(~bw)=nan;
xyzPoints(:,:,2)=Ydata;

Zdata(~bw)=nan;
xyzPoints(:,:,3)=Zdata;

end

