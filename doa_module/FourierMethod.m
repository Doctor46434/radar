% 输入一个信号快拍
% 返回到达角

function [ArrivalAngle]=FourierMethod(SignalMat)

    SamplingNumber=3601;
    ArrayNumber = size(SignalMat,1);
    
    FourierMap = fft([SignalMat(:,1);zeros(SamplingNumber-ArrayNumber,1)]);
    FourierMap = fftshift(FourierMap);
    FourierMap = db(abs(FourierMap)/max(abs(FourierMap)));
    [~,SignalMap]=max(FourierMap(1:3601));
    ArrivalAngle=(SignalMap-1800)/30;

%     如果需要作图
%     figure;
%     theta = linspace(-pi/3,pi/3,SamplingNumber);
%     plot(theta * 180/pi,FourierMap);
%     hold on;
end