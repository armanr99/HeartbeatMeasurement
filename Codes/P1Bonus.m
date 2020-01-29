url = 'http://192.168.43.1:8080/video'; 
cam = ipcam(url); 

framesCount = 200;
redMean = zeros(1, framesCount);

tic;
t = 0;
for i = 1: framesCount
    frame = snapshot(cam); 
    if(i == framesCount)
        t = toc;
    end
    redPixels = frame(:,:,1);
    redMean(i) = mean(mean(redPixels));
end

%%
bpmStart = 50;
bpmEnd = 220;
fs = framesCount / t;F
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