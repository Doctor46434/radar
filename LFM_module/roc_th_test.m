%绘制不同信噪比下，实际接收机工作特性和理论接收机工作特性图
subplot(4,1,1)
roc_th(0);
hold on;
roc(0);
legend('SNR=0dB');
subplot(4,1,2)
roc_th(-5);
hold on;
roc(-5);
legend('SNR=-5dB');
subplot(4,1,3)
roc_th(5);
hold on;
roc(5);
legend('SNR=5dB');
subplot(4,1,4)
roc_th(-10);
hold on;
roc(-10);
legend('SNR=-10dB');