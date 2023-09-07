% 计算某种东西的方差，好像是测距的

fs=1e5;   %采样率
T=10e-2;  %脉冲宽度
N=fs*T;   %采样点数
t=linspace(0,T,N);%横坐标
y=cos(2*pi.*t*100);%纵坐标

B=fs/2;
Es=sum(y.^2)./fs;
snr=[20 10 0 -10 -20];
snr_10=10.^(snr./10);
N0=Es./snr_10;


y1=y.^2;



dy=diff(y1)./diff(t);



dt=t(1:end-1);
plot(dt,dy);

dy_sum=trapz(dt,dy);

var=1/(2/N0(1)*dy_sum)^2;

