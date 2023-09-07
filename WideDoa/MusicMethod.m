function [ArrivalAngle,SignalMapdB] = MusicMethod(SignalMat,ArrayNumber,ArrayDistance,WaveLength)
%MUSICMETHOD 用MUSIC方法对于信号到达角进行估计

SamplingNumber=3601;
TargetSignalNumber=1;
ArrayPosition = ArrayDistance * (0:ArrayNumber-1)';
StoriesNumber = size(SignalMat,2);

Angle = linspace(-pi,pi,SamplingNumber);
CovarianceMat = 1/StoriesNumber *(SignalMat*SignalMat');
[EigenVector,EigenvalueMAT]=eig(CovarianceMat);
Eigenvalue=diag(EigenvalueMAT)';
[Eigenvalue,I]=sort(Eigenvalue);
EigenVector=fliplr(EigenVector(:,I)); 
SignalMap=zeros(1,SamplingNumber);
for i = 1:SamplingNumber
    a = exp(1j * 2 * pi * ArrayPosition(:,1)* sin(Angle(i))/WaveLength); 
    En=EigenVector(:,TargetSignalNumber+1:ArrayNumber);                   % 取矩阵的第M+1到N列组成噪声子空间
    SignalMap(i)=1/(a'*(En*En')*a);
end
SignalMap=abs(SignalMap);
SignalMapdB=10*log10(abs(SignalMap)/max(abs(SignalMap))); 
%找到峰值
[peaks, locals] = findpeaks(SignalMapdB(1200:2400), Angle(1200:2400)/pi*180,'MinPeakHeight', -10);
[peaks,I] = sort(peaks); 
locals=fliplr(locals(:,I));
[locals,I] = sort(locals);
if length(locals)>TargetSignalNumber
    ArrivalAngle=locals(1:TargetSignalNumber)';
else
    ArrivalAngle=zeros(1,TargetSignalNumber);
end
% [~,AngleMaxKey]=max(SignalMapdB((SamplingNumber-1)/4:(SamplingNumber-1)*3/4));
% ArrivalAngle=(AngleMaxKey-902)/10;

% 
% plot(Angle * 180/pi,SignalMapdB);


end

