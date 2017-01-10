function [ faceBbox,camera ] = detectFaceBbox( grayL,grayR,frontalFaceDetector,camera )
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
%         grayL=histeq(grayL);
        faceBbox=step(frontalFaceDetector,grayL);
        
        if ~isempty(faceBbox)
            faceBbox=faceBbox(1,:);
        else
%             grayR=histeq(grayR);
            faceBbox=step(frontalFaceDetector,grayR);
            
            if ~isempty(faceBbox)
                faceBbox=faceBbox(1,:);
                camera=2;
            end
        end
        
    case 2
%         grayR=histeq(grayR);
        faceBbox=step(frontalFaceDetector,grayR);
        
        if ~isempty(faceBbox)
            faceBbox=faceBbox(1,:);
        else
%             grayL=histeq(grayL);
            faceBbox=step(frontalFaceDetector,grayL);
            
            if ~isempty(faceBbox)
                faceBbox=faceBbox(1,:);
                camera=1;
            end
        end
        
    otherwise
        error('error')
end

end

