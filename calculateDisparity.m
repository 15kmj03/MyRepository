function [ disparity ] = calculateDisparity( grayL,grayR,bbox )
%CALCULATEDISPARITY ���J����bbox�̈�̎������v�Z����
%
%   [ disparity ] = calculateDisparity( grayL,grayR,bbox )
%
%   input
%   grayL : ���O���[�摜
%   grayR : �E�O���[�摜
%   bbox : bounding box
%
%   output
%   disparity : ����

%%
x=bbox(1);  % x
y=bbox(2);  % y
w=bbox(3);  % width
h=bbox(4);  % height

absdiff=zeros(1,x); % ���̑��a��ۑ�����ׂ̕ϐ�

imgFace=bbox2ROI(grayL,bbox);  % bbox�̈��؂�o��

for i=1:x
    bboxROI=[i,y,w,h];                              % ROI�̐ݒ�
    ROI=bbox2ROI(grayR,bboxROI);                    % ROI�̈��؂�o��
    absdiff(i)=sum(sum(imabsdiff(imgFace,ROI)));    % ���̑��a���v�Z
end

[~,I]=min(absdiff); % �ŏ��̃C���f�b�N�X��T��

disparity=abs(x-I);

% figure(1)
% plot(absdiff)
% drawnow

% figure
% bbox=[I,y,w,h];
% ROI=bbox2ROI(grayL,bbox);
% imshow(ROI)

end

