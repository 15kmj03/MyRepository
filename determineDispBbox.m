function [ dispBbox ] = determineDispBbox( faceBbox,eyeBbox, width, camera,...
    imageSize)
%DETERMINEDISPBBOX dispBbox�����肷��
% 
%   [ dispBbox ] = determineDispBbox( faceBbox,eyeBbox, width, camera )
% 
%   input
%   faceBbox:��̈�
%   eyeBbox: ���ڗ̈�
%   width:1�t���[���Ō��o���ꂽ��̈�̕�
%   camera;�J�����ԍ�
%   imageSize:�摜�T�C�Y
%
%   output
%   dispBbox:�����v�Z���s���̈�


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

