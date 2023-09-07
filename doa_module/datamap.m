num_layer = [1 2 3 4 5];
precision1 = [93.721 95.948 95.764 95.254 94.600];
recall1 = [95.564 92.529 92.903 95.587 94.055];
f1_measure1 = [94.633 94.207 94.312 95.420 94.327];
figure;
plot(num_layer,precision1,'-o',num_layer,recall1,'-x',num_layer,f1_measure1,'-s');
xlabel('num_layers');
ylabel('%');
legend('precision','recall','f1-measure');

hidden_size = [32 64 128 256];
precision2 = [91.929 95.948 96.240 96.097];
recall2 = [93.895 92.529 92.131 90.064];
f1_measure2 = [92.902 94.207 94.141 92.983];
figure;
plot(hidden_size,precision2,'-o',hidden_size,recall2,'-x',hidden_size,f1_measure2,'-s');
xlabel('hidden_size');
ylabel('%');
legend('precision','recall','f1-measure');