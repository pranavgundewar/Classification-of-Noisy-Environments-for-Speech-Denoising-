clc;
clear all;

Pure_Speech = audioread('F:\College Stuff\BE Project\Filter 2\Pure_podcast_2min.m4a');
if (size(Pure_Speech,2)>1)
    Pure_Speech = (sum(Pure_Speech,2)/2);   % converting to mono
end;

PureSpeechplusNoise = audioread('F:\College Stuff\BE Project\Final\Audio Class Samples\Airport Noise\podcast1+airport_noise\podcast1+airport_noise5.m4a');
if (size(PureSpeechplusNoise,2)>1)
    PureSpeechplusNoise = (sum(PureSpeechplusNoise,2)/2);   % converting to mono
end;

filtered_output = audioread('F:\College Stuff\BE Project\Final\Audio Class Samples\Airport Noise\filtered_podcast1_airport5.m4a');
if (size(filtered_output,2)>1)
    filtered_output = (sum(filtered_output,2)/2);   % converting to mono
end;

noise = audioread('F:\College Stuff\BE Project\Final\Audio Class Samples\Airport Noise\airport noise segments (2 min)\airport_noise5.m4a');
if (size(noise,2)>1)
    noise = (sum(noise,2)/2);   % converting to mono
end;

N=min(length(Pure_Speech),min(length(PureSpeechplusNoise),min(length(noise),length(filtered_output))));
Pure_Speech=Pure_Speech(1:N,:);
PureSpeechplusNoise=PureSpeechplusNoise(1:N,:);
filtered_output=filtered_output(1:N,:);
noise=noise(1:N,:);

snr_PureSpeech=snr(Pure_Speech,noise)
snr_PureSpeechplusNoise=snr(PureSpeechplusNoise,noise)
snr_FilteredOutput=snr(filtered_output,noise)