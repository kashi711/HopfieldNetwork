% ホップフィールドネットワークのプログラム(画像を覚えさせた後，何か似た画像を与えて，覚えてる画像の中から似たものを思い出す)
% 画像データを入力にするように変更
% ただし，馬鹿みたいに時間はかかる(画像1つあたり，約2分の重み計算時間がある)
% image関数が0をちゃんと認識してくれないので，Image_Xというコピーを作ってる

%%%%% パラメータ設定 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 150;    % イメージの大きさ(n*nマス)  拾ってきた画像データがたまたま150*150だった．必要に応じて変える必要あり
s = 4;      % 記憶させるイメージの数
theta = 0.5;        % 閾値θ
LOOP_num = 100000;    % 学習ループ回数
show_num = 100;      % 描写する間隔回数
init_flag = -1;      % 初期配置のフラグ(0ならば完全ランダム，-1ならばinit.bmp, 1～は，対応した画像データにノイズを混ぜたものを初期データとする)
noise_prob = 0.2;   % ノイズ混入確率(0～1の範囲　この確率でノイズが混入される)
learning_flag = 1;  % 同じパラメータ(と学習データ)で動かす場合，時間短縮のために0にすれば重み計算を行わないようにした(よく分からなければ1のままいじらない)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% イメージを記憶させる
if learning_flag == 1
    w = zeros(n*n);     % 重みの初期化
    for image_num = 1:s,
        
        filename = strcat('Image_',num2str(image_num),'.bmp');      % bmpファイル名
        A = imread(filename);                                       % 画像データの読み込み
        BW = im2bw(A,0.5);                                          % 画像データの二値化
        
        X = zeros(n);           % X(i,j)の初期化
        x = zeros(1,n*n);       % 二次元配列だと処理しにくいので一次元配列 xを用意する
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
            init = x;                       % 初期データの元(ノイズ前)のデータを記憶
        end
        
        Image_X = copy_array(n,X);
        colormap(gray);
        image(Image_X);
        pause(0.5);
    end
end

% 初期値を設定する
if init_flag == 0       % 完全ランダムの場合
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
    A = imread(filename);                                       % 画像データの読み込み
    BW = im2bw(A,0.5);                                          % 画像データの二値化
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
    
else                    % Image_(init_flag).bmpにノイズを混ぜる場合
    x = init;
    for i = 1:n*n,
        temp = rand(1);
        if temp < noise_prob
            x(i) = x(i)*(-1);
        end
    end
end

% 反復を重ねてイメージを想起する
for loop = 1:LOOP_num,
    
    i = randi(n*n);             % ノードをランダムに選ぶ
    y = 0;
    % ノードの状態を計算
    for j = 1:n*n,
        y = y + w(i,j)*x(j);
    end
    y = y - theta;
    
    % ノードの状態によって出力を変更する
    if y < 0
        x(i) = -1;
        
    elseif y > 0
        x(i) = 1;
        
    else
        x(i) = x(i);
    end
    
    % show_num毎に描写する
    if rem(loop,show_num) == 0
        fprintf('%dループ目\n',loop);
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

% 反復後の出力を描写する
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



