function [SignalMapdB] = CssmMethodHead(SignalMat,ArrayNumber,ArrayDistance,WaveLength,PreAngle)
%CSSMMETHODHEAD CSSM算法
    % 计算信号去噪矩阵
    FreqNum = 128;
    TargetSignalNumber = 1;
    LightSpeed = 3e8;
    EigenVectorPow = zeros(FreqNum,ArrayNumber,ArrayNumber);
    SignalCovariance = zeros(FreqNum,TargetSignalNumber,TargetSignalNumber);
    PowerMat = zeros(FreqNum,ArrayNumber,ArrayNumber);
    TimeDelay = sin([30]')*(0:ArrayNumber-1)*ArrayDistance/LightSpeed;
    for i=1:FreqNum
        [EigenVectorPow(i,:,:),SignalCovariance(i,:,:),PowerMat(i,:,:)] = CssmMethod(squeeze(SignalMat(i,:,:)),ArrayNumber,ArrayDistance,WaveLength(i));
    end
    SignalCovarianceF0 = zeros(TargetSignalNumber,TargetSignalNumber);
    for i=1:FreqNum
        SignalCovarianceF0 = SignalCovarianceF0 + squeeze(SignalCovariance(i,:,:));
    end
    SignalCovarianceF0 = SignalCovarianceF0./FreqNum;
    % 计算聚焦频率值
    A = zeros(TargetSignalNumber,ArrayNumber);
    SingularValue = zeros(FreqNum,ArrayNumber);
    for j=1:FreqNum
         SingularValue(j,:) = svd(squeeze(PowerMat(j,:,:)));
    end
    Frequence = (1:10000)*1e1;
    SvdMap = zeros(1,10000);
    for i=1:10000
        for k=1:TargetSignalNumber
            A(k,:) = exp(-1j*2*pi*Frequence(i)*TimeDelay(k,:));
        end
        Power0 = A'*SignalCovarianceF0*A;
        Power0Value = svd(Power0);
        for j=1:ArrayNumber
            SvdMap(i)=SvdMap(i)+(Power0Value(j)-mean(SingularValue(:,j)))^2;
        end
    end
    % plot(Frequence,SvdMap);
    [~,Frequence0] = min(SvdMap);
    Frequence0 = Frequence0*1e5;
    % 利用聚焦频率值计算聚焦矢量
    for k=1:TargetSignalNumber
            A0(k,:) = exp(-1j*2*pi*Frequence0*TimeDelay(k,:));
    end
    Power0 = A0'*SignalCovarianceF0*A0;
    [EigenVectorPow0,EigenvalueMATPow0]=eig(Power0);
    EigenvaluePow0=diag(EigenvalueMATPow0)';
    [EigenvaluePow0,I]=sort(EigenvaluePow0);
    EigenVectorPow0=fliplr(EigenVectorPow0(:,I)); 
    T = zeros(FreqNum,ArrayNumber,ArrayNumber);
    R_fi = zeros(FreqNum,ArrayNumber,ArrayNumber);
    R_f0 = zeros(ArrayNumber,ArrayNumber);
    for i=1:FreqNum
        T(i,:,:) = EigenVectorPow0'*squeeze(EigenVectorPow(i,:,:));
        R_fi(i,:,:) = squeeze(T(i,:,:))'*squeeze(PowerMat(i,:,:))*squeeze(T(i,:,:));
        R_f0 = R_f0 + squeeze(R_fi(i,:,:));
    end
    R_f0 = R_f0./FreqNum;
    % 利用MUSIC算法计算该聚焦矩阵角度
    SamplingNumber = 3601;
    ArrayPosition = ArrayDistance * (0:ArrayNumber-1)';
    Angle = linspace(-pi,pi,SamplingNumber);
    [EigenVector,EigenvalueMAT]=eig(R_f0);
    Eigenvalue=diag(EigenvalueMAT)';
    [Eigenvalue,I]=sort(Eigenvalue);
    EigenVector=fliplr(EigenVector(:,I));
    for i = 1:SamplingNumber
        a = exp(-1j * 2 * pi * ArrayPosition(:,1)* sin(Angle(i))*Frequence0/LightSpeed); 
        En=EigenVector(:,TargetSignalNumber+1:ArrayNumber);                   % 取矩阵的第M+1到N列组成噪声子空间
        SignalMap(i)=1/(a'*(En*En')*a);
    end
    SignalMap=abs(SignalMap);
    SignalMapdB=10*log10(abs(SignalMap)/max(abs(SignalMap)));
end

