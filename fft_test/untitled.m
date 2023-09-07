% 加窗与不加窗的区别
fs=200;   %采样率
T=2;  %脉冲宽度
N=fs*T;


t=linspace(0,T,N);
y=sin(10*pi*t)+sin(20*pi*t)+sin(50*pi*t);



n=1:N;

w1=(sin(n.*pi./N)).^2;
w2=0.54-0.46*cos(2*pi.*n/N);

y1=y.*w1;
y2=y.*w2;

Y=fft(y)./N;
Yshift=fftshift(Y);
w=(-(N-1)/2:(N-1)/2)*fs/length(y);
subplot(3,1,1);
stem(w,abs(Yshift));
title("不加窗");
xlabel("频率(Hz)");
ylabel("幅度"); 


Y1=fft(y1)./N;
Y1shift=fftshift(Y1);
subplot(3,1,2);
stem(w,abs(Y1shift));
title("加汉宁窗");
xlabel("频率(Hz)");
ylabel("幅度");



Y2=fft(y2)./N;
Y2shift=fftshift(Y2);
subplot(3,1,3);
stem(w,abs(Y2shift));
title("加海明窗");
xlabel("频率(Hz)");
ylabel("幅度");

