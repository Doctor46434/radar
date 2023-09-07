% LFM信号的模糊函数图像

%参数
f0=1e10;
Tp=1e-5;       %脉冲宽度
B=1e7;         %带宽
fs=2e7;        %采样率
k=B/Tp;
tau=0;
t=tau-Tp/2:1/fs:tau+Tp/2;
s=exp(1j*pi*k.*(t-tau).^2);
plot(t,s);
s_conv1=[zeros(1,round(Tp*fs)),s,zeros(1,2*round(Tp*fs))];
s_conv2=[s,zeros(1,round(Tp*fs))];
s_all=zeros(2*round(Tp*fs),2*round(Tp*fs)+1);
for i=1:2*round(Tp*fs)
    s_all(i,:)=s_conv1(0+i:2*round(Tp*fs)+i).*conj(s_conv2);
end
s_fft=zeros(2*round(Tp*fs),2*round(Tp*fs)+1);
for i=1:2*round(Tp*fs)
    s_fft(i,:)=ifftshift(ifft(s_all(i,:)));
end
figure;
mesh(abs(s_fft));
xlabel("tau");
ylabel("fd");
title("模糊函数图像");
