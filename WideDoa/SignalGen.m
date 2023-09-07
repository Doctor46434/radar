function [SignalMat] = SignalGen
%SIGNALGEN 产生阵列OFDM宽带信号
%   产生D个信源在M个阵列上的时域信号矩阵

%% 参数
    ArrayNumber = 12;   %阵元数量
    LightSpeed = 3e8;
    TargetAngle = [30]*pi/180;             % 信号角度
    TargetSignalNumber  = length(TargetAngle);                % 目标信号数目
    snr = 30;               % 信噪比
    SimplingNumber  = 3601;             % 角度采样数
    SubCarrySignalNumber = 52;   % 信号子载频数量
    FrequenceStart = 20e6;  %子载波起始频率
    FrequenceSpacing = 312.5e3;  %子载波频率间隔
    FrequenceValue = FrequenceSpacing*[0:SubCarrySignalNumber-1]+FrequenceStart;%子载频频率
    Simplingrate = 1e8;%采样率
    Stories = 128*64;%总快拍数
    ArrayDistance = LightSpeed/FrequenceStart/3;
    TimeDelay = ArrayDistance*sin(TargetAngle)/LightSpeed;
%% 生成OFDM信号

    t = zeros(ArrayNumber,Stories);
    for i=1:ArrayNumber
            t(i,:) = 1/Simplingrate*(0:Stories-1)+TimeDelay*i;
    end
    
    SignalMat = zeros(ArrayNumber,Stories);
    for i = 1:ArrayNumber
        for j = 1:Stories
            for k = 1:SubCarrySignalNumber
                SignalMat(i,j) = SignalMat(i,j)+sqrt(10^(snr/10))*exp(1j*2*pi*FrequenceValue(k)*t(i,j));
            end
        end
    end

    for i = 1:ArrayNumber
        SignalMat(i,:) = SignalMat(i,:) + randn(1,Stories) + 1j*randn(1,Stories);
    end
end

