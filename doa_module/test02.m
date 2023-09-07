f1 = 15;        % 信号频率分量1，单位Hz
f2 = 50;
f3 = 60;

fc = 3e3;       % 载波频率
fs = 10e3;      % 采样频率

t = 0:1/fs:(0.5-1/fs);
N_point = length(t);

m = cos(2*pi*f1*t)+cos(2*pi*f2*t)+cos(2*pi*f3*t);   % 基带信号

m = m/max(abs(m));

s_AM = (1+m).*cos(2*pi*fc*t);   % 常规调幅信号

f = (0:1/N_point:(0.5-1/N_point))*fs;
pxx = 10*log10(abs(fft(s_AM))); % 调幅信号的频谱

z = hilbert(s_AM);	% 解析信号
baoluo = abs(z);

%% 绘图部分
figure(1)

plot(t, s_AM)
hold on
plot(t,1+m,LineWidth=3);
hold off

legend("幅度调制信号","包络")



% plot(f,pxx(1:N_point/2));
% xlabel("频率/Hz")


figure(2)
plot(t,m);
hold on
plot(t,baoluo);
hold off
legend("基带信号", "希尔伯特变换求出来的包络信号")