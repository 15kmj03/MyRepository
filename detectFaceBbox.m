function [ faceBbox ] = detectFaceBbox( grayL,grayR,frontalFaceDetector,profileFaceDetector,camera )
%DETECTFACE この関数の概要をここに記述
%   詳細説明をここに記述

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
        disp('error')
        quit
end

end

