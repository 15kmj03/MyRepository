function [  ] = takeSnapshotNtimes( n )
%TAKESNAPSHOTNTIMES n���摜���B�e����֐�
%
%   [  ] = takeSnapshotNtimes( n )

% PGR�J�����Ɛڑ����s��
vidObj=conectToPGRCamera();

% �v���r���[���J�n
preview(vidObj)

% n���摜���B�e����
for idx=1:n
    % �t�@�C����
    idxnumber = num2str(idx);
    extension = '.png';
    filename = ['raw',idxnumber,extension];
    
    % �L�[�{�[�h���̓}�E�X�̃C�x���g��҂�
    waitforbuttonpress
    
    % �摜���B�e
    snapshot = getsnapshot(vidObj);
    imwrite(snapshot,filename)
end

% �v���r���[���~
closepreview(vidObj)

% PGR�J�����Ƃ̐ڑ���؂�
disconectToPGRCamera(vidObj);

close all;
clear
end

