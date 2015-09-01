% �z�b�v�t�B�[���h�l�b�g���[�N�̃v���O����(�摜���o����������C���������摜��^���āC�o���Ă�摜�̒����玗�����̂��v���o��)
% �摜�f�[�^����͂ɂ���悤�ɕύX
% �������C�n���݂����Ɏ��Ԃ͂�����(�摜1������C��2���̏d�݌v�Z���Ԃ�����)
% image�֐���0�������ƔF�����Ă���Ȃ��̂ŁCImage_X�Ƃ����R�s�[������Ă�

%%%%% �p�����[�^�ݒ� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 150;    % �C���[�W�̑傫��(n*n�}�X)  �E���Ă����摜�f�[�^�����܂���150*150�������D�K�v�ɉ����ĕς���K�v����
s = 4;      % �L��������C���[�W�̐�
theta = 0.5;        % 臒l��
LOOP_num = 100000;    % �w�K���[�v��
show_num = 100;      % �`�ʂ���Ԋu��
init_flag = -1;      % �����z�u�̃t���O(0�Ȃ�Ί��S�����_���C-1�Ȃ��init.bmp, 1�`�́C�Ή������摜�f�[�^�Ƀm�C�Y�����������̂������f�[�^�Ƃ���)
noise_prob = 0.2;   % �m�C�Y�����m��(0�`1�͈̔́@���̊m���Ńm�C�Y�����������)
learning_flag = 1;  % �����p�����[�^(�Ɗw�K�f�[�^)�œ������ꍇ�C���ԒZ�k�̂��߂�0�ɂ���Ώd�݌v�Z���s��Ȃ��悤�ɂ���(�悭������Ȃ����1�̂܂܂�����Ȃ�)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �C���[�W���L��������
if learning_flag == 1
    w = zeros(n*n);     % �d�݂̏�����
    for image_num = 1:s,
        
        filename = strcat('Image_',num2str(image_num),'.bmp');      % bmp�t�@�C����
        A = imread(filename);                                       % �摜�f�[�^�̓ǂݍ���
        BW = im2bw(A,0.5);                                          % �摜�f�[�^�̓�l��
        
        X = zeros(n);           % X(i,j)�̏�����
        x = zeros(1,n*n);       % �񎟌��z�񂾂Ə������ɂ����̂ňꎟ���z�� x��p�ӂ���
        for i = 1:n,
            for j = 1:n,
                if BW(i,j) == 1
                    X(i,j) = 1;
                    x(n*(i-1)+j) = X(i,j);
                    
                else
                    X(i,j) = -1;
                    x(n*(i-1)+j) = X(i,j);
                end
            end
        end
        
        for i = 1:n*n,
            for j = 1:n*n,
                if i==j
                    w(i,j) = 0;
                    
                else
                    w(i,j) = w(i,j) + x(i)*x(j);
                end
            end
            fprintf('w(%d,%d) END\n',i,j);
        end
        
        if image_num == init_flag
            init = x;                       % �����f�[�^�̌�(�m�C�Y�O)�̃f�[�^���L��
        end
        
        Image_X = copy_array(n,X);
        colormap(gray);
        image(Image_X);
        pause(0.5);
    end
end

% �����l��ݒ肷��
if init_flag == 0       % ���S�����_���̏ꍇ
    x = zeros(1,n*n);
    for i = 1:n*n,
        temp = rand(1);
        if temp >= 0.5
            x(i) = 1;
        else
            x(i) = -1;
        end
    end
    
elseif init_flag == -1
    filename = 'init.bmp';
    A = imread(filename);                                       % �摜�f�[�^�̓ǂݍ���
    BW = im2bw(A,0.5);                                          % �摜�f�[�^�̓�l��
    x = zeros(1,n*n);
    for i = 1:n,
        for j = 1:n,
            if BW(i,j) == 1
                x(n*(i-1)+j) = 1;
                
            else
                x(n*(i-1)+j) = -1;
            end
        end
    end
    
else                    % Image_(init_flag).bmp�Ƀm�C�Y��������ꍇ
    x = init;
    for i = 1:n*n,
        temp = rand(1);
        if temp < noise_prob
            x(i) = x(i)*(-1);
        end
    end
end

% �������d�˂ăC���[�W��z�N����
for loop = 1:LOOP_num,
    
    i = randi(n*n);             % �m�[�h�������_���ɑI��
    y = 0;
    % �m�[�h�̏�Ԃ��v�Z
    for j = 1:n*n,
        y = y + w(i,j)*x(j);
    end
    y = y - theta;
    
    % �m�[�h�̏�Ԃɂ���ďo�͂�ύX����
    if y < 0
        x(i) = -1;
        
    elseif y > 0
        x(i) = 1;
        
    else
        x(i) = x(i);
    end
    
    % show_num���ɕ`�ʂ���
    if rem(loop,show_num) == 0
        fprintf('%d���[�v��\n',loop);
        X = zeros(n);
        for i = 1:n,
            for j = 1:n,
                X(i,j) = x(n*(i-1)+j);
            end
        end
        
        Image_X = copy_array(n,X);
        colormap(gray);
        image(Image_X);
        pause(0.05);
    end
end

% ������̏o�͂�`�ʂ���
fprintf('OUTPUT\n');
X = zeros(n);
for i = 1:n,
    for j = 1:n,
        X(i,j) = x(n*(i-1)+j);
    end
end
Image_X = copy_array(n,X);
colormap(gray);
image(Image_X);



