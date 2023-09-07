NoOfCarriers = 11;              % 设定载波的数量（需要保证是奇数）
iMin = -(NoOfCarriers-1)/2;     % 最小的子载波的索引
iMax = (NoOfCarriers-1)/2;      % 最大的子载波的索引
f = -10:0.01:10;                % 设定频率是从-10MHz到10MHz
fList = zeros(1,NoOfCarriers);  % 频率列表，用来存储各sinc函数的中心频率
cList = zeros(1,NoOfCarriers);  % 幅值列表，用来存储各sinc函数的幅值
%************************** 画出各OFDM子载波的频域图 **************************%
for i=iMin:1:iMax
    % 计算出每一个OFDM子载波的sinc函数
    fshift = i ;
    c = sinc(f - fshift);
    fList(i+NoOfCarriers) =  fshift;
    cList(i+NoOfCarriers) = max(c);
    plot(f+50,c,'linewidth',1.5);
    hold on;
    stem(i+50 ,1,'r-','linewidth',1.5);
end
xlabel("频率 MHz");
grid();
hold off;