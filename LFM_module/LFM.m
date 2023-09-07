% 线性调频信号的频谱以及通过匹配滤波器后的结果

fs=2e7;   %采样率
T=10e-5;  %脉冲宽度
N=fs*T;   %采样点数
t=linspace(0,T,N);%横坐标
y=chirp(t,1e6,T,2e6);%纵坐标
subplot(3,1,1);
plot(t,y);
xlabel("时间/s");
ylabel("幅度");
title('线性调频(LFM)信号');

t_f=linspace(0,T,N);%横坐标
y_f=fliplr(y);%数组反向
subplot(3,1,2);
plot(t_f,y_f);
xlabel("时间/s");
ylabel("幅度");
title('匹配滤波器冲激响应');

t0=linspace(0,2*T,2*N-1);
s0=conv(y,y_f)./fs;

subplot(3,1,3);
plot(t0,s0);
xlabel("时间/s");
ylabel("幅度");
title('匹配滤波器输出信号');


Y=fft(y);
w=(-N/2:N/2-1)*fs/length(y);
Yshift=fftshift(Y);
figure;
plot(w,abs(Yshift));
xlabel("频率/Hz");
title('线性调频信号频谱');

