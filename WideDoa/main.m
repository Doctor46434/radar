%% 参数
    ArrayNumber = 12;   %阵元数量
    LightSpeed = 3e8;
    TargetAngle = [40]*pi/180;             % 信号角度
    TargetSignalNumber  = length(TargetAngle);                % 目标信号数目
    snr = 20;               % 信噪比
    SimplingNumber  = 3601;             % 角度采样数
    SubCarrySignalNumber = 52;   % 信号子载频数量
    FrequenceStart = 20e6;  %子载波起始频率
    FrequenceSpacing = 312.5e3;  %子载波频率间隔
    FrequenceValue = FrequenceSpacing*[0:SubCarrySignalNumber-1]+FrequenceStart;%子载频频率
    Simplingrate = 1e9;%采样率
    Stories = 128*64;%总快拍数
    StoriesPerFreq = 16; %分成的段数
    FreqNum = 512;%每段的点数
    ArrayDistance = LightSpeed/FrequenceStart/3;
    TimeDelay = ArrayDistance*sin(TargetAngle)/LightSpeed;
    FreqFFT = (0:FreqNum-1)/FreqNum*Simplingrate;
    WaveLength = LightSpeed./FreqFFT;
    PreAngle = [20]*pi/180; 

%% 算法

SignalMat = SignalGen;
[outputArg1] = issm(SignalMat,ArrayNumber,ArrayDistance,WaveLength);
SignalFFT = zeros(ArrayNumber,StoriesPerFreq,FreqNum);
for i = 1:ArrayNumber
    for j = 1:StoriesPerFreq
        SignalFFT(i,j,:) = fft(SignalMat(i,(j-1)*FreqNum+1:j*FreqNum));
    end
end
SignalFreq = zeros(ArrayNumber,FreqNum,StoriesPerFreq);
for i = 1:ArrayNumber
    SignalFreq(i,:,:) = squeeze(SignalFFT(i,:,:))';
end
SignalFreq1 = zeros(FreqNum,ArrayNumber,StoriesPerFreq);
for i = 1:StoriesPerFreq
    SignalFreq1(:,:,i) = squeeze(SignalFreq(:,:,i))';
end
[SignalMapdB] = CssmMethodHead(SignalFreq1,ArrayNumber,ArrayDistance,WaveLength,PreAngle);
figure;
Angle = linspace(-180,180,3601);
plot(Angle,SignalMapdB);