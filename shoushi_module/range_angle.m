adcdata=readDCA1000("D:\training\radio_test\train_set\push_pull\push_pull_2_Raw_0.bin");

% 水平角分析
M_x = 3;              % 阵元数目
K_x = 1;              % 目标信号数目
c = 3e8;              % 光速
fs=1e7;
Kr=105e12;
f0 = 77e9;
l = c/f0;             % 波长
Ac_x = 3601;          % 角度采样数
d = l/2;              % 阵元间隔
n_samples=256;
n_chirps=64;
range_win = hamming(n_samples)';   %加海明窗    
doppler_win = hamming(n_chirps);

theta_x = linspace(-pi,pi,Ac_x);
R_x = d * (0:M_x-1)';

Angle_x=zeros(1,32);
X_x=zeros(3,64*256);
R_XX_x=zeros(32,3,3);
Pmusic_x=zeros(31,3601);

% 进行MTI处理
adc_data=zeros(8,32,64,256);
for i=1:8
    for j=1:32
        for k=1:64
            adc_data(i,j,k,1:256)=adcdata(i,1+(k-1)*256+(j-1)*64*256:k*256+(j-1)*64*256);
        end
    end
end
mti_data=zeros(8,31,64,256);
for i=1:8
    for j=1:31
        for k=1:64
            mti_data(i,j,k,1:256)=adc_data(i,j+1,k,1:256)-adc_data(i,j,k,1:256);
        end
    end
end


for i=1:31
    X_x(1,:)=reshape(mti_data(3,i,1:64,1:256),[1,64*256])+reshape(mti_data(4,i,1:64,1:256),[1,64*256]);
    X_x(2,:)=reshape(mti_data(5,i,1:64,1:256),[1,64*256])+reshape(mti_data(6,i,1:64,1:256),[1,64*256]);
    X_x(3,:)=reshape(mti_data(7,i,1:64,1:256),[1,64*256])+reshape(mti_data(8,i,1:64,1:256),[1,64*256]);
    R_XX_x(i,:,:)=1/64/256*(X_x*X_x');

    [EV,D]=eig(squeeze(R_XX_x(i,:,:)));
    EVA=diag(D)';
    [EVA,I]=sort(EVA);
    EV=fliplr(EV(:,I)); 
    

    for j = 1:Ac_x
        a = exp(1j * 2 * pi * R_x(:,1)* sin(theta_x(j))/l); 
        En=EV(:,K_x+1:M_x);                   % 取矩阵的第M+1到N列组成噪声子空间
        Pmusic_x(i,j)=1/(a'*(En*En')*a);
    end
end
figure;
n=1:31;
mesh(theta_x/pi*180,n,db(abs(Pmusic_x)));
xlim([-90 90]);
Pmusic_x_90=Pmusic_x(:,900:2700);
[Pmax_x,theta_max_x]=max(Pmusic_x_90,[],2);
theta_max_x=(theta_max_x-900)/10;
figure;
n=1:31;
plot(n,theta_max_x);
title('角度随帧数的变化');
ylim([-90 90]);


fftmti_data=zeros(8,31,64,256);
chirpmti_data=zeros(1,256);
for i=1:8
    for j=1:31
        for k=1:64
            chirpmti_data=squeeze(mti_data(i,j,k,1:256));
            chirpmti_data=chirpmti_data.*range_win';
            fftmti_data(i,j,k,1:256)=fftshift(fft(chirpmti_data));
%           fftmti_data(i,j,k,1:256)=fft(chirpmti_data);
        end
    end
end

% MTI其中一个切片的FFT
figure;
x=linspace(-fs/2,fs/2,256)*c/(2*Kr);
n=1:64;
% plot(f,abs(squeeze(fft1_data(5,4,3,:))));
mesh(x,n,db(abs(squeeze(fftmti_data(1,20,:,:)))));
title("切片fft");

% 对每64chirp,8接收天线取平均值
fftmtiav_data=zeros(31,256);
for i=1:31
    ava=0;
    for j=1:8
        for k=1:64
            ava=ava+fftmti_data(j,i,k,1:256);
        end
    end
    fftmtiav_data(i,1:256)=squeeze(ava/64/8);
end
figure;
x=linspace(-fs/2,fs/2,256)*c/(2*Kr);
n=1:31;
mesh(x(1+100:256-100),n,db(abs(squeeze(fftmtiav_data(:,1+100:256-100)))));