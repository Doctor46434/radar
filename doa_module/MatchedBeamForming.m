%% 参数
d=0.5;
M=16;
lambda=1;
theta_0=30*pi/180;
%% 作图
theta = [-90:0.01:90]*pi/180;
Spectrum = sin(pi*d*M/lambda.*(sin(theta)-sin(theta_0)))./sin(pi*d/lambda.*(sin(theta)-sin(theta_0)));
plot(theta*180/pi,db(Spectrum/max(Spectrum)));
xlabel("方位角/度");
ylabel("增益/dB");
xlim([-90 90]);
ylim([-80 0]);
txt = '\leftarrow 接近-13dB';
text(43,-13.14,txt);