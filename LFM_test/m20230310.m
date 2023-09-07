% LFM信号PD图，正确

%参数
f0=1e10;  %载频
Tp=1e-5;  %脉宽
B=1e7;    %带宽
fs=1e8;   %采样率
R0=3e3;   %目标距离
c=3e8;    %光速
k=B/Tp;
Tr=1e-4;  %脉冲重复周期
n=64;      %脉冲个数
v=60;      %朝向雷达运动的速度



tau=zeros(n);
for m=1:n
    tau(m)=2*(R0-(m-1)*v*Tr)/c; %时延
end

s=zeros(n,round(Tp*fs+1));
s_out=zeros(n,round(Tp*fs+1));
t=0:1/fs:Tr*n;
ti=zeros(n,round(Tp*fs+1));
for i=1:n
    ti(i,:)=tau(i)-Tp/2+(i-1)*Tr:1/fs:tau(i)+Tp/2+(i-1)*Tr;
    tx=-Tp/2:1/fs:Tp/2;
    s_out(i,:)=exp(1j*pi*k.*tx.^2);
    s(i,:)=exp(1j*pi*k.*(ti(i,:)-tau(i)).^2)*exp(-1j*2*pi*f0*tau(i));
    plot(ti(i,:),s_out(i,:));
    hold on;
end

figure;
subplot(2,1,1);
plot(ti(1,:),s_out(1,:));
subplot(2,1,2);
plot(ti(1,:),s(1,:));


s_fl=zeros(n,round(Tp*fs+1));
ts=zeros(n,round(Tp*fs+1));
tt=zeros(n,round(Tp*fs+1));
figure;
for i=1:n
    %s_fl(i,:)=conj(fliplr(s_new(i,:)));
    %ts(i,:)=conv(s_fl(i,:),s_new(i,:))./fs;
    ts(i,:)=ifftshift(ifft(fft(s(i,:)).*conj(fft(s_out(i,:)))));
    tt(i,:)=tau(i)-Tp/2+(i-1)*Tr:1/fs:tau(i)+Tp/2+(i-1)*Tr;
end
mesh(abs(ts));
figure;
for i=1:1
    plot(tt(i,:),db(abs(ts(i,:))./max(abs(ts(i,:)))));
    hold on;
end

S_fft=zeros(n,10*round(2*Tp*fs+1));
for i=1:round(Tp*fs+1)
    S_fft(:,i)=fftshift(fft(ts(:,i)));
end
x=-75:150/64:75;
y=20000:1:40009;
figure;
mesh(db(abs(S_fft)));

xlabel("距离/m");
ylabel("速度/m/s");
title("二维距离-多普勒平面图");
fprintf ('最大不模糊速度为 %fm/s 最大不模糊距离 %fm 速度分辨率为 %fm/s',c/(2*f0*Tr),c*Tr/2,c/(2*f0*Tr*n));

