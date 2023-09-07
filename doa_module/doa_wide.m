%% 参数 Parameters
ArrayNumber   = 12;               % 阵元数目
LightSpeed   = 3e8;              % 光速
TargetAngle = [30]*pi/180;             % 信号角度
TargetSignalNumber  = length(TargetAngle);                % 目标信号数目
snr = 20;               % 信噪比
SimplingNumber  = 3601;             % 角度采样数
SubCarrySignalNumber = 52;   % 信号子载频数量
FrequenceStart = 20e6;  %子载波起始频率
FrequenceSpacing = 312.5e3;  %子载波频率间隔
FrequenceValue = FrequenceSpacing*[0:SubCarrySignalNumber-1]+FrequenceStart;%子载频频率
StoriesNumber = 1024; %快拍数
SamplingRate = 100e6;
WaveLength   = LightSpeed./FrequenceValue;              % 波长
ArrayDistance   = LightSpeed/FrequenceStart/2/2;              % 阵元间隔
%% 信号构造 
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
