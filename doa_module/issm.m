% function [Angle] = issm(snr)
%% 参数 Parameters
ArrayNumber   = 16;               % 阵元数目
LightSpeed   = 3e8;              % 光速
TargetAngle = [0 10]*pi/180;             % 信号角度
TargetSignalNumber  = length(TargetAngle);                % 目标信号数目
snr = 15;               % 信噪比
SimplingNumber  = 3601;             % 角度采样数
SubCarrySignalNumber = 52;   % 信号子载频数量
FrequenceStart = 20e6;  %子载波起始频率
FrequenceSpacing = 312.5e3;  %子载波频率间隔
FrequenceValue = FrequenceSpacing*[0:SubCarrySignalNumber-1]+FrequenceStart;%子载频频率
StoriesPerFreq = 64; %每个频率的采样点数
FreqNum = 128;%分成的频段
Stories = FreqNum*StoriesPerFreq; %总快拍数
Simplingrate = 1e9;
ArrayDistance = LightSpeed/FrequenceStart/2/2;
%% 算法 
X = zeros(FreqNum,ArrayNumber,StoriesPerFreq);
S = zeros(FreqNum,TargetSignalNumber,StoriesPerFreq);
A = zeros(FreqNum,TargetSignalNumber,ArrayNumber);
N = zeros(FreqNum,ArrayNumber,StoriesPerFreq);
TimeDelay = sin(TargetAngle)'*(0:ArrayNumber-1)*ArrayDistance/LightSpeed;
FreqFFT = (1:FreqNum)/FreqNum*Simplingrate;
WaveLength = LightSpeed./FreqFFT;

t = (1:Stories)/Simplingrate;
SignalTime = zeros(1,Stories);
for i = 1:SubCarrySignalNumber
    for j = 1:TargetSignalNumber
        SignalTime = SignalTime + sqrt(10^(snr/10))*randn(1,Stories).*exp(-1j*2*pi*FrequenceValue(i)*t);
    end
end

SignalFFT = zeros(FreqNum,StoriesPerFreq);
for i = 1:StoriesPerFreq
    SignalFFT(:,i) = fft(SignalTime(FreqNum*(i-1)+1:i*(FreqNum)));
end


% 构造信号源
for i=1:TargetSignalNumber
    for j=1:FreqNum
        for k=1:StoriesPerFreq
            % if j<114
            %     S(j,i,k)=0;
            % else
            %     S(j,i,k)=1;
            % end
            S(j,i,k)=SignalFFT(j,k);
        end
    end
end
%构造导向矢量
for i=1:TargetSignalNumber
    for j=1:FreqNum
        % for k=1:ArrayNumber
        %     A(j,i,k) = exp(-1j*2*pi*FreqFFT(j)*TimeDelay(k,i));
        % end
        A(j,i,:) = exp(-1j*2*pi*FreqFFT(j)*TimeDelay(i,:));
    end
end
%噪声
for i=1:FreqNum
    N(i,:,:) = (randn(ArrayNumber,StoriesPerFreq)+1j*randn(ArrayNumber,StoriesPerFreq))/sqrt(2)/128/31.6;
    % N(i,:,:) = (ones(ArrayNumber,StoriesPerFreq)+1j*ones(ArrayNumber,StoriesPerFreq))/sqrt(2)/128;
    % N(i,:,:) = (randn(ArrayNumber,StoriesPerFreq)+1j*randn(ArrayNumber,StoriesPerFreq))/sqrt(2)
end
%接收阵源信号
for i=1:FreqNum
    if TargetSignalNumber==1
        X(i,:,:) = squeeze(conj(A(i,:,:)))*squeeze(S(i,:,:))' + squeeze(N(i,:,:));
    else
        X(i,:,:) = squeeze(A(i,:,:))'*squeeze(S(i,:,:)) + squeeze(N(i,:,:));
    end
end

% [ArrivalAngle,SignalMapdB] = CssmMethod(squeeze(X(5,:,:)),ArrayNumber,ArrayDistance,WaveLength(5));
% [ArrivalAngle,SignalMapdB] = CssmMethodHead(X,ArrayNumber,ArrayDistance,WaveLength);

% ISSM方法
LCMVArrivalAngle=zeros(1,FreqNum);
MUISCArrivalAngle=zeros(TargetSignalNumber,FreqNum);
LCMVMap =  zeros(3601,FreqNum);
MUSICMap =  zeros(3601,FreqNum);
for i=1:FreqNum
    [LCMVArrivalAngle(i),LCMVMap(:,i)]=LcmvMethod(squeeze(X(i,:,:)),ArrayNumber,ArrayDistance,WaveLength(i));
    [MUISCArrivalAngle(:,i),MUSICMap(:,i)]=MusicMethod(squeeze(X(i,:,:)),ArrayNumber,ArrayDistance,WaveLength(i));
end
Angle = linspace(-180,180,3601);
FreqNumLabel = (0:FreqNum-1);%分成的频段
figure;
mesh(FreqNumLabel,Angle,LCMVMap);
ylim([-90,90]);
figure;
mesh(FreqNumLabel,Angle,MUSICMap);
ylim([-90,90]);
xlabel('频点编号');
ylabel('到达角');

ISSMMap = zeros(1,3601);

for i=1:3601
    ISSMMap(i) = mean(MUSICMap(i,:));
end
ISSMMap=real(ISSMMap)-min(real(ISSMMap));
ISSMMap=db(abs(ISSMMap)/max(ISSMMap));
% ISSMMap=abs(ISSMMap)/max(abs(ISSMMap));
plot(Angle,ISSMMap);
xlim([-90,90]);
xlabel('归一化对数谱/dB');
ylabel('到达角/°');

[peaks, locals] = findpeaks(ISSMMap(1200:2400), Angle(1200:2400)/pi*180,'MinPeakHeight', -10);
[peaks,I] = sort(peaks); 
locals=fliplr(locals(:,I));
[locals,I] = sort(locals);
if length(locals)>TargetSignalNumber
    Angle=locals(1:TargetSignalNumber)';
else
    Angle=zeros(1,TargetSignalNumber);
end
% end
