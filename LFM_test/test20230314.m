%参数
f0=1e10;   %载频
Tp=1e-5;   %脉宽
B=1e7;     %带宽
snr=0;     %脉压前信噪比
snr_10=10^(snr/10);
snr1=20;   %脉压后信噪比
snr1_10=10^(snr1/10);
fs=1e8;    %采样率
R0=3e3;    %距离
c=3e8;     %光速
k=B/Tp; 
Tr=1e-4;  %脉冲重复周期
n=64;      %脉冲个数
v=60;      %朝向雷达运动的速度

%显示回波时域频域波形
tau=zeros(n);
for m=1:n
    tau(m)=2*(R0-m*v*Tr)/c; %时延
end
s_out=zeros(n,round(Tp*fs+1));
si=zeros(n,round(Tp*fs+1));
ti=zeros(n,round(Tp*fs+1));
si_all=zeros(n,10*round(Tp*fs+1));
noise=randn(n,10*round(Tp*fs+1));
for i=1:n
    ti(i,:)=tau(i)-Tp/2+(i-1)*Tr:1/fs:tau(i)+Tp/2+(i-1)*Tr;
    si(i,:)=sqrt(snr_10)*exp(1j*pi*k.*(ti(i,:)-tau(i)).^2)*exp(-1j*2*pi*f0*tau(i));
    tx=-Tp/2:1/fs:Tp/2;
    s_out(i,:)=exp(1j*pi*k.*tx.^2);
    si_all(i,(2*round(Tp*fs+1):3*round(Tp*fs+1)-1))=si(i,:);
    si_all1=abs(si_all(1,:));
    si_all(i,:)=si_all(i,:)+noise(i,:);
end
s=zeros(1,10*n*round(Tp*fs+1)+1);
for i=1:n
    s((i-1)*10000+1:i*10000+10)=si_all(i,:);
end
t=-Tp/2:1/fs:+Tp/2+n*Tr+(640-1000)/fs;
plot(t,s);
xlabel("时间/s");
ylabel("幅度");
title("回波波形");
si_fft=zeros(n,round(Tp*fs+1));
for i=1:n
    si_fft=fftshift(fft(s));
end
fs_x=-fs/2:fs/(10*n*round(Tp*fs+1)+1):fs/2-fs/(10*n*round(Tp*fs+1)+1);
figure;
plot(fs_x,db(abs(si_fft)./max(si_fft)));
xlabel("频率/Hz");
ylabel("幅度（dB）");
title("归一化频域波形");


%进行脉冲压缩和门限检测
ts=zeros(n,round(Tp*fs+1));
tt=zeros(n,round(Tp*fs+1));
noise=randn(n,round(Tp*fs+1));
for i=1:n
    ts(i,:)=sqrt(snr1_10)*ifftshift(ifft(fft(si(i,:)).*conj(fft(s_out(i,:)))))/1000+noise(i,:);
    tt(i,:)=tau(i)-Tp/2+(i-1)*Tr:1/fs:tau(i)+Tp/2+(i-1)*Tr;
end
figure;
stem(tt(1,:),abs(ts(1,:)/10));
xlabel("时间/s");
ylabel("幅度");
title("归一化脉冲压缩结果");
%计算过门限结果
ts_door=zeros(1,round(Tp*fs+1));
for i=1:round(Tp*fs+1)
    if abs(ts(1,i)/10)>0.72
        ts_door(1,i)=1;
    else
        ts_door(1,i)=0;
    end
end
figure;
plot(tt(1,:)*fs+1000,ts_door);
xlabel("距离/m");
ylabel("幅度");
title("门限检测后结果");

%进行PD处理
S_fft=zeros(n,round(Tp*fs+1));
for i=1:round(Tp*fs+1)
    S_fft(:,i)=fftshift(fft(ts(:,i)));
end
x=-75:150/64:75-150/64;
y=2500:1:3500;
figure;
mesh(y,x,abs(S_fft));
xlabel("距离/m");
ylabel("速度/m/s");
title("PD三维图");


