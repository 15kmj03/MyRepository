function [ alpha,beta,gamma ] = checkPose( alpha,beta,gamma,...
    alphas,betas,gammas,frameIdx )
%CHECKPOSE ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

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

