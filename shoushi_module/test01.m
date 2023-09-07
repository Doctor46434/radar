% 教你如何保存为GIF图像

data = readDCA1000("D:\training\radio_test\left_6\left_6_Raw_0.bin");
% data_1 = bin_func4("adc_data_for1.bin");
% data = zeros(8,524288);
% for i = 1:4
%     for j = 1:2:32*64*2
%         data(2*i-1,(j-1)*256+1:j*256) = data_1(i,(j-1)*256+1:j*256);
%         data(2*i,(j-1)*256+1:j*256) = data_1(i,j*256+1:(j+1)*256);
%     end
% end
path = 2;
k = 105.008e+12;
Tp = 38e-6;
n = 0:1023;
fs = 1e+7;
t = n/fs;
t_ADC = 6e-6;
f0 = 77e+9;
sb = zeros(64,256);
sb_mti = zeros(64,256);
for frame = 0:31
    for i = 0:63
        sb(i+1,:) = data(path,frame*64*256+256*i+1:frame*64*256+256*(i+1));
        sb_0 = sb(i+1,:);
        if i>0
            sb_mti(i+1,:) = sb_0-sb_1;
        end
        sb_1 = sb_0;
    end
    Sb = fftshift(fft2(sb));
    Sb_mti = fftshift(fft2(sb_mti));
    imagesc(abs(Sb_mti));
%     imagesc(abs(sb));
    pause(0.2);
    frame0 = getframe;%截取动画帧，保存到frame变量中
    data_p=frame2im(frame0);%转化为彩色图片
    [I,map] = rgb2ind(data_p,256);%rgb转化为索引图
    if frame==0
        imwrite(I,map,'image.gif','gif','loopcount',inf,'Delaytime',0.02)
    else
        imwrite(I,map,'image.gif','gif','writemode','append','Delaytime',0.02)
    end
end