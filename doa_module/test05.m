c = 3e8;
freq = 10e9;
lambda = c/freq;    % 波长
k = 2*pi/lambda;    % 波数
%%% 阵列参数
N = 10;                 % 阵元数量
d = 0.5*lambda;         % 阵元间隔 
z = (0:d:(N-1)*d)';     % 阵元坐标分布
%%% 信号源参数
phi = [30]'*pi/180;   % 来波方向
M = length(phi);                % 信号源数目
%%% 仿真参数
SNR = 10;             % 信噪比(dB)
K = 1000;     % 采样点数

%% 阵列接收信号仿真模拟
S = exp(1j*k*z*sin(phi'));          % 流型矩阵
Alpha = randn(M, K);         % 输入信号
X = S*Alpha;                        % 阵列接收信号
X1 = awgn(X, SNR, 'measured');      % 加载高斯白噪声

[~,MUSICMap]=MusicMethod(X1,N,d,lambda);
Angle = linspace(-180,180,3601);
plot(Angle,MUSICMap);
xlim([-90,90]);
xlabel('归一化对数谱/dB');
ylabel('到达角/°');