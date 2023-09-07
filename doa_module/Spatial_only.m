% function [Angle] = Spatial_only(snr)
%% 参数 Parameters
ArrayNumber   = 64;               % 阵元数目
LightSpeed   = 3e8;              % 光速
TargetAngle = [0]*pi/180;             % 信号角度
TargetSignalNumber  = length(TargetAngle);                % 目标信号数目
snr = 10;               % 信噪比
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
    SubSignalMat(i,:) =sqrt(10^(snr/10))*ones(1,StoriesNumber).*exp(-1j*2*pi*FrequenceValue(i)*TimeMat/SamplingRate);
end
% 总信号矢量
AllSignalMat = zeros(ArrayNumber,StoriesNumber);
noise = (randn(ArrayNumber,StoriesNumber)+1j*randn(ArrayNumber,StoriesNumber))/sqrt(2);
for i=1:SubCarrySignalNumber
    AllSignalMat =AllSignalMat + ArrayVector(i,:)'*SubSignalMat(i,:)+noise;
end

CorMat = zeros(ArrayNumber-1,1);
for i=2:ArrayNumber
    CorMat(i-1,:) = mean(conj(AllSignalMat(1,:)).*AllSignalMat(i,:));
end
a = zeros(3601,ArrayNumber-1);
Angle = -pi:2*pi/3600:pi;
for i=1:3601
    for j=1:ArrayNumber-1
        a(i,j) = exp(1j*pi*(SubCarrySignalNumber-1)*FrequenceSpacing*ArrayDistance*sin(Angle(i))*j/ ...
            LightSpeed)*sin(pi*SubCarrySignalNumber*FrequenceSpacing*ArrayDistance*sin(Angle(i))*j/ ...
            LightSpeed)/sin(pi*FrequenceSpacing*ArrayDistance*sin(Angle(i))*j/ ...
            LightSpeed);
    end
end
% for i=1:3601
%     for j=1:ArrayNumber-1
%         a(i,j) = exp(1j*pi*(2*FrequenceStart+FrequenceSpacing*(SubCarrySignalNumber-1))*ArrayDistance*sin(Angle(i))*j/ ...
%             LightSpeed)*sinc(pi*(SubCarrySignalNumber-1)*FrequenceSpacing*ArrayDistance*sin(Angle(i))*j/ ...
%             LightSpeed);
%     end
% end
PA = zeros(3601,ArrayNumber-1,ArrayNumber-1);
for i=1:3601
    PA(i,:,:) = a(i,:)'*1/(a(i,:)*a(i,:)')*a(i,:);
    PA(i,:,:) = eye(ArrayNumber-1,ArrayNumber-1)-squeeze(PA(i,:,:));
end

Map = zeros(1,3601);
for i=1:3601
    Map(i) = 1/(CorMat'*squeeze(PA(i,:,:))*CorMat);
end
Map = 10*log10(abs(Map)/max(abs(Map)));
SPMap = Map;
plot(Angle/pi*180,Map);
[~,maxAngle]= max(Map(900:2700));
Angle = (maxAngle-901)/10;
% end

