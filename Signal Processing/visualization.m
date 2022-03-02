function visualization(y_m,Fs_m,y_f,Fs_f)

% This function is used for the visualization of the spectrograms of both
% signals, the male and the female.

% y_m: male speech signal
% F_m: sampling frequency of male speech signal
% y_m: female speech signal
% F_m: sampling frequency of female speech signal

framelen_samples_m = (40/1000)*Fs_m; % frame length
segmentlen_m = round(framelen_samples_m); % segment length or window
noverlap_m = floor(0.3* framelen_samples_m); % overlap
NFFT_m = 2^nextpow2(framelen_samples_m); % nfft sampling points to calculate the dft
figure % plotting
subplot(2,1,1)
[S,F,T] = spectrogram(y_m,segmentlen_m,noverlap_m,NFFT_m,Fs_m,'yaxis'); % spectrogram
sh = surf(T,F,abs(S)); % using surf to see the log scale of the frequency
view([0 90])
axis tight
set(gca, 'YScale', 'log')
set(sh, 'LineStyle','none')
xlabel('Time [s]')
ylabel('Frequency [kHz]')
title('Male')
subplot(2,1,2)
framelen_samples_f = (30/1000)*Fs_f; % segment length or window
segmentlen_f = round(framelen_samples_f);
noverlap_f = floor(0.3* framelen_samples_f); % overlap
NFFT_f = 2^nextpow2(framelen_samples_f); % nfft sampling points to calculate the dft
[S,F,T] = spectrogram(y_f,segmentlen_f,noverlap_f,NFFT_f,Fs_f,'yaxis');
sh = surf(T,F,abs(S));
view([0 90])
axis tight
set(gca, 'YScale', 'log')
set(sh, 'LineStyle','none')
xlabel('Time [s]')
ylabel('Frequency [kHz]')
title('Female')
end