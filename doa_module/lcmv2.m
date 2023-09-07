% lcmv算法，对接收方向放大，干扰方向减弱

clc;
clear;
M = 18; % 天线数
lambda = 10;
d = lambda / 2;
L = 1000;  %快拍数
thetas = [10];    % 期望信号入射角度
thetai = [-10 30]; % 干扰入射角度
n = [0:M-1]';
vs = exp(-1j * 2 * pi * n * d * sind(thetas) / lambda); % 信号方向向量
vn = exp(-1j * 2 * pi * n * d * sind(thetai) / lambda); % 干扰方向向量
f = 1600; % 载波频率
t = [0:L-1];
di = sin(2*pi*f*t/(8*f));    % 期望信号
vn1 = sin(2*pi*2 * f*t/(8*f));  % 干扰信号1 
vn2 = sin(2*pi*4 * f*t/(8*f));  % 干扰信号2 
A = [vs vn];
St = [di;vn1;vn2];
Xt = A*St + randn(M,L);   % 矩阵形式的公式
R_x = 1/L * (Xt * Xt');
R_x_inv = inv(R_x);
W_opt = R_x_inv * vs / (vs' * R_x_inv * vs);
% 测试此时的方向图
sita = 90 * [-1:0.001:1];
% 得到不同角度的方向矢量
v = exp(-1i*2*pi*n* d*sind(sita)/lambda);
B = abs(W_opt' * v);
plot(sita,db(B/max(B)));
xlabel('方位角/度')
ylabel('增益/dB')
hold on;
txt1 = '\leftarrow 增益信号方向10°';
txt2 = '\leftarrow 干扰信号方向-10°';
txt3 = '\leftarrow 干扰信号方向30°';
text(10,-13.14,txt1);
text(-10,-23.14,txt2);
text(30,-33.14,txt3);
plot(zeros(1,501)+10,-50:0.1:0,"--");
plot(zeros(1,501)-10,-50:0.1:0,"--");
plot(zeros(1,501)+30,-50:0.1:0,"--");