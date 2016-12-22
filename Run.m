close all
clear
clc

% �O���[�o�����W�n�ō��J�����̈ʒu�����_�Ƃ���
% ���ׂĂ�3�����������ʂ͍��J���������_�Ƃ��ĕۑ������

% �t���[�����Ƃɏ����̊�ƂȂ�J������I�����A�؂�ւ���
% ���[�p�x�̕����͎���E�ɐU����������A���ɐU���������
% ���[�p�x����...�E�J��������Ƃ���
% ���[�p�x����...���J��������Ƃ���

%% �O����
% ���[�v�����̑O��1�x�������s���鏈��

% ����ǂݍ���
videoFileReader=vision.VideoFileReader('D:arai\1.avi','VideoOutputDataType','uint8');

% �X�e���I�p�����[�^�[�̓ǂݍ���
load('stereoParams');

% ���o��̓ǂݍ���
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

% �ŏ���1�t���[����ǂݍ���
% �ǂݍ��݃t���[���ԍ��̓��[�v�������O�Ń��Z�b�g�����
camera=1;
rawStereoImg=step(videoFileReader);
[imgL,imgR]=undistortAndRectifyStereoImage(rawStereoImg,stereoParams,camera);
grayL=rgb2gray(imgL);
grayR=rgb2gray(imgR);
videoSize=size(imgL);

% dispRange�����肷��
[dispRange,prevFaceBbox]=determineDisparityRange(grayL,grayR);
prevBbox=detectEyeBbox(grayL,grayR,eyeDetector,prevFaceBbox,camera);
if isempty(prevBbox)
    disp('error')
end

% �ǂݍ��݃t���[���ԍ��̃��Z�b�g
videoFileReader.reset
frameIdx=0;

camera=2;

%% ���[�v����
while 1
    % �t���[���ԍ��\��
    frameIdx=frameIdx+1;
    disp(frameIdx)
    
    % 1�t���[���ǂݍ���
    [rawStereoImg,EOF]=step(videoFileReader);
    
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
    
    % 3�����������s���̈�����肷��
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
            
    % �����v�Z
    dispMap=disparityBbox(grayL,grayR,bbox,dispRange,camera); % bbox??????????????
    
    
    
    % ���W�𒲐�
    xyzPoints = reconstructScene(dispMap,stereoParams{camera});
    xyzPoints=relocate(xyzPoints,stereoParams,camera);
    
    
    % PointCloud
%         ptCloud=pointCloud(xyzPoints);
%         figure(1);
%         pcshow(ptCloud, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down')
%         title('ptCloud');
%         drawnow
    
    % �m�C�Y����
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
    %     %% �m�F
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
