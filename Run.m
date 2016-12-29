close all
clear
clc

% グローバル座標系で左カメラの位置を原点とする
% すべての3次元復元結果は左カメラを原点とする

% フレームごとに処理の基準となるカメラを選択し、切り替える
% ヨー角度の符号は首を右に振る方向が正、左に振る方向が負
% ヨー角度が正...右カメラ画像を使用
% ヨー角度が負...左カメラ画像を使用

%% 前処理
% ループ処理の前に1度だけ実行する処理

% 動画読み込み
videoFileReader=vision.VideoFileReader('D:1226\30deg\arai\1.mp4','VideoOutputDataType','uint8');

% ステレオパラメーター読み込み
load('stereoParams');

% 検出器読み込み
frontalFaceDetector = vision.CascadeObjectDetector('ClassificationModel',...
    'FrontalFaceCART', 'MinSize',[200,200],'MaxSize',[400,400]);
profileFaceDetector = vision.CascadeObjectDetector('ClassificationModel',...
    'ProfileFace', 'MinSize',[200,200],'MaxSize',[400,400]);
eyeDetector = vision.CascadeObjectDetector('ClassificationModel',...
    'EyePairBig', 'MinSize',[11,45],'MaxSize',[400,400],'UseROI',true);

% データ保存用変数
alphas=zeros(200,1);
betas=zeros(200,1);
gammas=zeros(200,1);
maxYaw=0;
minYaw=0;

frameIdx=0;
camera=1;

% 最初に1フレームを読み込み、点群を得る
[rawStereoImg,EOF]=step(videoFileReader);
frameIdx=frameIdx+1;
disp(frameIdx)

% ステレオ画像の歪み補正と平行化
[imgL,imgR]=undistortAndRectifyStereoImage(rawStereoImg,stereoParams,camera);

% グレースケール変換
grayR=rgb2gray(imgR);
grayL=rgb2gray(imgL);

% 顔検出
faceBbox=detectFaceBbox(grayL,grayR,frontalFaceDetector,profileFaceDetector,camera);
if isempty(faceBbox)
    disp('error')
end

% 両目領域を検出
eyeBbox=detectEyeBbox(grayL,grayR,eyeDetector,faceBbox,camera);
if isempty(eyeBbox)
    disp('error')
end

% 3次元復元を行う領域を決定する
width=eyeBbox(3);
bbox=func(eyeBbox,width,camera);

% minDisparityの決定
minDisparity=determineMinDisparity(grayL,grayR,bbox);

% bbox領域の視差計算
dispMap=disparityBbox(grayL,grayR,bbox,minDisparity,camera);

% 3次元座標に変換
xyzPoints = reconstructScene(dispMap,stereoParams{camera});

xyzPoints=denoise(xyzPoints);

% カメラに応じて3次元座標を調整
xyzPoints=relocate(xyzPoints,stereoParams,camera);

% ptCloudに変換
ptCloud=pointCloud(xyzPoints);
%             figure(2);
%             pcshow(ptCloud, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
%             title('ptCloud');
%             drawnow

face0=ptCloud;
faceMaxYaw=pointCloud([NaN,NaN,NaN]);
faceMinYaw=pointCloud([NaN,NaN,NaN]);
face=face0;
f = pcdownsample(face, 'random', 0.1);

tform=affine3d;

% 角度
alphas(frameIdx)=0;
beat_hat(frameIdx)=0;
gammas(frameIdx)=0;



%% ループ処理
% 角度の推定を行う
while 1
    tic
    % 1フレーム読み込み
    [rawStereoImg,EOF]=step(videoFileReader);
    frameIdx=frameIdx+1;
    disp(frameIdx)
    
    % ステレオ画像の歪み補正と平行化
    [imgL,imgR]=undistortAndRectifyStereoImage(rawStereoImg,stereoParams,camera);

    % グレースケール変換
    grayR=rgb2gray(imgR);
    grayL=rgb2gray(imgL);
    
    % 顔検出
    faceBbox=detectFaceBbox(grayL,grayR,frontalFaceDetector,profileFaceDetector,camera);
    if isempty(faceBbox)
        continue
    end
    
    % 両目領域を検出
    eyeBbox=detectEyeBbox(grayL,grayR,eyeDetector,faceBbox,camera);
    if isempty(eyeBbox)
        continue
    end
    
    % 3次元復元を行う領域を決定する
    bbox=func(eyeBbox,width,camera);
    %     width(frameIdx)=bbox(3);
    %
    %     switch camera
    %         case 1
    %             roi=bbox2ROI(imgL,bbox);
    %         case 2
    %             roi=bbox2ROI(imgR,bbox);
    %     end
    %     figure(11)
    %     imshow(roi)
    
    % bbox領域の視差計算
    dispMap=disparityBbox(grayL,grayR,bbox,minDisparity,camera);
    
    % 3次元座標に変換
    xyzPoints = reconstructScene(dispMap,stereoParams{camera});
    xyzPoints=denoise(xyzPoints);
    
    % カメラに応じて3次元座標を調整
    xyzPoints=relocate(xyzPoints,stereoParams,camera);
    
    % ptCloudに変換
    ptCloud=pointCloud(xyzPoints);
    figure(1);
    pcshow(ptCloud, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
    title('ptCloud');
    drawnow
    
    
    %% registration
    mergeSize=2;
    
    new = pcdownsample(ptCloud, 'random', 0.1);
    tform = pcregrigid(new, f, 'Metric','pointToPlane','Extrapolate', true,'InitialTransform',tform,'MaxIterations',10);
    
    % 角度
    B=tform.T(1:3,1:3)';
    [alpha,beta,gamma]=Kakudo(B);
    alphas(frameIdx)=alpha;
    betas(frameIdx)=beta;
    gammas(frameIdx)=gamma;
    
        if beta>maxYaw
            faceMaxYaw = pctransform(ptCloud, tform);
            faceMearge=pcmerge(faceMaxYaw, faceMinYaw, mergeSize);
            face=pcmerge(face0, faceMearge, mergeSize);
            f = pcdownsample(face, 'random', 0.1);
            maxYaw=beta;
        end
        if beta<minYaw
            faceMinYaw = pctransform(ptCloud, tform);
            faceMearge=pcmerge(faceMaxYaw, faceMinYaw, mergeSize);
            face=pcmerge(face0, faceMearge, mergeSize);
            f = pcdownsample(face, 'random', 0.1);
            minYaw=beta;
        end
    
    if beta>0
        camera=1;
    else
        camera=2;
    end
    
    
    %% 確認
    %     % ROI
    %     figure(1)
    %     ROI=imgL(eyeBbox(2):faceBbox(2)+faceBbox(4),eyeBbox(1):eyeBbox(1)+eyeBbox(3),:);
    %     imshow(ROI)
    
    % dispMap
    %     figure(9)
    %     imshow(dispMap,dispRange,'Colormap',jet);
    %     colorbar
    %     title('dispMap')
    
    % ptCloud
%             figure(2);
%             pcshow(ptCloud, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
%             title('ptCloud');
%             drawnow
    
    
    if EOF
        break
    end
    toc
end

%% 後処理
figure(99);
pcshow(face, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
title('face');

figure(98);
pcshow(face0, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
title('face0');

figure(97);
pcshow(faceMaxYaw, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
title('faceMaxYaw');

figure(96);
pcshow(faceMinYaw, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
title('faceMinYaw');

figure(95)
plot(betas)
title('betas')
