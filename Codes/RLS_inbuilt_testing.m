clc;
clear all;

%% =============== Part 1: Loading Data ===================================

tic;
signal = audioread('F:\College Stuff\BE Project\Final\Audio Class Samples\Airport Noise\podcast1+airport_noise\podcast1+airport_noise5.m4a');
if (size(signal,2)>1)
    signal = (sum(signal,2)/2);   % converting to mono
end;

noise = audioread('F:\College Stuff\BE Project\Final\Audio Class Samples\Airport Noise\airport noise segments (2 min)\airport_noise5.m4a');
if (size(noise,2)>1)
    noise = (sum(noise,2)/2);   % converting to mono
end;

N=min(length(signal),length(noise));
signal=signal(1:N,:);
noise=noise(1:N,:);

signalSource = dsp.SignalSource(signal,'SamplesPerFrame',100,...
    'SignalEndAction','Cyclic repetition');

noiseSource = dsp.SignalSource(noise,'SamplesPerFrame',100,...
    'SignalEndAction','Cyclic repetition');
%% =============== Part 2: Initializing filter parameters =================
%  The noise corrupting the information bearing signal is a 
%  filtered version of 'noise'. 
%  Initialize the filter that operates on the noise.

%lp = dsp.FIRFilter('Numerator',fir1(31,0.5));% Low pass FIR filter

% Set and initialize RLS adaptive filter parameters and values:
w1=load('F:\College Stuff\BE Project\Final\Audio Class Samples\Airport Noise\w_rls_airport1_podcast2_2iterations.mat');
w=w1.pq;
M      = 32;                 % Filter order
delta  = 0.1;                % Initial input covariance estimate
P0     = (1/delta)*eye(M,M); % Initial setting for the P matrix
rlsfilt = dsp.RLSFilter(M,'InitialInverseCovariance',P0,'InitialCoefficients',w,'LockCoefficients',1);

fprintf('(Part 1)Program paused. Press enter to continue.\n');
%pause;

%  Running the RLS adaptive filter for 1000 iterations. 
%  As the adaptive filter converges, the filtered noise should be 
%  completely subtracted from the "signal + noise".
%  Also the error, 'e', should contain only the original signal  

%scope = dsp.TimeScope('TimeSpan',1000,'YLimits',[-2,2], ...
%	                  'TimeSpanOverrunAction','Scroll');

% for k = 1:2
    s = signalSource.Signal;
    n = noiseSource.Signal; % Noise
    [y,e]  = step(rlsfilt,n,s);
%     disp(k);
     %step(scope,e);
% end
%release(scope);
T=toc;
fprintf('(Part 2)Program paused. Press enter to continue.\n');
pause;

%audiowrite('F:\College Stuff\BE Project\Final\Audio Class Samples\Airport Noise\filtered_podcast1_airport5_2iteration.m4a',e,44100);
audiowrite('F:\College Stuff\BE Project\Final\Audio Class Samples\Airport Noise\temp.m4a',e,44100);

%% =============== Part 3: Plot the waveforms =============================
figure(1)
grid on;
subplot(4,1,1)
plot(N,signal);
title('Noisy Speech');
xlabel('Time');
ylabel('Amplitude');

subplot(4,1,2)
plot(N,noise);
title('Noise (recorded from secondary microphone)');
xlabel('Time');
ylabel('Amplitude');

subplot(4,1,3)
plot(N,e);
title('Filtered Output');
xlabel('Time');
ylabel('Amplitude');

subplot(4,1,43)
plot(N1,pure_speech);
title('Pure Speech');
xlabel('Time');
ylabel('Amplitude');