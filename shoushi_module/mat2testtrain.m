% 将所有数据写入一个mat文件中，但是最多5GB

maindir = 'K:\YRZ_temp\set_data';
subdir  = dir( maindir );


train_mat_pd=zeros(200*5,31,64,256);
test_mat_pd=zeros(50*5,31,64,256);
train_matp=zeros(200*5,31,2,1801);
test_matp=zeros(50*5,31,2,1801);
label_train=zeros(200*5,1);
label_test=zeros(50*5,1);
l=0;

for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..')||...
        ~subdir( i ).isdir)               % 如果不是目录则跳过
        continue;
    end
    l=l+1;
    subdirpath = fullfile( maindir, subdir( i ).name, '*.mat' );
    dat = dir( subdirpath );               % 子文件夹下找后缀为dat的文件

    for j = 1 : length( dat )
        datpath = fullfile( maindir, subdir( i ).name, dat( j ).name);
        load( datpath );
        % 此处添加你的对文件读写操作 %
        if j<=200
            train_mat_pd(200*(l-1)+j,:,:,:)=abs(pd_frame(:,:,:));
            train_matp(200*(l-1)+j,:,1,:)=abs(P_x(:,:));
            train_matp(200*(l-1)+j,:,2,:)=abs(P_y(:,:));
            label_train(200*(l-1)+j,1)=l-1;
            str = sprintf("已经完成第 %d 轮训练集写入，写入的数据是 %s",(200*(l-1)+j),datpath)
            
            fprintf('\n')
        else
            test_mat_pd(50*(l-1)+j-200,:,:,:)=abs(pd_frame(:,:,:));
            test_matp(50*(l-1)+j-200,:,1,:)=abs(P_x(:,:));
            test_matp(50*(l-1)+j-200,:,2,:)=abs(P_y(:,:));
            label_test(50*(l-1)+j-200,1)=l-1;
            str = sprintf("已经完成第 %d 轮测试集写入，写入的数据是 %s",(50*(l-1)+j-200),datpath)

            fprintf('\n')
        end
    end
end

save('K:\YRZ_temp\set_data\train_test_mat.mat','train_mat_pd','test_mat_pd','train_matp','test_matp','label_train','label_test');
