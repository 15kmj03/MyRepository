close all
clear
clc

% �O���[�o�����W�n�ō��J�����̈ʒu�����_�Ƃ���
% ���ׂĂ�3�����������ʂ͍��J���������_�Ƃ���

% �t���[�����Ƃɏ����̊�ƂȂ�J������I�����A�؂�ւ���
% ���[�p�x�̕����͎���E�ɐU����������A���ɐU���������
% ���[�p�x����...�E�J�����摜���g�p
% ���[�p�x����...���J�����摜���g�p

%% �O����
% ���[�v�����̑O��1�x�������s���鏈��

% ����ǂݍ���
videoFileReader=vision.VideoFileReader('D:1226\30deg\arai\1.mp4','VideoOutputDataType','uint8');

% �X�e���I�p�����[�^�[�ǂݍ���
load('stereoParams');

% ���o��ǂݍ���
frontalFaceDetector = vision.CascadeObjectDetector('ClassificationModel',...
    'FrontalFaceCART', 'MinSize',[200,200],'MaxSize',[400,400]);
profileFaceDetector = vision.CascadeObjectDetector('ClassificationModel',...
    'ProfileFace', 'MinSize',[200,200],'MaxSize',[400,400]);
eyeDetector = vision.CascadeObjectDetector('ClassificationModel',...
    'EyePairBig', 'MinSize',[11,45],'MaxSize',[400,400],'UseROI',true);

% �f�[�^�ۑ��p�ϐ�
alphas=zeros(200,1);
betas=zeros(200,1);
gammas=zeros(200,1);
maxYaw=0;
minYaw=0;

frameIdx=0;
camera=1;

% �ŏ���1�t���[����ǂݍ��݁A�_�Q�𓾂�
[rawStereoImg,EOF]=step(videoFileReader);
frameIdx=frameIdx+1;
disp(frameIdx)

% �X�e���I�摜�̘c�ݕ␳�ƕ��s��
[imgL,imgR]=undistortAndRectifyStereoImage(rawStereoImg,stereoParams,camera);

% �O���[�X�P�[���ϊ�
grayR=rgb2gray(imgR);
grayL=rgb2gray(imgL);

% �猟�o
faceBbox=detectFaceBbox(grayL,grayR,frontalFaceDetector,profileFaceDetector,camera);
if isempty(faceBbox)
    disp('error')
end

% ���ڗ̈�����o
eyeBbox=detectEyeBbox(grayL,grayR,eyeDetector,faceBbox,camera);
if isempty(eyeBbox)
    disp('error')
end

% 3�����������s���̈�����肷��
width=eyeBbox(3);
bbox=func(eyeBbox,width,camera);

% minDisparity�̌���
minDisparity=determineMinDisparity(grayL,grayR,bbox);

% bbox�̈�̎����v�Z
dispMap=disparityBbox(grayL,grayR,bbox,minDisparity,camera);

% 3�������W�ɕϊ�
xyzPoints = reconstructScene(dispMap,stereoParams{camera});

xyzPoints=denoise(xyzPoints);

% �J�����ɉ�����3�������W�𒲐�
xyzPoints=relocate(xyzPoints,stereoParams,camera);

% ptCloud�ɕϊ�
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

% �p�x
alphas(frameIdx)=0;
beat_hat(frameIdx)=0;
gammas(frameIdx)=0;



%% ���[�v����
% �p�x�̐�����s��
while 1
    tic
    % 1�t���[���ǂݍ���
    [rawStereoImg,EOF]=step(videoFileReader);
    frameIdx=frameIdx+1;
    disp(frameIdx)
    
    % �X�e���I�摜�̘c�ݕ␳�ƕ��s��
    [imgL,imgR]=undistortAndRectifyStereoImage(rawStereoImg,stereoParams,camera);

    % �O���[�X�P�[���ϊ�
    grayR=rgb2gray(imgR);
    grayL=rgb2gray(imgL);
    
    % �猟�o
    faceBbox=detectFaceBbox(grayL,grayR,frontalFaceDetector,profileFaceDetector,camera);
    if isempty(faceBbox)
        continue
    end
    
    % ���ڗ̈�����o
    eyeBbox=detectEyeBbox(grayL,grayR,eyeDetector,faceBbox,camera);
    if isempty(eyeBbox)
        continue
    end
    
    % 3�����������s���̈�����肷��
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
    
    % bbox�̈�̎����v�Z
    dispMap=disparityBbox(grayL,grayR,bbox,minDisparity,camera);
    
    % 3�������W�ɕϊ�
    xyzPoints = reconstructScene(dispMap,stereoParams{camera});
    xyzPoints=denoise(xyzPoints);
    
    % �J�����ɉ�����3�������W�𒲐�
    xyzPoints=relocate(xyzPoints,stereoParams,camera);
    
    % ptCloud�ɕϊ�
    ptCloud=pointCloud(xyzPoints);
    figure(1);
    pcshow(ptCloud, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
    title('ptCloud');
    drawnow
    
    
    %% registration
    mergeSize=2;
    
    new = pcdownsample(ptCloud, 'random', 0.1);
    tform = pcregrigid(new, f, 'Metric','pointToPlane','Extrapolate', true,'InitialTransform',tform,'MaxIterations',10);
    
    % �p�x
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
    
    
    %% �m�F
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

%% �㏈��
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
