function [ xyzPoints ] = denoise( xyzPoints )
%DENOISE �_�Q�̃m�C�Y����������
%   Z���W�̕W���΍����v�Z���A-2sigam����+2sigma�ȓ��̓_�������c��
%
%   [ xyzPoints ] = denoise( xyzPoints )
%
%   input
%   xyzPoints : 3�������W
%
%   output
%   xyzPoints : 3�������W

%%
Xdata=xyzPoints(:,:,1);
Ydata=xyzPoints(:,:,2);
Zdata=xyzPoints(:,:,3);

% �W���΍�
S=nanstd(Zdata(:));
% ����
M=nanmean(Zdata(:));

% �c���_�Q
bw=M-2*S<Zdata&Zdata<M+2*S;

Xdata(~bw)=nan;
xyzPoints(:,:,1)=Xdata;

Ydata(~bw)=nan;
xyzPoints(:,:,2)=Ydata;

Zdata(~bw)=nan;
xyzPoints(:,:,3)=Zdata;

end

