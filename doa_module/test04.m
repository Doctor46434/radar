N = 2000;

t=(0:1999)*1e-8;
x_1= 10*sin(1e7*t)+10*sin(1e6*t);
x_2= 10*sin(1e7*t-pi/6)+10*sin(1e6*t-pi/8);
x_3= 10*sin(1e7*t-pi/3)+10*sin(1e6*t-pi/4);

sigma =0;

x = x_1+sigma.*randn(1,N);
y = x_2+sigma.*randn(1,N);
z = x_3+sigma.*randn(1,N);

A = [x;y;z];




Rxx = A*A'./(N-1);
[V,D] = eig(Rxx);

figure(1)
plot3(A(1,:),A(2,:),A(3,:),'.');grid on;axis equal;hold on;

quiver3(0,0,0,V(1,1).*sqrt(D(1,1)).*5,V(2,1).*sqrt(D(1,1)).*5,V(3,1).*sqrt(D(1,1)).*5,'LineWidth',2)
quiver3(0,0,0,V(1,2)*sqrt(D(2,2)).*5,V(2,2)*sqrt(D(2,2)).*5,V(3,2)*sqrt(D(2,2)).*5,'LineWidth',2)
quiver3(0,0,0,V(1,3)*sqrt(D(3,3)).*5,V(2,3)*sqrt(D(3,3)).*5,V(3,3)*sqrt(D(3,3)).*5,'LineWidth',2)
hold off