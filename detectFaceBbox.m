function [ faceBbox ] = detectFaceBbox( grayL,grayR,frontalFaceDetector,profileFaceDetector,camera )
%DETECTFACE ��̈�����o����
%
%   [ faceBbox ] = detectFaceBbox( grayL,grayR,frontalFaceDetector,profileFaceDetector,camera )
%
%   input
%   grayL : ���O���[�摜
%   grayR : �E�O���[�摜
%   frontalFaceDetector : �猟�o��
%   profileFaceDetector : ���猟�o��
%   camera : �J�����ԍ�
%
%   output
%   faceBbox : ��̈� [x,y,width,height]


%% �猟�o
% �猟�o���s��
% �������o���ꂽ�ꍇ�A1�Ԗڂ�bbox�݂̂��̗p
% ������Ȃ������ꍇ�A���猟�o���s��

% �猟�o
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

