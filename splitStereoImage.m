function [ img1,img2 ] = splitStereoImage( stereoImage )
%SPLITSTEREOIMAGE �X�e���I�摜�����E�ɕ�������֐�
%
%   [ img1,img2 ] = splitStereoImage( stereoImage )
%
%   input
%   stereoImage : �X�e���I�摜
%
%   output
%   img1 : stereoImage��ō��ɂ���摜
%   img2 : stereoImage��ŉE�ɂ���摜

%% �X�e���I�摜�����E�ɕ���
[~, cols, ~] = size(stereoImage);           % �T�C�Y�m�F

% ����
img1 = stereoImage(:, 1:cols/2, :);
img2 = stereoImage(:, cols/2+1:cols, :);

end

