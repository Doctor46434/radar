f0=1e5;
Tp=1e-5;
B=1e6;
fs=1e8;
R0=3e3;
c=3e8;
tau=2*R0/c;
k=B/Tp;

t=0:1e-8:1e-5;
y =exp(1j*pi*k.*(t-tau).^2)*exp(-1j*2*pi*f0*tau);
x= sin(1e7*pi*t);

plot(t,x);
xlim([1e-8 1e-5 - 950*1e-8]);
ylim([-2 2]);
hold on;

for i=1:12
    stem(1e-8*(i*3-1) ,x(i*3),'r-','linewidth',1.5);
end

% plot(t,y,'r-','linewidth',1.5);
% plot(t,y,'r-','linewidth',1.5);