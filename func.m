function [ bbox ] = func( bbox, width,camera )
%FUNC この関数の概要をここに記述
%   詳細説明をここに記述

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

