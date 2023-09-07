% 将原始数据输出为复数数据，但是是错误的

function [a_cmp]=read_bin(filename)
% fid=fopen("D:\training\radio_test\sample_1.bin",'rb');
fid=fopen(filename,'rb');
%以int16的格式将数据存放在列向量中
[a,count]=fread(fid,'int16');

a_cmp=zeros(8,count/16);

for m=1:8
    for n=1:count/32
        a_cmp(m,n)=a(n*4-3+524288*2*(m-1))+1j*a(n*4-1+524288*2*(m-1));
        a_cmp(m,n+1)=a(n*4-2+524288*2*(m-1))+1j*a(n*4+524288*2*(m-1));
    end
end
fclose(fid);%关闭文件

% subplot(4,2,1);
% plot(abs(fftshift(fft(a_cmp(1,1:256*1024*2)))));
% title('1fft')
% subplot(4,2,2);
% plot(abs(fftshift(fft(a_cmp(2,1:256*1024*2)))));
% title('2fft')
% subplot(4,2,3);
% plot(abs(fftshift(fft(a_cmp(3,1:256*1024*2)))));
% title('3fft')
% subplot(4,2,4);
% plot(abs(fftshift(fft(a_cmp(4,1:256*1024*2)))));
% title('4fft')
% subplot(4,2,5);
% plot(abs(fftshift(fft(a_cmp(5,1:256*1024*2)))));
% title('5fft')
% subplot(4,2,6);
% plot(abs(fftshift(fft(a_cmp(6,1:256*1024*2)))));
% title('6fft')
% subplot(4,2,7);
% plot(abs(fftshift(fft(a_cmp(7,1:256*1024*2)))));
% title('7fft')
% subplot(4,2,8);
% plot(abs(fftshift(fft(a_cmp(8,1:256*1024*2)))));
% title('8fft')

% figure;
% plot(angle(fftshift(fft(a_cmp(1,1:256*1024*2)))));

end
