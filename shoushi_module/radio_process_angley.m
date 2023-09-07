% 函数：垂直方向测角
function [P]=radio_process_angley(filename)

% adcdata=readDCA1000("D:\training\radio_test\train_set\left_right\left_right_4_Raw_0.bin");

% % 输入为bin文件时使用该行代码
% adcdata=readDCA1000(filename);
% 输入为mat文件时使用该行代码
load(filename);
adcdata = adcData;

% MUSIC算法
% 俯仰角分析
M_y   = 4;               % 阵元数目
K_y   = 1;                % 目标信号数目
c   = 3e8;              % 光速
f   = 10e9;             % 频率
f0=77e9;
l   = c/f0;              % 波长
Ac_y  = 3601;             % 角度采样数
d   = l/2;              % 阵元间隔
theta_y = linspace(-pi,pi,Ac_y);
R_y = d * (0:M_y-1)';

Angle_y=zeros(1,32);
X_y=zeros(4,64*256);
R_XX_y=zeros(32,4,4);
Pmusic_y=zeros(31,3601);

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
    X_y(1,:)=reshape(mti_data(1,i,1:64,1:256),[1,64*256]);
    X_y(2,:)=reshape(mti_data(2,i,1:64,1:256),[1,64*256]);
    X_y(3,:)=reshape(mti_data(3,i,1:64,1:256),[1,64*256]);
    X_y(4,:)=reshape(mti_data(4,i,1:64,1:256),[1,64*256]);
    R_XX_y(i,:,:)=1/64/256*(X_y*X_y');

    [EV,D]=eig(squeeze(R_XX_y(i,:,:)));
    EVA=diag(D)';
    [EVA,I]=sort(EVA);
    EV=fliplr(EV(:,I)); 
    
    for j = 1:Ac_y
        a = exp(1j * 2 * pi * R_y(:,1)* sin(theta_y(j))/l); 
        En=EV(:,K_y+1:M_y);                   % 取矩阵的第M+1到N列组成噪声子空间
        Pmusic_y(i,j)=1/(a'*(En*En')*a);
    end
end
% 绘制图像
% figure;
% n=1:31;
% mesh(theta_y/pi*180,n,db(abs(Pmusic_y)));
% xlim([-90 90]);
Pmusic_y_90=Pmusic_y(:,900:2700);
% [Pmax_y,theta_max_y]=max(Pmusic_y_90,[],2);
% theta_max_y=(theta_max_y-900)/10;
% figure;
% n=1:31;
% plot(n,theta_max_y);
% title('角度随帧数的变化');
% ylim([-90 90]);

P=Pmusic_y_90;
end