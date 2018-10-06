clc;
clear all;

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

%  The noise corrupting the information bearing signal is a 
%  filtered version of 'noise'. 
%  Initialize the filter that operates on the noise.

%lp = dsp.FIRFilter('Numerator',fir1(31,0.5));% Low pass FIR filter

% Set and initialize RLS adaptive filter parameters and values:
w1=load('F:\College Stuff\BE Project\Final\Audio Class Samples\Airport Noise\w_lms_airport1_podcast2.mat');
w=w1.w;
M      = 32;                 % Filter order
delta  = 0.1;                % Initial input covariance estimate
P0     = (1/delta)*eye(M,M); % Initial setting for the P matrix
LMSfilt = dsp.LMSFilter('Length', 32,'Method', 'Normalized LMS',...    
              'StepSize', 0.01,'InitialConditions',w,'AdaptInputPort',1);

 fprintf('(Part 1)Program paused. Press enter to continue.\n');
% pause;

%  Running the LMS adaptive filter for 100 iterations. 
%  As the adaptive filter converges, the filtered noise should be 
%  completely subtracted from the "signal + noise".
%  Also the error, 'e', should contain only the original signal  

%scope = dsp.TimeScope('TimeSpan',100,'YLimits',[-2,2], ...
%	                  'TimeSpanOverrunAction','Scroll');
%for k = 1:100
    s = signalSource;
    n = noiseSource; % Noise
    [y,e,w2]  = step(LMSfilt,n.Signal,s.Signal,0); 
    %[...] = step(lms,X,D,A) uses A as the adaptation control, 
    %when the AdaptInputPort property is true. When A is nonzero, the 
    %LMS filter continuously updates the filter weights. When A is zero, 
    %the filter weights remain constant.
    %step(scope,[e,s.Signal]);
%end
%release(scope);
T=toc;
fprintf('(Part 2)Program paused. Press enter to continue.\n');
pause;

audiowrite('F:\College Stuff\BE Project\Final\Audio Class Samples\Airport Noise\filtered_podcast1_airport5_LMS.m4a',e,44100);