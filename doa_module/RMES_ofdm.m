%测试OFDM窄带算法的均方根误差 
snr=[-15 -10 -5 0 5 10];

ArrivalAngle1=zeros(6,1000);
ArrivalAngle2=zeros(6,1000);
ArrivalAngle3=zeros(6,1000);
ArrivalAngle4=zeros(6,1000);
ArrivalAngle5=zeros(6,1000);
ArrivalAngle6=zeros(6,1000);

rmse1 = zeros(6,1);
rmse2 = zeros(6,1);
rmse3 = zeros(6,1);
rmse4 = zeros(6,1);
rmse5 = zeros(6,1);
rmse6 = zeros(6,1);
for i=1:6
    for j=1:20
        [ArrivalAngle1(i,j),ArrivalAngle2(i,j)]=ofdm_doa(snr(i));
        [ArrivalAngle3(i,j),ArrivalAngle4(i,j)]=ofdm_doa_wide(snr(i));
        [ArrivalAngle5(i,j)]=issm(snr(i));
        [ArrivalAngle6(i,j)]=cssm(snr(i));
        str = "信噪比为"+snr(i)+"dB情况下，第"+j+"轮"
    end
    rmse1(i,1) = sqrt(mean((ArrivalAngle1(i,:)).^2));
    rmse2(i,1) = sqrt(mean((ArrivalAngle2(i,:)).^2));
    rmse3(i,1) = sqrt(mean((ArrivalAngle3(i,:)).^2));
    rmse4(i,1) = sqrt(mean((ArrivalAngle4(i,:)).^2));
    rmse5(i,1) = sqrt(mean((ArrivalAngle4(i,:)).^2));
    rmse6(i,1) = sqrt(mean((ArrivalAngle4(i,:)).^2));
end

% for i=1:6
%     rmse1(i,1) = sqrt(mean((ArrivalAngle1(i,1:20)-30).^2));
%     rmse2(i,1) = sqrt(mean((ArrivalAngle2(i,1:20)-30).^2));
% end

% plot(snr,db(rmse1+1e-5),'-ro',snr,(rmse2+1e-5),'-go',snr,(rmse3+1e-5),'-bs',snr,(rmse4+1e-5),'-s');
% plot(snr,(rmse2+1e-5),'-bs',snr,db(rmse3+1e-5),'-s');
plot(snr,(rmse1+1e-5),'-ro',snr,db(rmse2+1e-5),'-go',snr,(rmse3+1e-5),'-bs');
legend('CSSM','OFDM窄带分解','OFDM窄带合成');
% legend('CSSM','Spatial-only');
xlabel("信噪比(dB)");
ylabel("RMSE(dB)");
title("不同信噪比下的RMSE");