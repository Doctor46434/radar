% 拖入一个MAT转换后参数，画出31副PD图和2副角度图

% 参数
    fs=1e7;
    c=3e8;
    Kr=105e12;
    n_chirps=64;
    f0=77e9;
    Tr=138e-6;
    Ac_x  = 1801;             % 角度采样数
    Ac_y  = 1801;             % 角度采样数
    
%     PD图信息提取与绘制
    
    x=linspace(-fs/2,fs/2,256)*c/(2*Kr);
    v=linspace(-n_chirps/2,n_chirps/2,64)*(c/f0)/(2*Tr*n_chirps*2);
    % 绘图
    for i=30:30
        figure;
        mesh(x,v,db(abs(squeeze(pd_frame(i,:,:)))));
        xlabel('距离/m');
        ylabel('速度/m/s');

    end
    
%     角度图信息提取与绘制
%     水平角度
    
%     figure;
%     n=1:31;
%     theta_x = linspace(-pi,pi,Ac_x);
%     mesh(theta_x/pi*180,n,db(abs(P_x)));
%      xlabel('角度/°');
%         ylabel('帧');
%         title("水平维")
% 
%     xlim([-90 90]);
% %     俯仰角度
%     
%     figure;
%     n=1:31;
%     theta_y = linspace(-pi,pi,Ac_y);
%     mesh(theta_y/pi*180,n,db(abs(P_y)));
%          xlabel('角度/°');
%         ylabel('帧');
%         title("俯仰维")
%         %% 

    % xlim([-90 90]);