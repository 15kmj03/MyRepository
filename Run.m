close all
clear
clc

% グローバル座標系で左カメラの位置を原点とする
% 右手座標系

% フレームごとに処理の基準となるカメラを選択し、切り替える
% ヨー角度の符号は首を右に振る方向が正、左に振る方向が負
% ヨー角度が正...右カメラ画像を使用
% ヨー角度が負...左カメラ画像を使用

% windowsでvision.VideoFileReaderを使用してmp4ファイルを読み込むとき、
% matlab.video.read.UseHardwareAcceleration('off')を実行したほうが
% 高速になることがある

%% 前処理
% ループ処理の前に1度だけ実行する処理
% stereoParams{1, 1} : 1左カメラ 2右カメラ;
% stereoParams{1, 2} : 1右カメラ 2左カメラ;

% 動画読み込み
% videoFileReader=vision.VideoFileReader('D:tanimoto\4.avi',...
%     'VideoOutputDataType', 'uint8');
% videoFileReader=vision.VideoFileReader('D:1226\30deg\tutiya\1.avi',...
%     'VideoOutputDataType', 'uint8');
videoFileReader=vision.VideoFileReader('F:\kameyama\5.mp4',...
    'VideoOutputDataType', 'uint8');

% ステレオパラメーター読み込み
load('stereoParams');

% 検出器読み込み
frontalFaceDetector = vision.CascadeObjectDetector('ClassificationModel',...
    'FrontalFaceCART', 'MinSize', [200,200], 'MaxSize', [400,400]);

frameIdx=0;

while 1
    
    
    % 最初に1フレームを読み込み、点群を得る
    [rawStereoImg, EOF] = step(videoFileReader);
    frameIdx = frameIdx+1;
    disp(frameIdx)
    
    camera = 1;
    % ステレオ画像の歪み補正と平行化
    [imgL, imgR] = undistortAndRectifyStereoImage(rawStereoImg,...
        stereoParams, camera);
    
    % グレースケール変換
    grayR = rgb2gray(imgR);
    grayL = rgb2gray(imgL);
    
    % 顔検出
    faceBbox = detectFaceBbox(grayL,frontalFaceDetector);
    if isempty(faceBbox)
        continue
    end
    
    % minDisparityの決定
    minDisparity = determineMinDisparity(grayL, grayR, faceBbox);
    
    
    % 3次元復元を行う領域を決定する
    bbox(1)=faceBbox(1)-round(faceBbox(3)/2);
    bbox(2)=faceBbox(2)+round(faceBbox(4)*0.2);
    bbox(3)=faceBbox(3)*2;
    bbox(4)=round(faceBbox(4)*0.8);
    
    
    % bbox領域の視差計算
    dispMap = disparityBbox(grayL, grayR, bbox, minDisparity, camera);
    
    % 3次元座標に変換
    xyzPoints = reconstructScene(dispMap, stereoParams{camera});
    
    %     n=3;
    %     xx=zeros(1,n*2);
    %     yy=zeros(1,n*2);
    %
    %     h=floor((bbox(4)+1)/n)-1;
    %     yy(1)=bbox(2);
    %     yy(2)=yy(1)+h;
    %     yy(3)=yy(2)+1;
    %     yy(4)=yy(3)+h;
    %     yy(5)=yy(4)+1;
    %     yy(6)=bbox(2)+bbox(4);
    %     xx(1)=bbox(1);
    %     xx(2)=faceBbox(1)-1;
    %     xx(3)=faceBbox(1);
    %     xx(4)=faceBbox(1)+faceBbox(3);
    %     xx(5)=faceBbox(1)+faceBbox(3)+1;
    %     xx(6)=bbox(1)+bbox(3);
    %
    %     xyz=cell(3,3);
    %     xyz{1,1}=xyzPoints(yy(1):yy(2),xx(1):xx(2),:);
    %     xyz{1,2}=xyzPoints(yy(1):yy(2),xx(3):xx(4),:);
    %     xyz{1,3}=xyzPoints(yy(1):yy(2),xx(5):xx(6),:);
    %     xyz{2,1}=xyzPoints(yy(3):yy(4),xx(1):xx(2),:);
    %     xyz{2,2}=xyzPoints(yy(3):yy(4),xx(3):xx(4),:);
    %     xyz{2,3}=xyzPoints(yy(3):yy(4),xx(5):xx(6),:);
    %     xyz{3,1}=xyzPoints(yy(5):yy(6),xx(1):xx(2),:);
    %     xyz{3,2}=xyzPoints(yy(5):yy(6),xx(3):xx(4),:);
    %     xyz{3,3}=xyzPoints(yy(5):yy(6),xx(5):xx(6),:);
    %
    %     pt=cell(3,3);
    %     for i=1:n
    %         for j=1:n;
    %             pt{i,j}=pointCloud(xyz{i,j});
    %         end
    %     end
    %
    %     for i=1:9
    %         figure(i);
    %         pcshow(pt{i}, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
    %         title('ptCloud');
    %         drawnow
    %     end
    
    n=5;
    yy=zeros(1,n*2);    
    h=floor((bbox(4)+1)/n)-1;
    yy(1)=bbox(2);
    yy(2)=yy(1)+h;
    yy(3)=yy(2)+1;
    yy(4)=yy(3)+h;
    yy(5)=yy(4)+1;
    yy(6)=yy(5)+h;
    yy(7)=yy(6)+1;
    yy(8)=yy(7)+h;
    yy(9)=yy(8)+1;
    yy(10)=bbox(2)+bbox(4);
    xyz=cell(5,1);
    xyz{1,1}=xyzPoints(yy(1):yy(2),bbox(1):bbox(1)+bbox(3),:);
    xyz{2,1}=xyzPoints(yy(3):yy(4),bbox(1):bbox(1)+bbox(3),:);
    xyz{3,1}=xyzPoints(yy(5):yy(6),bbox(1):bbox(1)+bbox(3),:);
    xyz{4,1}=xyzPoints(yy(7):yy(8),bbox(1):bbox(1)+bbox(3),:);
    xyz{5,1}=xyzPoints(yy(9):yy(10),bbox(1):bbox(1)+bbox(3),:);
    pt=cell(5,1);
    
    for i=1:n
        pt{i,1}=pointCloud(xyz{i,1});
    end
    
    for i=1:n
        figure(i);
        pcshow(pt{i}, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
        title('ptCloud');
        drawnow
    end
    
    for i=1:n
        x=xyz{i,1}(:,:,1);
        z=xyz{i,1}(:,:,3);
        A=[x(:),z(:)];
        A(:,1)=floor(A(:,1));
        B=A(:,1);
        C=A(:,2);

        figure(5+i);
boxplot(C,B)
    end
    
    % ptCloudに変換
    ptCloud = pointCloud(xyzPoints);
    figure(99);
    pcshow(ptCloud, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
    title('ptCloud');
    drawnow
    
    if EOF
        break
    end
    
end

