% 批量转换文件mat
namelist = dir('D:\training\test20230329\anticlockwise\*.mat');
% namelist = dir('D:\training\radio_test\test01\*.bin');

for i=1:10
    
    filename=[namelist(i).folder '\' namelist(i).name];

    path=split(namelist(i).folder,"\");
    name=split(namelist(i).name,"_");

    out_name=strcat('D:\training\test20230402\anticlockwise\anticlockwise_',num2str(i),'_data');
    
    out_name=string(out_name);
    
    
    % % 参数
    % fs=1e7;
    % c=3e8;
    % Kr=105e12;
    % n_chirps=64;
    % f0=77e9;
    % Tr=138e-6;
    % Ac_x  = 1801;             % 角度采样数
    % Ac_y  = 1801;             % 角度采样数
    
    % PD图信息提取与绘制
    pd_frame=radio_process(filename);
    % x=linspace(-fs/2,fs/2,256)*c/(2*Kr);
    % v=linspace(-n_chirps/2,n_chirps/2,64)*(c/f0)/(2*Tr*n_chirps*2);
    % % 绘图
    % for i=1:31
    %     figure;
    %     mesh(x,v,(abs(squeeze(pd_frame(i,:,:)))));
    %     xlabel('距离/m');
    %     ylabel('速度/m/s');
    %     
    % end
    
    % 角度图信息提取与绘制
    % 水平角度
    P_x=radio_process_anglex(filename);
    % figure;
    % n=1:31;
    % theta_x = linspace(-pi,pi,Ac_x);
    % mesh(theta_x/pi*180,n,db(abs(P_x)));
    % view(2);
    % xlim([-90 90]);
    % 俯仰角度
    P_y=radio_process_angley(filename);
    % figure;
    % n=1:31;
    % theta_y = linspace(-pi,pi,Ac_y);
    % mesh(theta_y/pi*180,n,db(abs(P_y)));
    % 
    % xlim([-90 90]);

    save(out_name,'pd_frame','P_x','P_y');

    fprintf("已经完成第"+i+"轮的数据导出，这次导出的数据是"+"的数据\n");
end
