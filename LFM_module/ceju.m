%%分析LFM信号时域和频域

function [t_stem,y_sum,t_delay]=cesu(snr)

fs=1e5;   %采样率
T=10e-2;  %脉冲宽度
N=fs*T;   %采样点数
t=linspace(0,T,N);%横坐标
y=cos(2*pi.*t*100);%纵坐标


y_delay=[zeros(1,5*N),y,zeros(1,4*N)];



Es=0.05;
snr_10=10^(snr/10);
N0=Es/snr_10;

noise=wgn(1,N,N0*fs/2,"linear");

y=y+noise;

y_es=zeros(200,10*N);

for i=1:200
    y_es(i,:)=[zeros(1,2*N+i*250),y,zeros(1,7*N-i*250)];
end

y_es_delay=zeros(200,10*N);
y_sum=zeros(1,200);

t_sum=linspace(0,10*T,10*N);

for i=1:200
    y_es_delay(i,:)=y_es(i,:).*y_delay;
    y_sum(i)=trapz(t_sum,y_es_delay(i,:));
end
t_stem=linspace(2*T,7*T,200);

y_sum=abs(y_sum);
[y_max,tmax]=max(y_sum);
t_delay=2*T+(tmax)*5*T/200;
end


