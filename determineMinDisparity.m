function [ minDisparity ] = determineMinDisparity( grayL,grayR,bbox )
%DETERMINEDISPARITYRANGE �����̍ŏ��l�����肷��
%   ��1�����͍��J�����摜�A��2�����͉E�J�����摜�ŌŒ�
%
%   [ minDisparity ] = determineMinDisparity( grayL,grayR,bbox )
%
%   input
%   grayL : ���O���[�摜
%   grayR : �E�O���[�摜
%   bbox : bounding box
%
%   output
%   minDisparity : �����̍ŏ��l

disp=calculateDisparity(grayL,grayR,bbox);
minDisparity=disp-(8*4);
    
end

