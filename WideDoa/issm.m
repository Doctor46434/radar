function [ISSMMap] = issm(SignalMat,ArrayNumber,ArrayDistance,WaveLength)
%ISSM 此处显示有关此函数的摘要
%   此处显示详细说明
%% 参数
    Simplingrate = 1e9;
    StoriesPerFreq = 16; %分成的段数
    FreqNum = 512;%每段的点数
    Stories = FreqNum*StoriesPerFreq;
    t = (0:Stories-1)/Simplingrate;
    
%% 算法
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

    MUSICMap =  zeros(FreqNum,3601);
    for i = 1:FreqNum
        [~,MUSICMap(i,:)]=MusicMethod(squeeze(SignalFreq(:,i,:)),ArrayNumber,ArrayDistance,WaveLength(i));
    end
    Angle = linspace(-180,180,3601);
    ISSMMap = zeros(1,3601);
    for i = 1:3601
        ISSMMap(i) = mean(MUSICMap(:,i));
    end
    figure;
    mesh(MUSICMap);
    figure;
    plot(Angle,ISSMMap);
end

