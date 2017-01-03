function [ eyeBbox ] = detectEyeBbox( grayL,grayR,eyeDetector,faceBbox,camera )
%DETECTEYEBBOX 両目領域を検出する
%   eyeDetectorの'UseROI'をオプションを利用し、faceBbox領域内で検索を行う
%
%   [ eyeBbox ] = detectEyeBbox( grayL,grayR,eyeDetector,faceBbox,camera )
%
%   input
%   grayL : 左グレー画像
%   grayR : 右グレー画像
%   eyeDetector : 両目検出器
%   faceBbox : 顔領域
%   camera : カメラ番号
%
%   output
%   eyeBbox : 両目領域

%%
switch camera
    case 1
        eyeBbox=step(eyeDetector,grayL,faceBbox);
        if ~isempty(eyeBbox)
            eyeBbox=eyeBbox(1,:);
        end
        
    case 2
        eyeBbox=step(eyeDetector,grayR,faceBbox);
        if ~isempty(eyeBbox)
            eyeBbox=eyeBbox(1,:);
        end
        
    otherwise
        error('error')
end

end

