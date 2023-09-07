maindir = 'D:\training\test20230329';
subdir  = dir( maindir );
l=0;


train_mat_pd=zeros(1,31,64,256);
test_mat_pd=zeros(10*16,31,64,256);
train_matp=zeros(1,31,2,1801);
test_matp=zeros(10*16,31,2,1801);
label_train=zeros(1,1);
label_test=zeros(10*16,1);

for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..')||...
        ~subdir( i ).isdir)               % 如果不是目录则跳过
        continue;
    end
    l=l+1;
    subdirpath = fullfile( maindir, subdir( i ).name, '*.mat' );
    dat = dir( subdirpath );               % 子文件夹下找后缀为mat的文件

    for j = 1 : length( dat )
        datpath = fullfile( maindir, subdir( i ).name, dat( j ).name);
        pd_frame=radio_process(datpath);
        P_x=radio_process_anglex(datpath);
        P_y=radio_process_angley(datpath);
        % 此处添加你的对文件读写操作 %
        if j<=0
            train_mat_pd(200*(l-1)+j,:,:,:)=abs(pd_frame(:,:,:));
            train_matp(200*(l-1)+j,:,1,:)=abs(P_x(:,:));
            train_matp(200*(l-1)+j,:,2,:)=abs(P_y(:,:));
            label_train(200*(l-1)+j,1)=l-1;
            str = sprintf("已经完成第 %d 轮训练集写入，写入的数据是 %s",(200*(l-1)+j),datpath)
            
            fprintf('\n')
        else
            test_mat_pd(10*(l-1)+j,:,:,:)=abs(pd_frame(:,:,:));
            test_matp(10*(l-1)+j,:,1,:)=abs(P_x(:,:));
            test_matp(10*(l-1)+j,:,2,:)=abs(P_y(:,:));
            label_test(10*(l-1)+j,1)=l-1;
            str = sprintf("已经完成第 %d 轮测试集写入，写入的数据是 %s",(10*(l-1)+j),datpath)

            fprintf('\n')
        end
    end
end

save('D:\training\test20230329\train_test_mat16.mat','train_mat_pd','test_mat_pd','train_matp','test_matp','label_train','label_test');
