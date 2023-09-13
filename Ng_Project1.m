clc
clear

dev = audiodevinfo();
inputID = dev.input(1);
outputID = dev.output(1);

% Recordings
for i = 1:3
    voice(i) = audiorecorder(44100, 16, 1, 1);
    
    % Prints the message
    if i == 1
        disp("The quick brown fox jumps over the lazy dog");
    elseif i == 2
        disp("We promptly judged antique ivory buckles for the next prize");
    else
        disp("Crazy Fredrick bought many very exquisite opal jewels");
    end
    
    % Countdown
    disp("3")
    pause(1)
    disp("2")
    pause(1)
    disp("1")
    pause(1)
    
    % Begins Recoding
    disp("Recording ", num2str(i));
    record(voice(i), 5);
    pause(5)
    fprintf('Recording Completed \n\n');
    pause(1);
end

% Plays Back the Recordings
for i = 1:3
    play(voice(i));
    pause(3);
end

% Produce 3 plots for each phrase

for i = 1:3
    getVoice(:,i) = getaudiodata(voice(i));
    time = 1:length(getVoice(:,i));
    time = time/44100; % To get the number of seconds
    subplot(3,1,i)
    plot(time, getVoice(:,i));
    xlabel('Time(s)'); ylabel('Amplitude'); title(sprintf("Recording %d", i));
end

% Produce Spectrogram
for i = 1:3
    window = hamming(512);
    N_overlap = 256;
    N_fft = 1024;
    [S,F,T,P] = spectrogram(getVoice(:,i), window , N_overlap, N_fft, 44100, 'yaxis');
    figure;
    surf(T,F,10*log10(P), 'EdgeColor', 'none');
    axis tight;
    view(0,90);
    colormap(jet);
    set(gca, 'clim', [-80,20]);
    ylim([0 8000])
    xlabel('Time (s)');ylabel('Frequency (Hz)'); title(sprintf("Recording %d", i));
end

% Stero Speech - Recording 1
fs = 44100;
recording1 = getaudiodata(voice(1));
steroZero = zeros(size(recording1));
steroSignal = [recording1 , steroZero];
load handel.mat
filename = 'teamng-stereosoundfile.wav';
audiowrite(filename, steroSignal, fs);
clear stereo_signal fs
[steroSignal, fs] = audioread(filename);
sound(steroSignal, fs);
pause(5);




