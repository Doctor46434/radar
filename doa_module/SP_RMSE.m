
snr = -20:5:15;
n = length(snr);
rmse = zeros(1,n);
Angle = zeros(n,50);
for j = 1:n
    for i=1:50
        [Angle(j,i)] = Spatial_only(snr(j));
        i
        j
    end
    rmse(j) = sqrt(mean((Angle(j,:)).^2));
end