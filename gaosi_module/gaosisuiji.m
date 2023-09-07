% 计算高斯白噪声的概率密度
N=1e6;
x=randn(1,N);


[f,xi]=ksdensity(x);
plot(xi,f);





