% 一个实验函数，用于计算PD图，显示时域图像
% 调用read_bin
adcdata=read_bin("D:\training\radio_test\blank_Raw_0.bin");
% 计算第一通道256个点的FFT
fft_adcdata=zeros(8,256,32*64);
for i=1:8
    for j=1:2048
        fft_adcdata(i,1:256,j)=fftshift(fft((adcdata(i,1+(j-1)*256:j*256))));
    end
end
fs=1e7;
frame=3;
% 时域绘图
t=0:1/fs:(1/fs)*(length(adcdata(1,:))-1);
plot(t(1:256),real(adcdata(1,1:256)));
hold on;
plot(t(1:256),imag(adcdata(1,1:256)));
% 频域绘图
figure;
f=linspace(-fs/2,fs/2,256);
x=1:2048;
fft_adcdata1=zeros(256,2048);
for i=1:256
    for j=1:2048
        fft_adcdata1(i,j)=fft_adcdata(1,i,j);
    end
end
mesh(x,f,abs(fft_adcdata1));

pd_data1=zeros(256,64);

for i=1:256
    pd_data1(i,1:64)=fftshift(fft(fft_adcdata1(i,1:64)));
end
figure;
mesh(abs(pd_data1));





%脉冲压缩线性调频信号
% B=3990.3e6;
% Tp=256/1e7;
% k=105.008e12;
% start_f=77e9;
% t_out=0:1/fs:255/fs;
% s_out=exp(1j*pi*k.*t_out.^2);
% figure;
% plot(t_out,real(s_out));
% x=Tp*k;
% 
% ts=conv(real(s_out),real(adcdata(1,:)));
% figure;
% plot(ts(1:256*100));