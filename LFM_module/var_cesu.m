% 计算某种东西的方差，好像是测速的，但应该不是

fs=1e5;   %采样率
T=10e-2;  %脉冲宽度
N=fs*T;   %采样点数
t=linspace(0,T,N);%横坐标
x=cos(2*pi.*t*100);
y=sin(2*2*pi.*t*100);%纵坐标

B=fs/2;
Es=sum(x.^2)./fs;
snr=[20 15 10 5 0];
snr_10=10.^(snr./10);
N0=Es./snr_10;

yt=y.*t;

yt_sum=trapz(t,yt);

var=1/(yt_sum/N0(5))^2;