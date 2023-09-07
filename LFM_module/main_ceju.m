%%分别计算在不同信噪比下时延估计值
[t1,y1,td1]=ceju(20);
[t2,y2,td2]=ceju(10);
[t3,y3,td3]=ceju(0);
[t4,y4,td4]=ceju(-10);
[t5,y5,td5]=ceju(-20);
subplot(5,1,1);
stem(t1,y1);
title("信噪比为20dB似然函数值，时延为"+td1);
xlabel("频率");
ylabel("幅度");
subplot(5,1,2);
stem(t2,y2);
title("信噪比为15dB似然函数值，时延为"+td2);
xlabel("频率");
ylabel("幅度");
subplot(5,1,3);
stem(t3,y3);
title("信噪比为10dB似然函数值，时延为"+td3);
xlabel("频率");
ylabel("幅度");
subplot(5,1,4);
stem(t4,y4);
title("信噪比为5dB似然函数值，时延为"+td4);
xlabel("频率");
ylabel("幅度");
subplot(5,1,5);
stem(t5,y5);
title("信噪比为0dB似然函数值，时延为"+td5);
xlabel("频率");
ylabel("幅度");


%%分别计算在不同信噪比下时延方差

max=zeros(5,30);

for i=1:30

[~,~,max(1,i)]=ceju(20);
[~,~,max(2,i)]=ceju(10);
[~,~,max(3,i)]=ceju(0);
[~,~,max(4,i)]=ceju(-10);
[~,~,max(5,i)]=ceju(-20);

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