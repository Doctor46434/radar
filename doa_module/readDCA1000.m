% 原本官方的代码，更改后作为将原始数据输出为复数数据的代码

%%% This script is used to read the binary file produced by the DCA1000 and Mmwave Studio

function [retVal] = readDCA1000(fileName)%% global variables

% fileName = 'D:\training\radio_test\blank_Raw_0.bin';
numADCSamples = 256; % number of ADC samples per chirp
numADCBits = 16; % number of ADC bits per sample
numRX = 4; % number of receivers
numLanes = 2; % do not change. number of lanes is always 2
isReal = 0; % set to 1 if real only data, 0 if complex data0
% read file
% read .bin file
fid = fopen(fileName,'r');
adcData = fread(fid, 'int16');
fclose(fid);
fileSize = size(adcData, 1);
% real data reshape, filesize = numADCSamples*numChirps
if isReal
numChirps = fileSize/numADCSamples/numRX;
LVDS = zeros(1, fileSize);
%create column for each chirp
LVDS = reshape(adcData, numADCSamples*numRX, numChirps);
%each row is data from one chirp
LVDS = LVDS.';
else
% for complex data
% filesize = 2 * numADCSamples*numChirps
numChirps = fileSize/2/numADCSamples/numRX;
LVDS = zeros(1, fileSize/2);
%combine real and imaginary part into complex data
%read in file: 2I is followed by 2Q
counter = 1;
for i=1:4:fileSize-1
LVDS(1,counter) = adcData(i) + sqrt(-1)*adcData(i+2); 
LVDS(1,counter+1) = adcData(i+1)+sqrt(-1)*adcData(i+3); 
counter = counter + 2;
end
% create column for each chirp
LVDS = reshape(LVDS, numADCSamples*numRX, numChirps);
%each row is data from one chirp
LVDS = LVDS.';
end
%organize data per RX
adcData = zeros(numRX,numChirps*numADCSamples);
for row = 1:numRX
for i = 1: numChirps
adcData(row, (i-1)*numADCSamples+1:i*numADCSamples) = LVDS(i, (row-1)*numADCSamples+1:row*numADCSamples);
end
end
% return receiver data

real_data = zeros(numRX*2,numChirps*numADCSamples/2);
for i = 1:numRX
    for j = 1:numChirps*numADCSamples/2/256
        real_data(i*2-1,(j-1)*256+1:j*256) = adcData(i,(j*2-1-1)*256+1:(j*2-1)*256);
        real_data(i*2,(j-1)*256+1:j*256) = adcData(i,(j*2-1)*256+1:(j*2)*256);
    end
end

retVal = real_data;

end