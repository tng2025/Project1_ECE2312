% Ng_Project1 Recoded
clc
clear

dev = audiodevinfo();
inputID = dev.input(1);
outputID = dev.output(1);

% Records one at a time
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
    
    % Play Back the Recording
    play(voice(i));
    pause(3);
    
    % Produce a plot for the phrase
    getVoice(:,i) = getaudiodata(voice(i));
    time = 1:length(getVoice(:,i));
    time = time/44100; % To get the number of seconds
    figure;
    plot(time, getVoice(:,i));
    xlabel('Time(s)'); ylabel('Amplitude'); title(sprintf("Recording %d", i));

    % Produce Spectrogram
    load handel.mat
    if i == 1 
        filename = 'Recording_1.wav';
    elseif i == 2
        filename = 'Recording_2.wav';
    else
        filename = 'Recording_3.wav';
    end
    audiowrite(filename, getVoice(:, i),44100);
    
    window = hamming(512);
    N_overlap = 256;
    N_fft = 1024;
    figure;
    [S,F,T,P] = spectrogram(getVoice(:,i), window , N_overlap, N_fft, 44100, 'yaxis');
    surf(T,F,10*log10(P), 'EdgeColor', 'none');
    axis tight;
    view(0,90);
    colormap(jet);
    set(gca, 'clim', [-80,20]);
    ylim([0 8000]);
    xlabel('Time (s)');ylabel('Frequency (Hz)'); title(sprintf("Recording %d", i));
    
    % Gives the user some time before the next recording
    pause(5);
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





