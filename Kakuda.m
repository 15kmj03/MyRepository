function [ alpha,beta,gamma ] = Kakudo( B )
%KAKUDO Summary of this function goes here
%   Detailed explanation goes here

    alpha=-atan(B(3,2)/B(3,3))/pi*180;
    beta=--asin(B(3,1))/pi*180;
    gamma=-atan(B(2,1)/B(1,1))/pi*180;
    
end
