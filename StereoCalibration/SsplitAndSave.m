% �X�e���I�摜��A����n���ǂݍ��݁A�������ĕۑ�����X�N���v�g

% �摜�̖���
n=10;

for idx=1:n
    % �t�@�C����
    idxnumber = num2str(idx);
    extension = '.png';
    loadFilename = ['raw',idxnumber,extension];
    saveFilename1=['R/',idxnumber,extension]
    saveFilename2=['L/',idxnumber,extension]

    % �ǂݍ���
    stereoImage = imread(loadFilename);

    % ����
    [img1,img2] = splitStereoImage(stereoImage);

    % �ۑ�
    imwrite(img1,saveFilename1);
    imwrite(img2,saveFilename2);
end