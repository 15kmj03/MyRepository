function [ faceBbox ] = detectFaceBbox( grayL,grayR,frontalFaceDetector,profileFaceDetector,camera )
%DETECTFACE 顔領域を検出する
%
%   [ faceBbox ] = detectFaceBbox( grayL,grayR,frontalFaceDetector,profileFaceDetector,camera )
%
%   input
%   grayL : 左グレー画像
%   grayR : 右グレー画像
%   frontalFaceDetector : 顔検出器
%   profileFaceDetector : 横顔検出器
%   camera : カメラ番号
%
%   output
%   faceBbox : 顔領域 [x,y,width,height]


%% 顔検出
% 顔検出を行う
% 複数検出された場合、1番目のbboxのみを採用
% 見つからなかった場合、横顔検出を行う

% 顔検出
switch camera
    case 1
        faceBbox=step(frontalFaceDetector,grayL);
        
        if ~isempty(faceBbox)
            faceBbox=faceBbox(1,:);
        else
            faceBbox=step(profileFaceDetector,grayL);
            if ~isempty(faceBbox)
                faceBbox=faceBbox(1,:);
            end
        end
    case 2
        faceBbox=step(frontalFaceDetector,grayR);
        
        if ~isempty(faceBbox)
            faceBbox=faceBbox(1,:);
        else
            faceBbox=step(profileFaceDetector,grayR);
            if ~isempty(faceBbox)
                faceBbox=faceBbox(1,:);
            end
        end
    otherwise
        error('error')
end

end

