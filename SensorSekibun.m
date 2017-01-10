%%
% センサーから得られたデータを積分するスクリプト

start=560;


alphas=alphas(1:300);
betas=betas(1:300);
gammas=gammas(1:300);

trapzX=cumtrapz(GyroX(start:start+1500));
trapzY=cumtrapz(GyroY(start:start+1500));
trapzZ=cumtrapz(GyroZ(start:start+1500));
sens_betas=trapzX*aveAccX*0.01+trapzY*aveAccY*0.01+trapzZ*aveAccZ*0.01;

time=1:300;
sens_betas=-sens_betas(1:5:1500);
plot(time,betas,time,sens_betas)