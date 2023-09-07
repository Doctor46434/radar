function [ArrivalAngle1,ArrivalAngle2]=ofdm_doa(snr)
%% 参数 Parameters
ArrayNumber   = 12;               % 阵元数目
LightSpeed   = 3e8;              % 光速
TargetAngle = [10]*pi/180;             % 信号角度
TargetSignalNumber  = length(TargetAngle);                % 目标信号数目
% snr = 10;               % 信噪比
SimplingNumber  = 3601;             % 角度采样数
SubCarrySignalNumber = 52;   % 信号子载频数量
FrequenceStart = 20e6;  %子载波起始频率
FrequenceSpacing = 312.5e3;  %子载波频率间隔
FrequenceValue = FrequenceSpacing*[0:SubCarrySignalNumber-1]+FrequenceStart;%子载频频率
StoriesNumber = 1024; %快拍数
SamplingRate = 100e6;
WaveLength   = LightSpeed./FrequenceValue;              % 波长
ArrayDistance   = LightSpeed/FrequenceStart/2/2;              % 阵元间隔
%% 算法

% 导向矢量
ArrayVector = zeros(SubCarrySignalNumber,ArrayNumber);
for i=1:ArrayNumber
    ArrayVector(:,i) = exp(-1j*2*pi*ArrayDistance.*FrequenceValue.*i*sin(TargetAngle)/LightSpeed);
end
% 子载波信号
SubSignalMat = zeros(SubCarrySignalNumber,StoriesNumber);
TimeMat = 1:1024; 
for i=1:SubCarrySignalNumber
    SubSignalMat(i,:) =sqrt(10^(snr/10))*randn(1,StoriesNumber).*exp(-1j*2*pi*FrequenceValue(i)*TimeMat/SamplingRate);
end
% 总信号矢量
AllSignalMat = zeros(SubCarrySignalNumber,ArrayNumber,StoriesNumber);
noise = (randn(ArrayNumber,StoriesNumber)+1j*randn(ArrayNumber,StoriesNumber))/sqrt(2);
for i=1:SubCarrySignalNumber
    AllSignalMat(i,:,:) = ArrayVector(i,:)'*SubSignalMat(i,:)+noise;
end



LCMVArrivalAngle=zeros(1,SubCarrySignalNumber);
MUISCArrivalAngle=zeros(1,SubCarrySignalNumber);
LcmvMap = zeros(52,3601);
MusicMap = zeros(52,3601);
for i=1:SubCarrySignalNumber
    [LCMVArrivalAngle(i),LcmvMap(i,:)]=LcmvMethod(squeeze(AllSignalMat(i,:,:)),ArrayNumber,ArrayDistance,WaveLength(i));
    [MUISCArrivalAngle(i),MusicMap(i,:)]=MusicMethod(squeeze(AllSignalMat(i,:,:)),ArrayNumber,ArrayDistance,WaveLength(i));
end
LcmvMapAll = zeros(1,3601);
MusicMapAll = zeros(1,3601);
for i=1:3601
    LcmvMapAll(i) = mean(LcmvMap(:,i));
    MusicMapAll(i) = mean(MusicMap(:,i));
end
CSSMMap = LcmvMapAll;
OF1 = MusicMapAll;
ArrivalAngle1=mean(LCMVArrivalAngle);
ArrivalAngle2=mean(MUISCArrivalAngle);
end