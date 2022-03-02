%% Signal Processing Project

% This program is used as the basis of the Signal Processing Course Porject.
% The program will take samples of the same word spoken by a male and
% a female, display those signals and their spectrograms; then, it will 
% calculate the formants. Using the data available, the program will
% attempt to increase the similarities between the two signals'
% spectrograms.

%% Cleaning up
clear
close all
clc
%% Loading Data
data_m = dir('data\Male\*.wav');
data_f = dir('data\Female\*.wav');
%% Intializing the spreadsheet to save the data
xlFilename = 'data.xls';
A = {'','','','F1','F2','F3'};
writecell(A,xlFilename,'Sheet','formants','Range','A1');
j = 2;
writecell(A,xlFilename,'Sheet','newformants','Range','A1');
k = 2;
%% Loop through all the audio files
for i=1:numel(data_m) 
    file_m = fullfile(data_m(i).folder, data_m(i).name);
    file_f = fullfile(data_f(i).folder, data_f(i).name);
    [y_m, Fs_m] = audioread(file_m); % reading male audio file
    [y_f, Fs_f] = audioread(file_f); % reading female audio file
    
    % visualizing the signals
    visualization(y_m,Fs_m,y_f,Fs_f);
    sgtitle(['Number [' num2str(i-1) ']'])
    name = ['figures\before\Number [' num2str(i-1) ']_before_processing.png'];
    saveas(gcf,name) % saving figure
    
    % calculating formants for each signal
    formants_m_ar = formants_autoregression(y_m,Fs_m);
    formants_m_lpc = formants_lpc(y_m,Fs_m);
    formants_f_ar = formants_autoregression(y_f,Fs_f);
    formants_f_lpc = formants_lpc(y_f,Fs_f);

    % saving formants in spreadsheet
    C = {i-1,'LPC','male',formants_m_lpc(1),formants_m_lpc(2),formants_m_lpc(3);
        '','','female',formants_f_lpc(1),formants_f_lpc(2),formants_f_lpc(3);
        '','AR','male',formants_m_ar(1),formants_m_ar(2),formants_m_ar(3);
        '','','female',formants_f_ar(1),formants_f_ar(2),formants_f_ar(3);};

    Range = strcat('A',int2str(j));
    writecell(C,xlFilename,'Sheet','formants','Range',Range);
    j = j+4;

    % calculating the rate of difference between the formants of the male
    % and female signals
    Rate = max(formants_f_ar./formants_m_ar); 
    
    % compressing and stretching the signals to increase the similarities
    % between the signals
    nsemitones = -Rate;
    y_f = shiftPitch(y_f,nsemitones,"LockPhase",false);
    nsemitones = Rate;
    y_m = shiftPitch(y_m,nsemitones,"LockPhase",false);
    
    % calculating formants for each signal
    formants_m_ar_after = formants_autoregression(y_m,Fs_m);
    formants_f_ar_after = formants_autoregression(y_f,Fs_f);
    
    % saving new formants in spreadsheet
    C = {i-1,'AR','male',formants_m_ar_after(1),formants_m_ar_after(2),formants_m_ar_after(3);
        '','','female',formants_f_ar_after(1),formants_f_ar_after(2),formants_f_ar_after(3);};

    Range = strcat('A',int2str(k));
    writecell(C,xlFilename,'Sheet','newformants','Range',Range);
    k = k+2;

    % visualizing the signals again to observe the change that was caused
    % by stretching and compressing the signals
    visualization(y_m,Fs_m,y_f,Fs_f);
    sgtitle(['Number [' num2str(i-1) ']'])
    name = ['figures\after\Number [' num2str(i-1) ']_after_processing.png'];
    saveas(gcf,name) % saving figure
end
