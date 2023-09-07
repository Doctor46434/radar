% 匹配滤波器输出

fs=2e7;   %采样率
T=10e-5;  %脉冲宽度
N=fs*T;   %采样点数
t=linspace(0,T,N);%横坐标
y=chirp(t,0,T,2e6);;%纵坐标


t_f=linspace(0,T,N);%横坐标
y_f=fliplr(y);%数组反向


t0=linspace(0,2*T,2*N-1);
s0=conv(y,y_f)./fs;


plot(t0,10*log10(s0));
xlabel("时间/s");
ylabel("幅度(dB)");
title('匹配滤波器输出信号');