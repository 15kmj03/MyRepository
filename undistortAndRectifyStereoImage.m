function [ imgL,imgR ] = undistortAndRectifyStereoImage( rawStereoImg,stereoParams,camera )
%UNDISTORTANDRECTIFYSTEREOIMAGE �X�e���I�摜�̘c�ݕ␳�ƕ��s�����s��
%
%   [ imgL, imgR ] = undistortAndRectifyStereoImage( rawStereoImg, stereoParamsL1R2 )
%
%   input
%   rawStereoImg : �X�e���I�摜
%   stereoParamsL1R2 : �X�e���I�J�����̃L�����u���[�V�����f�[�^
%   camera : �J�����ԍ�
%
%   output
%   imgL : �␳���ꂽ���J�����摜
%   imgR ; �␳���ꂽ�E�J�����摜
%


%% �X�e���I�摜�̘c�ݕ␳�ƕ��s��
% ����
[rawR,rawL] = splitStereoImage(rawStereoImg);

% �c�ݕ␳�ƕ��s��
switch camera
    case 1
        params=stereoParams{1};
        [imgL,imgR] = rectifyStereoImages(rawL, rawR, params, 'OutputView', 'valid');
    case 2
        params=stereoParams{2};
        [imgR,imgL] = rectifyStereoImages(rawR, rawL, params, 'OutputView', 'valid');
    otherwise
        disp('error')
        quit
end

end

