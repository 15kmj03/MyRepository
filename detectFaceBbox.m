function [ faceBbox ] = detectFaceBbox( grayL,grayR,frontalFaceDetector,profileFaceDetector,camera )
%DETECTFACE ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

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
        disp('error')
        quit
end

end

