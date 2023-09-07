% 不同采样率下y=1./(sqrt(1+t.^2));的频谱

fs1=10;   %采样率
fs2=20;   %采样率
fs3=50;   %采样率
T=5;  %脉冲宽度
N1=fs1*T;   %采样点数
N2=fs2*T;
N3=fs3*T;

t1=linspace(0,T,N1);
t2=linspace(0,T,N2);
t3=linspace(0,T,N3);

y1=exp(-t1);
y2=exp(-t2);
y3=exp(-t3);

Y1=fft(y1)./N1;
Y2=fft(y2)./N2;
Y3=fft(y3)./N3;

Y1shift=fftshift(Y1);
Y2shift=fftshift(Y2);
Y3shift=fftshift(Y3);

t=-25:0.1:25;
y=1./(sqrt(1+t.^2));


w1=(-N1/2:N1/2-1)*fs1/length(y1);
subplot(3,2,1);
stem(w1,abs(Y1shift));
title("采样率为10Hz时的频谱幅值");
xlabel("频率");
ylabel("频谱幅值")
hold on;
plot(t,y,'r');
legend("fft计算","理论");
subplot(3,2,2);
stem(w1,angle(Y1shift));
title("采样率为10Hz时的频谱相位");
xlabel("频率");
ylabel("频谱相位")

w2=(-N2/2:N2/2-1)*fs2/length(y2);
subplot(3,2,3);
stem(w2,abs(Y2shift));
title("采样率为20Hz时的频谱幅值");
xlabel("频率");
ylabel("频谱幅值");
hold on;
plot(t,y,'r');
legend("fft计算","理论");
subplot(3,2,4);
stem(w2,angle(Y2shift));
title("采样率为20Hz时的频谱相位");
xlabel("频率");
ylabel("频谱相位");


w3=(-N3/2:N3/2-1)*fs3/length(y3); 
subplot(3,2,5);
stem(w3,abs(Y3shift));
title("采样率为50Hz时的频谱幅值");
xlabel("频率");
ylabel("频谱幅值")
hold on;
plot(t,y,'r');
legend("fft计算","理论");
subplot(3,2,6);
stem(w3,angle(Y3shift));
title("采样率为50Hz时的频谱相位");
xlabel("频率");
ylabel("频谱相位");