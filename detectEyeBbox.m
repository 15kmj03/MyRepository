function [ eyeBbox ] = detectEyeBbox( grayL,grayR,eyeDetector,faceBbox,camera )
%DETECTEYEBBOX ���ڗ̈�����o����
%   eyeDetector��'UseROI'���I�v�V�����𗘗p���AfaceBbox�̈���Ō������s��
%
%   [ eyeBbox ] = detectEyeBbox( grayL,grayR,eyeDetector,faceBbox,camera )
%
%   input
%   grayL : ���O���[�摜
%   grayR : �E�O���[�摜
%   eyeDetector : ���ڌ��o��
%   faceBbox : ��̈�
%   camera : �J�����ԍ�
%
%   output
%   eyeBbox : ���ڗ̈�

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

