function [ bbox ] = func( bbox, width,camera )
%FUNC ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

switch camera
    case 1
        bbox(3)=width;
    case 2
        bbox(1)=bbox(1)+bbox(3)-width;
        bbox(3)=width;
        
        if bbox(1)<=0
            bbox(1)=1;
        end
    otherwise
        error('error')
end

end

