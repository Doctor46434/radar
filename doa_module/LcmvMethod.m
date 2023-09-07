function [ArrivalAngle,SignalMapdB] = LcmvMethod(SignalMat,ArrayNumber,ArrayDistance,WaveLength)
%LCMVMETHOD 用LCMV方法对于信号到达角进行估计

SamplingNumber=3601;
ArrayPosition = ArrayDistance * (0:ArrayNumber-1)';
StoriesNumber = size(SignalMat,2);

Angle = linspace(-pi,pi,SamplingNumber);
CovarianceMat = 1/StoriesNumber *(SignalMat*SignalMat');
CovarianceMatInverse = pinv(CovarianceMat);
SignalMap = zeros(1,SamplingNumber);
for i = 1:SamplingNumber
    a = exp(1j * 2 * pi * ArrayPosition(:,1)* sin(Angle(i))/WaveLength);
    SignalMap(i) = a'*CovarianceMatInverse* a;
end
SignalMapdB = 10*log10(abs(SignalMap)/max(abs(SignalMap)));
SignalMapdB = -SignalMapdB+min(SignalMapdB);

[~,AngleMaxKey]=max(SignalMapdB((SamplingNumber-1)/4:(SamplingNumber-1)*3/4));
ArrivalAngle=(AngleMaxKey-(SamplingNumber-1)/4-2)/10;



% plot(Angle * 180/pi,SignalMapdB);
% xlim([-90 90]);
% hold on;

end

