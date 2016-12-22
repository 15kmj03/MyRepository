function [ bbox ] = detectEyeBbox( grayL,grayR,eyeDetector,faceBbox,camera )
%DETECTEYEBBOX ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

switch camera
    case 1
        bbox=step(eyeDetector,grayL,faceBbox);
        if ~isempty(bbox)
            bbox=bbox(1,:);
            bbox=[bbox(1),bbox(2),bbox(3),bbox(4)+faceBbox(4)-(bbox(2)-faceBbox(2)+bbox(4))];
        end
    case 2
        bbox=step(eyeDetector,grayR,faceBbox);
        if ~isempty(bbox)
            bbox=bbox(1,:);
            bbox=[bbox(1),bbox(2),bbox(3),bbox(4)+faceBbox(4)-(bbox(2)-faceBbox(2)+bbox(4))];
        end
    otherwise
        disp('error')
        quit
end

end

