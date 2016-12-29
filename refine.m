function [ xyzPoints ] = refine( xyzPoints )
%REFINE ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

Xdata=xyzPoints(:,:,1);
Ydata=xyzPoints(:,:,2);
Zdata=xyzPoints(:,:,3);

% �W���΍�
S=nanstd(Zdata(:));
% ����
M=nanmean(Zdata(:));

% �c���_�Q
bw=Zdata<M+S;

Xdata(~bw)=nan;
xyzPoints(:,:,1)=Xdata;

Ydata(~bw)=nan;
xyzPoints(:,:,2)=Ydata;

Zdata(~bw)=nan;
xyzPoints(:,:,3)=Zdata;

end

