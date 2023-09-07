% LFM信号PD图

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
snr=20;
snr_10=10^(snr/10);


tau=zeros(n);
for m=1:n
    tau(m)=2*(R0-m*v*Tr)/c; %时延
end

s=zeros(n,round(Tp*fs+1));
t=0:1/fs:Tr*n;
ti=zeros(n,round(Tp*fs+1));
noise=randn(n,round(Tp*fs+1))+1j*randn(n,round(Tp*fs+1));
for i=1:n
    ti(i,:)=tau(i)-Tp/2+(i-1)*Tr:1/fs:tau(i)+Tp/2+(i-1)*Tr;
    s(i,:)=snr_10*exp(1j*pi*k.*(ti(i,:)-tau(i)).^2)*exp(-1j*2*pi*f0*tau(i));
    plot(ti(i,:),s(i,:));
    hold on;
end

s_fl=zeros(n,round(Tp*fs+1));
ts=zeros(n,round(2*Tp*fs+1));
figure;
for i=1:n
    s_fl(i,:)=conj(fliplr(s(i,:)));
    ts(i,:)=conv(s_fl(i,:),s(i,:)+noise(i,:))./fs;
    tt(i,:)=tau(i)-Tp+(i-1)*Tr:1/fs:tau(i)+Tp+(i-1)*Tr;
    
end
mesh(db(ts));

S_fft=zeros(n,round(2*Tp*fs+1));
for i=1:round(2*Tp*fs+1)
    S_fft(:,i)=fftshift(fft(ts(:,i)));
end
x=0:120/64:120-120/64;
y=2000:1:4000;
figure;
mesh(y,x,abs(S_fft));

xlabel("距离/m");
ylabel("速度/m/s");
title("二维距离-多普勒平面图");

[x_1,y_1]=max(max(S_fft));
[q_1,p_1]=max(S_fft(:,y_1));
fprintf("%d %d",x_1,y_1);
S_x=0;
Sy=0;
for i=y_1-20:y_1+20
    S_x=S_x+(i+2000-1)*S_fft(p_1,i);
    Sy=Sy+S_fft(p_1,i);
end
S_xabs=S_x/Sy
S_v=0;
Svy=0;
for i=p_1-3:p_1+3
    S_v=S_v+(120/64*(i-1))*S_fft(i,y_1);
    Svy=Svy+S_fft(i,y_1);
end
S_vabs=S_v/Svy
