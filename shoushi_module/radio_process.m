% 函数：MTI后的的PD图

function [pd_31frame]=radio_process(filename)
% % 调用read_bin


% % 输入为bin文件时使用该行代码
adcdata=readDCA1000(filename);
% 输入为mat文件时使用该行代码
% load(filename);
% adcdata = adcData;
% adcdata=readDCA1000("D:\training\radio_test\train_set\push_pull\push_pull_2_Raw_0.bin");

% % 时域绘图
% t=0:1/fs:(1/fs)*(length(adcdata(1,:))-1);
% plot(t(1:256),real(adcdata(1,1:256)));
% hold on;
% plot(t(1:256),imag(adcdata(1,1:256)));
f0=77e9;
c=3e8;
l=c/f0;
d=l/2;
fs=1e7;
n_samples=256;
n_chirps=64;
Kr=105e12;
Tr=138e-6;
range_win = hamming(n_samples)';   %加海明窗    
doppler_win = hamming(n_chirps);

% 计算共8个接收天线，每接收天线32帧数据，每帧数据64*256为一个单位的fft，输出数据格式为8*32*64*256
adc_data=zeros(8,32,64,256);
fft1_data=zeros(8,32,64,256);
for i=1:8
    for j=1:32
        for k=1:64
            adc_data(i,j,k,1:256)=adcdata(i,1+(k-1)*256+(j-1)*64*256:k*256+(j-1)*64*256);
            chirp_data=adcdata(i,1+(k-1)*256+(j-1)*64*256:k*256+(j-1)*64*256).*range_win;
            fft1_data(i,j,k,1:256)=fftshift(fft(chirp_data));
        end
    end
end

% % 其中一个切片的FFT
% figure;
% f=linspace(-fs/2,fs/2,256);
% % plot(f,abs(squeeze(fft1_data(5,4,3,:))));
% mesh(db(abs(squeeze(fft1_data(1,1,:,:)))));
% title("切片fft");

% 计算每一帧数据（64*256）的PD图
fft2_data=zeros(8,32,64,256);
for i=1:8
    for j=1:32
        for k=1:256
            a=squeeze(fft1_data(i,j,1:64,k));
            range_data=a.*doppler_win;
            fft2_data(i,j,1:64,k)=fftshift(fft(range_data));
        end
    end
end
% 绘制其中一个通道的32帧PD图
% for i=1:32
%     figure;
%     mesh(db(abs(squeeze(fft2_data(1,i,1:64,1:256)))));
%     view(2);
% end


% doppler_win = hamming(n_chirps/2);
% fft1_data1=squeeze(fft1_data(1,1,1:32,1:256));
% fft2_data1=zeros(32,256);
% for k=1:256
%     range_data1=squeeze(fft1_data1(1:32,k)).*doppler_win;
%     fft2_data1(1:32,k)=fftshift(fft(range_data1));
% end

% % 其中一个切片的PD图
% figure;
% mesh(db(abs(squeeze(fft2_data1))));


% % LCMV算法
% % 俯仰角
% Ac=3601;
% Angle_y=zeros(1,32);
% X_y=zeros(4,64*256);
% R_XX_y=zeros(32,4,4);
% Pmusic_y=zeros(32,3601);
% for i=1:32
%     X_y(1,:)=adcdata(1,64*256*(i-1)+1:64*256*i);
%     X_y(2,:)=adcdata(2,64*256*(i-1)+1:64*256*i);
%     X_y(3,:)=adcdata(3,64*256*(i-1)+1:64*256*i);
%     X_y(4,:)=adcdata(4,64*256*(i-1)+1:64*256*i);
%     R_XX_y(i,:,:)=1/64/256*(X_y*X_y');
%     Rinv = pinv(squeeze(R_XX_y(i,:,:)));
% 
%     
%     
% 
%     for  j = 1:Ac
%         a = exp(1j * 2 * pi * R(:,1)* sin(theta(i))/l);
%         y(i) = a'*Rinv* a;
%     end
% end
% theta = linspace(-pi,pi,Ac);
% R_1 = 1/Ts *(x*x');
% Rinv = pinv(R_1);
% y = zeros(1,Ac);
% for i = 1:Ac
%     a = exp(1j * 2 * pi * R(:,1)* sin(theta(i))/l);
%     y(i) = a'*Rinv* a;
% end
% 
% ydB = 10*log10(abs(y)/max(abs(y)));
% ydB = -ydB+min(ydB);



% MUSIC算法
% % 俯仰角分析
% M_y   = 4;               % 阵元数目
% K_y   = 1;                % 目标信号数目
% Ac_y  = 3601;             % 角度采样数
% theta_y = linspace(-pi,pi,Ac_y);
% R_y = d * (0:M_y-1)';
% 
% Angle_y=zeros(1,32);
% X_y=zeros(4,64*256);
% R_XX_y=zeros(32,4,4);
% Pmusic_y=zeros(32,3601);
% for i=1:32
%     X_y(1,:)=adcdata(1,64*256*(i-1)+1:64*256*i);
%     X_y(2,:)=adcdata(2,64*256*(i-1)+1:64*256*i);
%     X_y(3,:)=adcdata(3,64*256*(i-1)+1:64*256*i);
%     X_y(4,:)=adcdata(4,64*256*(i-1)+1:64*256*i);
%     R_XX_y(i,:,:)=1/64/256*(X_y*X_y');
% 
%     [EV,D]=eig(squeeze(R_XX_y(i,:,:)));
%     EVA=diag(D)';
%     [EVA,I]=sort(EVA);
%     EV=fliplr(EV(:,I)); 
%     
% 
%     for j = 1:Ac_y
%         a = exp(1j * 2 * pi * R_y(:,1)* sin(theta_y(j))/l); 
%         En=EV(:,K_y+1:M_y);                   % 取矩阵的第M+1到N列组成噪声子空间
%         Pmusic_y(i,j)=1/(a'*(En*En')*a);
%     end
% end
% figure;
% plot(theta_y*180/pi,db(abs(Pmusic_y(19,:))));
% xlim([-90 90]);
% Pmusic_y_90=Pmusic_y(:,900:2700);
% [Pmax_y,theta_max_y]=max(Pmusic_y_90(:,500:1300),[],2);
% theta_max_y=(theta_max_y-400)/400*90;
% figure;
% n=1:32;
% plot(n,theta_max_y);
% title('角度随帧数的变化');
% ylim([-90 90]);
% % 水平角分析
% M_x   = 3;               % 阵元数目
% K_x   = 2;                % 目标信号数目
% Ac_x  = 3601;             % 角度采样数
% theta_x = linspace(-pi,pi,Ac_x);
% R_x = d * (0:M_x-1)';
% 
% Angle_x=zeros(1,32);
% X_x=zeros(3,64*256);
% R_XX_x=zeros(32,3,3);
% Pmusic_x=zeros(32,3601);
% for i=1:32
%     X_x(1,:)=adcdata(3,64*256*(i-1)+1:64*256*i);
%     X_x(2,:)=adcdata(5,64*256*(i-1)+1:64*256*i);
%     X_x(3,:)=adcdata(7,64*256*(i-1)+1:64*256*i);
%     R_XX_x(i,:,:)=1/64/256*(X_x*X_x');
% 
%     [EV,D]=eig(squeeze(R_XX_x(i,:,:)));
%     EVA=diag(D)';
%     [EVA,I]=sort(EVA);
%     EV=fliplr(EV(:,I)); 
%     
% 
%     for j = 1:Ac_y
%         a = exp(1j * 2 * pi * R_x(:,1)* sin(theta_x(j))/l); 
%         En=EV(:,K_x+1:M_x);                   % 取矩阵的第M+1到N列组成噪声子空间
%         Pmusic_x(i,j)=1/(a'*(En*En')*a);
%     end
% end
% figure;
% n=1:32;
% mesh(theta_x/pi*180,n,db(abs(Pmusic_x)));
% xlim([-90 90]);
% Pmusic_x_90=Pmusic_x(:,900:2700);
% [Pmax_x,theta_max_x]=max(Pmusic_x_90,[],2);
% theta_max_x=(theta_max_x-900)/10;
% figure;
% n=1:32;
% plot(n,theta_max_x);
% title('角度随帧数的变化');
% ylim([-90 90]);


% MTI算法
mti_data=zeros(8,31,64,256);
for i=1:8
    for j=1:31
        for k=1:64
            mti_data(i,j,k,1:256)=adc_data(i,j+1,k,1:256)-adc_data(i,j,k,1:256);
        end
    end
end

% MTI算法的FFT切片
fftmti_data=zeros(8,31,64,256);
chirpmti_data=zeros(1,256);
for i=1:8
    for j=1:31
        for k=1:64
            chirpmti_data=squeeze(mti_data(i,j,k,1:256));
            chirpmti_data=chirpmti_data.*range_win';
            fftmti_data(i,j,k,1:256)=fftshift(fft(chirpmti_data));
%             fftmti_data(i,j,k,1:256)=fft(chirpmti_data);
        end
    end
end

% % MTI其中一个切片的FFT
% figure;
% f=linspace(-fs/2,fs/2,256);
% % plot(f,abs(squeeze(fft1_data(5,4,3,:))));
% mesh((abs(squeeze(fftmti_data(1,7,:,:)))));
% title("切片fft");

mtipd_data=zeros(8,31,64,256);
for i=1:8
    for j=1:31
        for k=1:256
            range_data=squeeze(fftmti_data(i,j,1:64,k)).*doppler_win;
            mtipd_data(i,j,1:64,k)=fftshift(fft(range_data));
        end
    end
end
x=linspace(-fs/2,fs/2,256)*c/(2*Kr);
v=linspace(-n_chirps/2,n_chirps/2,64)*(c/f0)/(2*Tr*n_chirps*2);
% 绘图
% for i=1:31
%     figure;
% %     subplot(2,1,1);
%     mesh(x,v,(abs(squeeze(mtipd_data(2,i,:,:)))));
%     xlabel('距离/m');
%     ylabel('速度/m/s');
%     
% %     subplot(2,1,2);
% %     mesh(x,v,db(abs(squeeze(fft2_data(2,i,:,:)))));
% %     xlabel('距离/m');
% %     ylabel('速度/m/s');
% %     view(2);
% end

ava_data=zeros(31,64,256);

for i=1:31
    frame_0=zeros(1,64,256);
    for j=1:8
        frame_0=frame_0+reshape(mtipd_data(j,i,1:64,1:256),[1,64,256]);
    end
    ava_data(i,1:64,1:256)=frame_0/8;
end


pd_31frame=ava_data;

end




