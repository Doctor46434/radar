t=0:1e-8:1e-5;
x_1= 10*sin(1e7*t)+randn(1,1001);
x_2= 10*sin(1e7*t-pi/6)+randn(1,1001);
x_3= 10*sin(1e7*t-pi/3)+randn(1,1001);
% x_1= 10*sin(1e7*t);
% x_2= 10*sin(1e7*t-pi/6);
% x_3= 10*sin(1e7*t-pi/3);
D=[x_1;x_2;x_3];
Rxx=D*D'./1001;
[V,D] = eig(Rxx);
plot3(x_1,x_2,x_3,'.');
hold on;
% quiver3(0,0,V(1,1).*sqrt(D(1,1)),V(2,1).*sqrt(D(1,1)),'LineWidth',1)
quiver3(0,0,0,V(1,1).*sqrt(D(1,1)),V(2,1).*sqrt(D(1,1)).*5,'LineWidth',1)
quiver3(0,0,0,V(1,2)*sqrt(D(2,2)),V(2,2)*sqrt(D(2,2)).*5,'LineWidth',1)
quiver3(0,0,0,V(1,3)*sqrt(D(3,3)),V(2,3)*sqrt(D(3,2)).*5,'LineWidth',1)