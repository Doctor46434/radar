% 将很多mat转换到一个mat中

namelist_left = dir('K:\YRZ_temp\set_data\left\*.mat');
sort_nat_name_left=sort_nat({namelist_left.name}); 
namelist_pull = dir('K:\YRZ_temp\set_data\pull\*.mat');
sort_nat_name_pull=sort_nat({namelist_pull.name}); 
namelist_pull_push = dir('K:\YRZ_temp\set_data\pull_push\*.mat');
sort_nat_name_pull_push=sort_nat({namelist_pull_push.name}); 
namelist_push = dir('K:\YRZ_temp\set_data\push\*.mat');
sort_nat_name_push=sort_nat({namelist_push.name}); 
namelist_push_pull = dir('K:\YRZ_temp\set_data\push_pull\*.mat');
sort_nat_name_push_pull=sort_nat({namelist_push_pull.name}); 


all_matpd=zeros(1250,31,64,256);
all_matpx=zeros(1250,31,1801);
all_matpy=zeros(500,31,1801);
for i=1:250
    filename=cell2mat([namelist_left(i).folder '\' sort_nat_name_left(i)]);
    fprintf(cell2mat(sort_nat_name_left(i)))
    fprintf('\n')
    load(filename);
    all_matpd(i,:,:,:)=abs(pd_frame(:,:,:));
    all_matpx(i,:,:)=abs(P_x(:,:));
    all_matpy(i,:,:)=abs(P_y(:,:));
end

for i=1:250
    filename=cell2mat([namelist_pull(i).folder '\' sort_nat_name_pull(i)]);
    fprintf(cell2mat(sort_nat_name_pull(i)));
    fprintf('\n')
    load(filename);
    all_matpd(i+250,:,:,:)=abs(pd_frame(:,:,:));
    all_matpx(i+250,:,:)=abs(P_x(:,:));
    all_matpy(i+250,:,:)=abs(P_y(:,:));
end


save('K:\YRZ_temp\set_data\left_pull_pd.mat','all_matpd','all_matpx','all_matpy');