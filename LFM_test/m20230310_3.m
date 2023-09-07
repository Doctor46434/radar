% 巴克码信号模糊函数

%参数
Te=1e-7;
Tp=1.3e-6;
fs=2e7;
phi=[0 0 0 0 0 pi pi 0 0 pi 0 pi 0];
u=zeros(13,round(Te*fs));
s=0;
for i=1:13
    t=1:Te*fs;
    u(i,:)=t.*exp(1j*phi(i));
    s=[s u(i,:)];
end
t=-0.5*Te:1/fs:12.5*Te;
plot(t,s);
s_conv1=[zeros(1,round(Te*fs*13)),s,zeros(1,2*round(Te*fs*13))];
s_conv2=[s,zeros(1,round(Te*fs*13))];
s_all=zeros(2*round(Te*fs*13),2*round(Te*fs*13)+1);
for i=1:2*round(Te*fs*13)
    s_all(i,:)=s_conv1(0+i:2*round(Te*fs*13)+i).*conj(s_conv2);
end
s_fft=zeros(2*round(Te*fs*13),2*round(Te*fs*13)+1);
for i=1:2*round(Te*fs*13)
    s_fft(i,:)=ifftshift(ifft(s_all(i,:)));
end
figure;
mesh(abs(s_fft));
xlabel("tau");
ylabel("fd");
title("模糊函数图像");

