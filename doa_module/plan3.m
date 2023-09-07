% 对于左移手势进行三种方法分析
% function [P]=radio_process_anglex(filename)

adcdata=readDCA1000(".\left_10_Raw_0.bin");
% adcdata=readDCA1000(filename);
% 水平角分析
M_x   = 3;               % 阵元数目
K_x   = 1;                % 目标信号数目
c   = 3e8;              % 光速
f   = 10e9;             % 频率
f0=77e9;
l   = c/f0;              % 波长
Ac_x  = 3601;             % 角度采样数
d   = l/2;              % 阵元间隔

theta_x = linspace(-pi,pi,Ac_x);
R_x = d * (0:M_x-1)';

Angle_x=zeros(1,32);
X_x=zeros(3,64*256);
R_XX_x=zeros(32,3,3);
Pmusic_x=zeros(31,3601);
y = zeros(31,Ac_x);
y1 = zeros(31,Ac_x);

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
%     MUSIC
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

% LCMV
    Rinv = pinv(squeeze(R_XX_x(i,:,:)));
    
    for j = 1:Ac_x
        a = exp(1j * 2 * pi * R_x(:,1)* sin(theta_x(j))/l);
        y(i,j) = a'*Rinv* a;
    end
    
% FFT
    theta = linspace(-pi/2,pi/2,Ac_x);
    x_zero=zeros(3,1);
    for j=1:64
        x_zero=x_zero+X_x(1:3,1+(j-1)*256);
    end
    x_zero=x_zero/64;
    y1(i,:) = fft([x_zero;zeros(Ac_x-3,1)]);
    y1(i,:) =fftshift(y1(i,:));
    
end
% 绘制MUSIC图像以及角度图像
subplot(1,3,1);
n=1:31;
mesh(theta_x/pi*180,n,db(abs(Pmusic_x)));
xlim([-90 90]);
Pmusic_x_90=Pmusic_x(:,900:2700);
[Pmax_x,theta_max_x]=max(Pmusic_x_90,[],2);
theta_max_x=(theta_max_x-900)/10;
xlabel('角度/°');
ylabel('帧数');
title('MUSIC算法左移手势水平角变化');
% figure;
% n=1:31;
% plot(n,theta_max_x);
% title('角度随帧数的变化');
% ylim([-90 90]);

% 绘制LCMV图像
subplot(1,3,2);
n=1:31;
mesh(theta_x/pi*180,n,-db(abs(y)));

xlim([-90 90]);
xlabel('角度/°');
ylabel('帧数');
title('LCMV算法左移手势水平角变化');
% 绘制FFT图像
subplot(1,3,3);
n=1:31;
mesh(theta * 180/pi,n,db(abs(y1)));
xlabel('角度/°');
ylabel('帧数');
title('fft算法左移手势水平角变化');
P=Pmusic_x_90;
% end