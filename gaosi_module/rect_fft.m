% 方波信号的FFT

fs1=10;   %采样率
fs2=20;   %采样率
fs3=50;   %采样率
T=2;  %脉冲宽度
N1=fs1*T;   %采样点数
N2=fs2*T;
N3=fs3*T;


y1=[zeros(1,N1*9/20),zeros(1,N1/10)+1,zeros(1,N1*9/20-1)];
y2=[zeros(1,N2*9/20),zeros(1,N2/10)+1,zeros(1,N2*9/20-1)];
y3=[zeros(1,N3*9/20),zeros(1,N3/10)+1,zeros(1,N3*9/20-1)];  



Y1=fft(y1)./N1;
Y1shift=fftshift(Y1);
w1=(-N1/2+1:N1/2-1)*fs1/length(y1);
subplot(3,2,1);
stem(w1,abs(Y1shift));
t=-25:0.1:25;
y=abs(0.1*sin(0.2*pi.*t)./(0.2*pi.*t));
hold on;
plot(t,y,'r');
title("采样率为10Hz时的频谱幅值");
xlabel("频率");
ylabel("频谱幅值")
legend("fft计算","理论")
subplot(3,2,2);
stem(w1,angle(Y1shift));
title("采样率为10Hz时的频谱相位");
xlabel("频率");
ylabel("频谱相位")

Y2=fft(y2)./N2;
Y2shift=fftshift(Y2);
w2=(-N2/2+1:N2/2-1)*fs2/length(y2);
subplot(3,2,3);
stem(w2,abs(Y2shift));
title("采样率为20Hz时的频谱幅值");
xlabel("频率");
ylabel("频谱幅值")
hold on;
plot(t,y,'r');
legend("fft计算","理论")
subplot(3,2,4);
stem(w2,abs(angle(Y2shift)));
title("采样率为20Hz时的频谱相位");
xlabel("频率");
ylabel("频谱相位")

Y3=fft(y3)./N3;
Y3shift=fftshift(Y3);
w3=(-N3/2+1:N3/2-1)*fs3/length(y3); 
subplot(3,2,5);
stem(w3,abs(Y3shift));
title("采样率为50Hz时的频谱幅值");
xlabel("频率");
ylabel("频谱幅值")
hold on;
plot(t,y,'r');
legend("fft计算","理论")
subplot(3,2,6);
stem(w3,angle(Y3shift));
title("采样率为50Hz时的频谱相位");
xlabel("频率");
ylabel("频谱相位")