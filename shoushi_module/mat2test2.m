maindir = 'K:\YRZ_temp\yipeng_data';
targetdir = 'K:\YRZ_temp\yipeng_train1';
subdir  = dir( maindir );
l=0;

for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..')||...
        ~subdir( i ).isdir)               % 如果不是目录则跳过
        continue;
    end
    l=l+1;
    subdirpath = fullfile( maindir, subdir( i ).name, '*.mat' );
    dat = dir( subdirpath );               % 子文件夹下找后缀为mat的文件
    mkdir(targetdir,subdir(i).name);
    for j = 1 : length( dat )
        datpath = fullfile( maindir, subdir( i ).name, dat( j ).name);
        datsplit = split(dat( j ).name,'.');
        strtarget = j+".mat"; 
        targetfile = fullfile( targetdir, subdir( i ).name,strtarget);
        pd_frame=radio_process(datpath);
        P_x=radio_process_anglex(datpath);
        P_y=radio_process_angley(datpath);
        % 此处添加你的对文件读写操作 %
        save(targetfile,'pd_frame','P_x','P_y');
        str = "已经将"+datpath+"中的数据写入到"+targetfile+"中"
        if j>10
            break
        end
    end
end


    