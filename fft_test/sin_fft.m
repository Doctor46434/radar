% fft算法在不同采样点数下的结果

fs1=50;   %采样率
fs2=100;   %采样率
fs3=250;   %采样率
T=1;  %脉冲宽度
N1=fs1*T+1;   %采样点数
N2=fs2*T+1;
N3=fs3*T+1;

t1=linspace(0,T,N1);
t2=linspace(0,T,N2);
t3=linspace(0,T,N3);

y1=sin(10*pi*t1)+sin(20*pi*t1)+sin(50*pi*t1);
y2=sin(10*pi*t2)+sin(20*pi*t2)+sin(50*pi*t2);
y3=sin(10*pi*t3)+sin(20*pi*t3)+sin(50*pi*t3);

y1=y1(1,1:end-1);
y2=y2(1,1:end-1);
y3=y3(1,1:end-1);

N1=fs1*T;   %采样点数
N2=fs2*T;
N3=fs3*T;

Y1=fft(y1)./N1;
Y1shift=fftshift(Y1);
w1=(-N1/2:N1/2-1)*fs1/length(y1);
subplot(3,2,1);
stem(w1,db(abs(Y1shift)));
title("采样率为50Hz时的频谱幅值");
xlabel("频率");
ylabel("频谱幅值")
subplot(3,2,2);
stem(w1,angle(Y1shift));
title("采样率为50Hz时的频谱相位");
xlabel("频率");
ylabel("频谱相位")

Y2=fft(y2)./N2;
Y2shift=fftshift(Y2);
w2=(-N2/2:N2/2-1)*fs2/length(y2);
subplot(3,2,3);
stem(w2(1,(fs2/2-24):(fs2/2+26)),db(abs(Y2shift(1,(fs2/2-24):(fs2/2+26)))));
title("采样率为100Hz时的频谱幅值");
xlabel("频率");
ylabel("频谱幅值")
subplot(3,2,4);
stem(w2(1,(fs2/2-24):(fs2/2+26)),angle(Y2shift(1,(fs2/2-24):(fs2/2+26))));
title("采样率为100Hz时的频谱相位");
xlabel("频率");
ylabel("频谱相位")

Y3=fft(y3)./N3;
Y3shift=fftshift(Y3);
w3=(-N3/2:N3/2-1)*fs3/length(y3);
subplot(3,2,5);
stem(w3(1,(fs3/2-24):(fs3/2+26)),db(abs(Y3shift(1,(fs3/2-24):(fs3/2+26)))));
title("采样率为250Hz时的频谱幅值");
xlabel("频率");
ylabel("频谱幅值")
subplot(3,2,6);
stem(w3(1,(fs3/2-24):(fs3/2+26)),angle(Y3shift(1,(fs3/2-24):(fs3/2+26))));
title("采样率为250Hz时的频谱相位");
xlabel("频率");
ylabel("频谱相位")