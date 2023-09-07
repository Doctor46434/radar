function lz_pdf(SNR)
fs=2e7;   %采样率
T=10e-5;  %脉冲宽度
N=fs*T;   %采样点数
t=linspace(0,T,N);%横坐标
y=chirp(t,0,T,2e6);%纵坐标

y_f=fliplr(y);%数组反向

SNR_10=10^(SNR/10);
Es=sum(y.^2)./fs;
N0=Es/SNR_10;

%对H0和H1两种情况各进行10000次仿真

k1=zeros(1,10000);  
k0=zeros(1,10000);

for i=1:10000

    noise=wgn(1,N,N0*fs/2,'linear');

    y_r=y+noise;

    s0=conv(y_f,y_r)./fs;
    
    k1(i)=s0(2000);
end

[fi1,x1]=ksdensity(k1);
plot(x1,fi1);
hold on;

for i=1:10000

    noise=wgn(1,N,N0*fs/2,'linear');

    y_r=noise;

   

    s0=conv(y_f,y_r)./fs;
    
    k0(i)=s0(2000);
end

[fi2,x2]=ksdensity(k0);
plot(x2,fi2);
xlabel('密度');
ylabel('数据');
title('检验统计量概率密度函数');
legend('H1')