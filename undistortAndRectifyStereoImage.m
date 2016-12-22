function [ imgL,imgR ] = undistortAndRectifyStereoImage( rawStereoImg,stereoParams,camera )
%UNDISTORTANDRECTIFYSTEREOIMAGE ステレオ画像の歪み補正と平行化を行う
%
%   [ imgL, imgR ] = undistortAndRectifyStereoImage( rawStereoImg, stereoParamsL1R2 )
%
%   input
%   rawStereoImg : ステレオ画像
%   stereoParamsL1R2 : ステレオカメラのキャリブレーションデータ
%   camera : カメラ番号
%
%   output
%   imgL : 補正された左カメラ画像
%   imgR ; 補正された右カメラ画像
%


%% ステレオ画像の歪み補正と平行化
% 分割
[rawR,rawL] = splitStereoImage(rawStereoImg);

% 歪み補正と平行化
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

