video = VideoReader('A.mp4');

framesCount = int64(video.Duration * video.FrameRate);
redFrames = zeros(video.Height, video.Width, framesCount);

for i = 1 : framesCount
    videoFrame = readFrame(video);
    redFrames(:,:,i) = videoFrame(:, :, 1);
end

%mean
redMean = zeros(1, framesCount);
for i = 1: framesCount
    redMean(i) = mean(mean(redFrames(:, :, i)));
end

%draw plot
figure(1);
plot(redMean);
xlabel('Frame Number');
ylabel('Red Mean');
title('Red Color Average per Frame');

%%
bpmStart = 50;
bpmEnd = 220;
fs = video.FrameRate;
fourier = fft(redMean);
fourierAbs = abs(fourier);
f = fs / double(framesCount) * double((0: framesCount / 2));
inRange = find(f >= bpmStart / 60 & f <= bpmEnd / 60);

if(length(inRange) > 1)
    figure(2);
    fourierInRange = fourierAbs(inRange(1): inRange(length(inRange)));
    fInRange = f(inRange);
    plot(fInRange * 60, fourierInRange);
    xlabel('BPM');
    ylabel('Fourier');
    title('Fourier Analysis of Red Color Average per Frame');
end

%%
if(length(inRange) > 1)
    [Max, MaxIndex] = max(fourierInRange);
    text(fInRange(MaxIndex) * 60, Max, sprintf('<- Your BPM is: %d', int64(fInRange(MaxIndex) * 60)));
end
%%
fNeg = fs / double(framesCount) * double((-framesCount / 2 + 1 : -1));
notInRangePos = find(f < bpmStart / 60 | f > bpmEnd / 60);
notInRangeNeg = find(fNeg < -bpmEnd / 60 | fNeg > -bpmStart / 60);
notInRangeNeg = notInRangeNeg + length(f);

noiselessFourier = fourier;
noiselessFourier(notInRangePos) = 0;
noiselessFourier(notInRangeNeg) = 0;

noiselessSignal = ifft(noiselessFourier);
figure(3);
plot(noiselessSignal);
xlabel('Frame Number');
ylabel('Red Mean');
title('Noiseless Red Color Average per Frame');

