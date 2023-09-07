% 计算高斯白噪声的实际功率谱密度

fs=2e6;
tb=1e-3;
N=fs*tb;
sigma=1e3;
n=sigma*randn(1,N);
f=(-N/2:N/2-1)*(fs/N);

Nfft=fft(n)/N*2;
Nshift=fftshift(Nfft);
power=abs(Nshift).^2/N;

plot(f,power);
m_power=mean(power);
xlabel("频率");
ylabel("能量");
txt=["高斯白噪声功率谱，功率谱密度平均值为" m_power];
title(txt);