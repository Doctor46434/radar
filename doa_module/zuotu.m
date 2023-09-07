angle = -90:90/900:90;
% plot(angle,CSSMMap(900:2700),angle,ISSMMap(900:2700),angle,MusicMap(900:2700),angle,SPMap(900:2700));
% plot(angle,CSSMMap(900:2700),angle,ISSMMap(900:2700),angle,SPMap(900:2700));
plot(angle,SPMap(900:2700)-max(SPMap(900:2700)),angle,CSSMMap(900:2700)-max(CSSMMap(900:2700)));
% plot(angle,CSSMMap(900:2700)-max(CSSMMap(900:2700)),angle,OF1(900:2700)-max(OF1(900:2700)),angle,SPMap(900:2700)-max(SPMap(900:2700)));
% plot(angle,CSSMMap(900:2700),angle,OF1(900:2700),angle,SPMap(900:2700));
xlabel('方位角/度')
ylabel('增益/dB')
hold on;
txt1 = '\leftarrow 信号到达角0°';
% txt2 = '\leftarrow 干扰信号方向-10°';
txt3 = '\leftarrow 信号到达角30°';
text(0,-13.14,txt1);
% text(-10,-23.14,txt2);
text(30,-33.14,txt3);
plot(zeros(1,501)+0,-50:0.1:0,"--");
title('信噪比为10dB时归一化对数谱')

% plot(zeros(1,501)-10,-50:0.1:0,"--");
plot(zeros(1,501)+30,-50:0.1:0,"--");
legend('CSSM算法','Spatial-only算法','信号到达方向0°','信号到达方向30°');
ylim([-50 0]);