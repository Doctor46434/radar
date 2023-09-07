%%分析LFM信号时域和频域

fs=5e7;   %采样率
T=10e-5;  %脉冲宽度
N=fs*T;   %采样点数
t=linspace(0,T,N);%横坐标
y=chirp(t,0,T,2e6);%纵坐标
subplot(2,2,1);
plot(t,y);
xlabel("时间/s");
ylabel("幅度");
title('线性调频(LFM)信号');

Y=fft(y);
w=(-N/2:N/2-1)*fs/length(y);
Yshift=fftshift(Y);
subplot(2,2,2);
plot(w,10*log10(abs(Yshift)));
hold on;
plot([2e6 -2e6],[22.5 22.5],'r*');

legend('频谱图像','频谱宽度2e6处')

xlabel("频率/Hz");
ylabel("对数幅度");
title('线性调频信号频谱');

[b,a] = butter(6,3e6/(fs/2));
y_r = filter(b,a,y);
subplot(2,2,3);
plot(t,y_r);
xlabel("时间/s");
ylabel("幅度");
title('线性调频(LFM)信号滤波');


