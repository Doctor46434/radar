% 绘制理论情况下的检测概率和信噪比之间的关系

SNR=0:1:20
pd=zeros(1,21);
for i=1:21

SNR_10=10^(SNR(i)/10);
pf=1e-6;
fun=@(lambda)erfc(1/2*sqrt(1/SNR_10)*log(lambda)+1/2*sqrt(SNR_10))/2-pf;

[lambda,fval]=fsolve(fun,rand);

pd(i)=erfc(1/2*sqrt(1/SNR_10)*log(lambda)-1/2*sqrt(SNR_10))/2;  


end
plot(SNR,pd,'r*');
xlabel('信噪比');
ylabel('检测概率');
title('检测概率与信噪比之间的关系，pf=1e-6');

