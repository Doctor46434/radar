t = 0:0.01:100;
x = cos(20*pi*t);
y = fft(x);
f = (-5000:5000)*1/100;
plot(f,abs(y));