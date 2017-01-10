function [ alpha,beta,gamma ] = checkPose( alpha,beta,gamma,...
    alphas,betas,gammas,frameIdx )
%CHECKPOSE この関数の概要をここに記述
%   詳細説明をここに記述

if abs(alphas(frameIdx-1)-alpha)>10
    alpha=alphas(frameIdx-1);
end

if abs(betas(frameIdx-1)-beta)>10
    beta=betas(frameIdx-1);
end

if abs(gammas(frameIdx-1)-gamma)>10
    gamma=gammas(frameIdx-1);
end

end

