close all
clear
clc

% グローバル座標系で左カメラの位置を原点とする
% すべての3次元復元結果は左カメラを原点として保存される

% フレームごとに処理の基準となるカメラを選択し、切り替える
% ヨー角度の符号は首を右に振る方向が正、左に振る方向が負
% ヨー角度が正...右カメラを基準とする
% ヨー角度が負...左カメラを基準とする

%% 前処理
% ループ処理の前に1度だけ実行する処理

% 動画読み込み
videoFileReader=vision.VideoFileReader('D:arai\1.avi','VideoOutputDataType','uint8');

% ステレオパラメーターの読み込み
load('stereoParams');

% 検出器の読み込み
frontalFaceDetector = vision.CascadeObjectDetector('ClassificationModel',...
    'FrontalFaceCART', 'MinSize',[200,200],'MaxSize',[400,400]);
profileFaceDetector = vision.CascadeObjectDetector('ClassificationModel',...
    'ProfileFace', 'MinSize',[200,200],'MaxSize',[400,400]);
eyeDetector = vision.CascadeObjectDetector('ClassificationModel',...
    'EyePairBig', 'MinSize',[11,45],'MaxSize',[400,400],'UseROI',true);

alpha_hat=zeros(200,1);
beta_hat=zeros(200,1);
gamma_hat=zeros(200,1);
% width=zeros(200,1);

% 最初に1フレームを読み込む
% 読み込みフレーム番号はループ処理直前でリセットされる
camera=1;
rawStereoImg=step(videoFileReader);
[imgL,imgR]=undistortAndRectifyStereoImage(rawStereoImg,stereoParams,camera);
grayL=rgb2gray(imgL);
grayR=rgb2gray(imgR);
videoSize=size(imgL);

% dispRangeを決定する
[dispRange,prevFaceBbox]=determineDisparityRange(grayL,grayR);
prevBbox=detectEyeBbox(grayL,grayR,eyeDetector,prevFaceBbox,camera);
if isempty(prevBbox)
    disp('error')
end

% 読み込みフレーム番号のリセット
videoFileReader.reset
frameIdx=0;

camera=2;

%% ループ処理
while 1
    % フレーム番号表示
    frameIdx=frameIdx+1;
    disp(frameIdx)
    
    % 1フレーム読み込み
    [rawStereoImg,EOF]=step(videoFileReader);
    
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
    
    % 3次元復元を行う領域を限定する
    bbox=detectEyeBbox(grayL,grayR,eyeDetector,faceBbox,camera);
    if isempty(bbox)
        continue
    end
    
    %%
    bbox=func(bbox,prevBbox(3),camera);
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
    %%
            
    % 視差計算
    dispMap=disparityBbox(grayL,grayR,bbox,dispRange,camera); % bbox??????????????
    
    
    
    % 座標を調整
    xyzPoints = reconstructScene(dispMap,stereoParams{camera});
    xyzPoints=relocate(xyzPoints,stereoParams,camera);
    
    
    % PointCloud
%         ptCloud=pointCloud(xyzPoints);
%         figure(1);
%         pcshow(ptCloud, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
%         title('ptCloud');
%         drawnow
    
    % ノイズ除去
    xyzPoints=denoise(xyzPoints);
    ptCloud=pointCloud(xyzPoints);
%     figure(1);
%     pcshow(ptCloud, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
%     title('ptCloud');
%     drawnow
    
    %% registration
    if frameIdx==1
        ptCloudScene=ptCloud;
        tform=affine3d;
    else
        fixed = pcdownsample(ptCloudScene, 'random', 0.1);
        moving = pcdownsample(ptCloud, 'random', 0.1);
        
        tform = pcregrigid(moving, fixed, 'Metric','pointToPlane','Extrapolate', true,'InitialTransform',tform);
        ptCloudAligned = pctransform(moving, tform);
        mergeSize=2;
%         ptCloudScene = pcmerge(ptCloudScene, ptCloudAligned, mergeSize);
        
        B=tform.T(1:3,1:3)';
        
        alpha_hat_=-atan(B(3,2)/B(3,3))/pi*180;
        beta_hat_=--asin(B(3,1))/pi*180;
        gamma_hat_=-atan(B(2,1)/B(1,1))/pi*180;
        
        alpha_hat(frameIdx)=alpha_hat_;
        beta_hat(frameIdx)=beta_hat_;
        gamma_hat(frameIdx)=gamma_hat_;
        
        if beta_hat_>0
            camera=1;
        else
            camera=2;
        end
    end
    %
    %
    %
    %
    %     %% 確認
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
    %         figure(2);
    %         pcshow(ptCloud, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
    %         title('ptCloud');
    %         drawnow
    %     %
    
%     
%         figure(1);
%         pcshow(ptCloudScene, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
%         title('ptCloudScene');
%         drawnow('limitrate')

figure(20)
plot(beta_hat)
drawnow
%     
    
    if EOF
        break
    end
end
%         figure(1);
%     pcshow(ptCloudScene, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
%     title('ptCloudScene');
%     drawnow('limitrate')
%
%     figure(2)
%     plot(beta_hat)
