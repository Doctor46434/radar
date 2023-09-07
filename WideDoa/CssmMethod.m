function [EigenVectorPow,SignalCovariance,PowerMat] = CssmMethod(SignalMat,ArrayNumber,ArrayDistance,WaveLength)
% 设定参数
TargetSignalNumber = 1;
LightSpeed = 3e8;
Frequence = LightSpeed/WaveLength;
StoriesNumber = size(SignalMat,2);
% 计算协方差矩阵及特征值
CovarianceMat = 1/StoriesNumber *(SignalMat*SignalMat');
[EigenVector,EigenvalueMAT]=eig(CovarianceMat);
Eigenvalue=diag(EigenvalueMAT)';
[Eigenvalue,I]=sort(Eigenvalue);
EigenVector=fliplr(EigenVector(:,I)); 
% 计算去噪协方差矩阵及特征值
VarSigma = mean(Eigenvalue(1:ArrayNumber-1));
PowerMat = CovarianceMat - VarSigma*eye(ArrayNumber,ArrayNumber);
[EigenVectorPow,EigenvalueMATPow]=eig(PowerMat);
% 估计到达角
[MUISCArrivalAngle,~]=MusicMethod(SignalMat,ArrayNumber,ArrayDistance,WaveLength);
% 根据到达角设置导向矢量
TimeDelay = sin(MUISCArrivalAngle)*(0:ArrayNumber-1)*ArrayDistance/LightSpeed;
A = zeros(TargetSignalNumber,ArrayNumber);
for i=1:TargetSignalNumber
        A(i,:) = exp(-1j*2*pi*Frequence*TimeDelay(i,:));
end
SignalCovariance = (A*A')\A*PowerMat*A'/(A*A');

end