%%实际测试匹配滤波器虚警概率和检测概率之间的关系
function roc(SNR)

fs=2e7;   %采样率
T=10e-5;  %脉冲宽度
N=fs*T;   %采样点数
t=linspace(0,T,N);%横坐标
y=chirp(t,0,T,2e6);%纵坐标

y_f=fliplr(y);%数组反向

SNR_10=10^(SNR/10);  %%求出噪声功率谱密度
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

for i=1:10000

    noise=wgn(1,N,N0*fs/2,'linear');

    y_r=noise;

   

    s0=conv(y_f,y_r)./fs;
    
    k0(i)=s0(2000);
end

count_pf=0;
count_pd=0;

for lambda=-1e-4:1e-5:1e-4
    for i=1:10000
        if k0(i)>lambda
            count_pf=count_pf+1;
        end
    end
    for i=1:10000
        if k1(i)>lambda
            count_pd=count_pd+1;
        end
    end

    plot(count_pf/10000,count_pd/10000,'r*');
    hold on;

    count_pf=0;
    count_pd=0;
end

