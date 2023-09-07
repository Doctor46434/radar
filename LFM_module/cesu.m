% 看不懂这玩意是干嘛的了

function [f,y_sum,f_max]=cesu(snr)

fs=1e5;   %采样率
T=10e-2;  %脉冲宽度
N=fs*T;   %采样点数
t=linspace(0,T,N);%横坐标
y=cos(2*pi.*t*100);%纵坐标

Es=0.05;
snr_10=10^(snr/10);
N0=Es/snr_10;
    
noise=wgn(1,N,N0*fs/2,"linear");

y=y+noise;

snr1=snr;


xlabel("时间/s");
ylabel("幅度");
txt=["信噪比为"+snr1+"dB时的接收信号"];
title(txt);
f=100-20:0.5:100+20;
y_s=zeros(length(f),N);

for i=1:length(f) 
    y_s(i,(1:N))=cos(2*pi*f(i)*t);
end

y_sy=zeros(1,N);

y_sum=zeros(1,length(f));

for i=1:length(f)
    y_sy=y_s(i,(1:N)).*y;
    y_sum(i)=trapz(t,y_sy);
end


xlabel("频率/Hz");
ylabel("幅度");
title('似然函数值');

[~,f_max]=max(y_sum);

f_max=80+(f_max-1)*0.5;
end
