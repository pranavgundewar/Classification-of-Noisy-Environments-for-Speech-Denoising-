clc;
clear all;
tic;
signal = audioread('F:\College Stuff\BE Project\Final\Audio Class Samples\Highway Noise\podcast2+highway_noise\podcast2+highway_noise1.m4a');
if (size(signal,2)>1)
    signal = (sum(signal,2)/2);   % converting to mono
end;

noise = audioread('F:\College Stuff\BE Project\Final\Audio Class Samples\Highway Noise\highway noise segments (2 min)\highway_noise1.m4a');
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
M      = 32;                 % Filter order
delta  = 0.1;                % Initial input covariance estimate
P0     = (1/delta)*eye(M,M); % Initial setting for the P matrix
rlsfilt = dsp.RLSFilter(M,'InitialInverseCovariance',P0);

fprintf('(Part 1)Program paused. Press enter to continue.\n');
%pause;

%  Running the RLS adaptive filter for 1000 iterations. 
%  As the adaptive filter converges, the filtered noise should be 
%  completely subtracted from the "signal + noise".
%  Also the error, 'e', should contain only the original signal  

scope = dsp.TimeScope('TimeSpan',1000,'YLimits',[-2,2], ...
	                  'TimeSpanOverrunAction','Scroll');
for k = 1:2
    s = signalSource;
    n = noiseSource; % Noise
    [y,e]  = step(rlsfilt,n.Signal,s.Signal);
    disp(k);
     %step(scope,e);
end
%release(scope);
T=toc;
fprintf('(Part 2)Program paused. Press enter to continue.\n');
pause;

audiowrite('F:\College Stuff\BE Project\Final\Audio Class Samples\Highway Noise\filtered_podcast2_highway1.m4a',e,44100);