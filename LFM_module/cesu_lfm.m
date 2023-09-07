%%分析LFM信号时域和频域

fs=1e5;   %采样率
T=10e-2;  %脉冲宽度
N=fs*T;   %采样点数
t=linspace(0,T,N);%横坐标
y=chirp(t,3e3,T,7e3);%纵坐标
y=awgn(y,-40);
subplot(2,1,1);

plot(t,y);
xlabel("时间/s");
ylabel("幅度");
title('接收信号');
f=-20:0.5:20;
y_s=zeros(length(f),N);

for i=1:length(f) 
    y_s(i,(1:N))=chirp(t,3e3+f(i),T,7e3+f(i));
end

y_sy=zeros(1,N);

y_sum=zeros(1,length(f));

for i=1:length(f)
    y_sy=y_s(i,(1:N)).*y;
    y_sum(i)=trapz(t,y_sy);
end
subplot(2,1,2);
stem(f,y_sum);
xlabel("频率/Hz");
ylabel("幅度");
title('似然函数值');

