function [ dispBbox ] = determineDispBbox( faceBbox,eyeBbox, width, camera,...
    imageSize)
%DETERMINEDISPBBOX dispBboxを決定する
% 
%   [ dispBbox ] = determineDispBbox( faceBbox,eyeBbox, width, camera )
% 
%   input
%   faceBbox:顔領域
%   eyeBbox: 両目領域
%   width:1フレームで検出された顔領域の幅
%   camera;カメラ番号
%   imageSize:画像サイズ
%
%   output
%   dispBbox:視差計算を行う領域


%%
dispBbox=eyeBbox;

% 4
dispBbox(4)=faceBbox(4)-(eyeBbox(2)-faceBbox(2));

% 2
dispBbox(2)=dispBbox(2)-30;

switch camera
    case 1
        % 3
        dispBbox(3)=width;
        
    case 2
        % 1
        dispBbox(1)=dispBbox(1)+dispBbox(3)-width;
        
        % 3
        dispBbox(3)=width;
        
    otherwise
        error('error')
end

checkBbox(dispBbox,imageSize);

end

