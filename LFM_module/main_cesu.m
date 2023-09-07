%%分别计算在不同信噪比下频率估计值
[f1,y1,max1]=cesu(20);
[f2,y2,max2]=cesu(15);
[f3,y3,max3]=cesu(10);
[f4,y4,max4]=cesu(5);
[f5,y5,max5]=cesu(0);

subplot(5,1,1);
stem(f1,y1);
title("信噪比为20dB似然函数值");
xlabel("频率");
ylabel("幅度");
subplot(5,1,2);
stem(f2,y2);
title("信噪比为15dB似然函数值");
xlabel("频率");
ylabel("幅度");
subplot(5,1,3);
stem(f3,y3);
title("信噪比为10dB似然函数值");
xlabel("频率");
ylabel("幅度");
subplot(5,1,4);
stem(f4,y4);
title("信噪比为5dB似然函数值");
xlabel("频率");
ylabel("幅度");
subplot(5,1,5);
stem(f5,y5);
title("信噪比为0dB似然函数值");
xlabel("频率");
ylabel("幅度");

%%计算不同信噪比下的方差值
max=zeros(5,100);

for i=1:100

[~,~,max(1,i)]=cesu(20);
[~,~,max(2,i)]=cesu(15);
[~,~,max(3,i)]=cesu(10);
[~,~,max(4,i)]=cesu(5);
[~,~,max(5,i)]=cesu(0);

end

max1_mean=mean(max(1,:));
max2_mean=mean(max(2,:));
max3_mean=mean(max(3,:));
max4_mean=mean(max(4,:));
max5_mean=mean(max(5,:));
max1_var=var(max(1,:));
max2_var=var(max(2,:));
max3_var=var(max(3,:));
max4_var=var(max(4,:));
max5_var=var(max(5,:));