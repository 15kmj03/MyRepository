function [ alpha,beta,gamma ] = checkPose( alpha,beta,gamma,...
    alphas,betas,gammas,frameIdx )
%CHECKPOSE この関数の概要をここに記述
%   詳細説明をここに記述

if abs(alphas(frameIdx-1)-alpha)>20
    alpha=alphas(frameIdx-1);
end

if abs(betas(frameIdx-1)-beta)>20
    beta=betas(frameIdx-1);
end

if abs(gammas(frameIdx-1)-gamma)>20
    gamma=gammas(frameIdx-1);
end

end

