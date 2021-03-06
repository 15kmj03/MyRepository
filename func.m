function [ dispBbox ] = func( faceBbox,eyeBbox, width, camera,...
    imageSize)
%FUNC dispBboxπθ·ι
% 
%   [ dispBbox ] = func( faceBbox,eyeBbox, width, camera )
% 
%   input
%   faceBbox:ηΜζ
%   eyeBbox: ΌΪΜζ
%   width:1t[Εo³κ½ηΜζΜ
%   camera;JΤ
%   imageSize:ζTCY
%
%   output
%   dispBbox:·vZπs€Μζ


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

