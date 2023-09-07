% 匹配滤波器的结果，回波相距较近

fs=2e7;   %采样率
T=10e-5;  %脉冲宽度
N=fs*T;   %采样点数
t=linspace(0,T,N);%横坐标

y1=chirp(t,1e6,T,2e6);%回波1
y2=chirp(t,1e6,T,2e6);%回波2
y3=chirp(t,1e6,T,2e6);%回波3

y_f=fliplr(y1);%滤波器响应

t0=linspace(0,10*T,10*N);

y00=[zeros(1,5*N),y2,zeros(1,2*N),y3,zeros(1,N)];
y01=[zeros(1,5*N-200),y1,zeros(1,4*N+200)];

y0=y00+y01;


subplot(4,1,1);
plot(t0,y0);
xlabel("时间/s");
title("无噪声回波信号")
y_r=awgn(y0,20);
subplot(4,1,2);
plot(t0,y_r);
xlabel("时间/s");
title("SNR=20dB回波信号")
s0=conv(y_f,y_r)./fs;
ts=linspace(0,11*T,11*N-1);
subplot(4,1,3);
plot(ts,s0);
xlabel("时间/s");
title("经过匹配滤波器后的信号")

s1=zeros(1,length(ts));

for i=1:length(ts)
    if s0(i)>2.5e-5
        s1(i)=5e-5;
    end
end

subplot(4,1,4);
plot(ts,s1);
xlabel("时间/s");
title("判决结果")
