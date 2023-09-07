function [SignalMapdB] = CSM(SignalMat,ArrayNumber,ArrayDistance,WaveLength)
%CSM 此处显示有关此函数的摘要
%   此处显示详细说明
    FreqNum = 128;
    TargetSignalNumber = 1;
    LightSpeed = 3e8;
    CovMat = zeros(FreqNum,ArrayNumber,ArrayNumber);
    PowMat = zeros(FreqNum,ArrayNumber,ArrayNumber);
    SingularMat = zeros(FreqNum,ArrayNumber,ArrayNumber);
    Frequence = LightSpeed./WaveLength;
    Distance=ArrayDistance*[0:ArrayNumber-1 ]';
    for i = 1:FreqNum
        CovMat(i,:,:) = squeeze(SignalMat(i,:,:))*squeeze(SignalMat(i,:,:))';
    end
    for i =1:FreqNum
        temp=eig(squeeze(CovMat(i,:,:)));                                     
        temp=sort(temp);
        PowMat(i,:,:) = squeeze(CovMat(i,:,:))-(sum(temp)-temp(ArrayNumber))/(ArrayNumber-1)*eye(ArrayNumber,ArrayNumber);
    end
    for i = 1:FreqNum
        [~,SingularMat(i,:,:),~] = svd(squeeze(PowMat(i,:,:)));
    end
    SingularMean = zeros(FreqNum,ArrayNumber);
    for i = 1:FreqNum
        SingularMean(i,:) = sum(squeeze(SingularMat(i,:,:)));
    end
    SingularMeanMean=sum(SingularMean);
    SingularSum = zeros(1,ArrayNumber);
    for j=1:FreqNum
        for i=1:ArrayNumber 
            delta=SingularMean(j,i)-SingularMeanMean(1,i)/128;
            SingularSum(1,j)=sum(1,j)+delta^2;
        end 
    end
    [h,j]=min(SingularSum);

    Q = zeros(ArrayNumber,FreqNum*ArrayNumber);
    for i = 1:FreqNum
        [Q(:,(i-1)*ArrayNumber+1:i*ArrayNumber),~]=eig(squeeze(PowMat(i,:,:)));
    end
    Q_=Q(1+(j-1)*ArrayNumber*ArrayNumber:j*ArrayNumber*ArrayNumber); 
    QRE=reshape(Q_,ArrayNumber,ArrayNumber);
    T = zeros(FreqNum,ArrayNumber,ArrayNumber);
    for i = 1:FreqNum
        T(i,:,:) = QRE*Q(:,(i-1)*ArrayNumber+1:i*ArrayNumber)';
    end
    CovY = zeros(ArrayNumber,ArrayNumber);
    for i = 1:ArrayNumber
        CovY = CovY + squeeze(T(i,:,:))*squeeze(SignalMat(i,:,:))*(squeeze(T(i,:,:))*squeeze(SignalMat(i,:,:)))';
    end
    % MUSIC算法估计
    [U,~,~]=svd(CovY); 
    Vu=U(:,1+1:16);  
    Angle=[-90:0.1:90]'; 
    ArrayVector=1j* 2*pi*Frequence(j)/LightSpeed *sin(Angle'* pi/180); 
    a2=Distance*ArrayVector; 
    a2=exp(a2); 
    num=diag(a2'*a2);
    Ena=Vu'* a2; 
    den=diag(Ena'* Ena);
    doa=(num./den);
    semilogy(Angle, abs(doa),'-'); 
    SignalMapdB=abs(doa);
end

