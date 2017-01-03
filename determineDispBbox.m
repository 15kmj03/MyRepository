function [ dispBbox ] = determineDispBbox( faceBbox,eyeBbox, width, camera )
%DETERMINEDISPBBOX この関数の概要をここに記述
%   詳細説明をここに記述


dispBbox=eyeBbox;

% 4
dispBbox(4)=faceBbox(4)-(eyeBbox(2)-faceBbox(2));

% 2
dispBbox(2)=dispBbox(2)-30;
if dispBbox(2)<1
    dispBbox(2)=1;
end

switch camera
    case 1
        % 3
        dispBbox(3)=width;
        if dispBbox(1)+dispBbox(3)>1089
            dispBbox(3)=1089-dispBbox(1);
        end
        
    case 2
        % 1
        dispBbox(1)=dispBbox(1)+dispBbox(3)-width;
        if dispBbox(1)<1
            dispBbox(1)=1;
        end
        
        % 3
        dispBbox(3)=width;
        if dispBbox(1)+dispBbox(3)>1089
            dispBbox(3)=1089-dispBbox(1);
        end
        
    otherwise
        error('error')
end

end

