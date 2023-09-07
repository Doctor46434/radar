%%理论分析匹配滤波器接收虚警概率和检测概率,绘制接收机工作特性理论图像
function roc_th(SNR)
lambda=0:0.1:100;


SNR_10=10^(SNR/10);
pf=erfc(1/2*sqrt(1/SNR_10)*log(lambda)+1/2*sqrt(SNR_10))/2;
pd=erfc(1/2*sqrt(1/SNR_10)*log(lambda)-1/2*sqrt(SNR_10))/2;   
plot(pf,pd);     
hold on;


xlabel('虚警概率(pf)');
ylabel('检测概率(pd)');
title('接收机工作特性(roc)');
