function [ xyzPoints ] = relocate( xyzPoints, stereoParams, camera )
%RELOCATE この関数の概要をここに記述
%   詳細説明をここに記述

t=stereoParams{1, 1}.TranslationOfCamera2;

switch camera
    case 1
    case 2
        xyzPoints(:,:,1)=xyzPoints(:,:,1)-t(1);
        xyzPoints(:,:,2)=xyzPoints(:,:,2)-t(2);
        xyzPoints(:,:,3)=xyzPoints(:,:,3)-t(3);
    otherwise
end

end

