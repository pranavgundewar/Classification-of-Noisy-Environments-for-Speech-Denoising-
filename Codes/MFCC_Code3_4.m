%  Code 3_4 started on 31_12_16
%  Modification of Code 3_3
%  Code adapted from algorithm provided in "Speech & Audio Processing"


clc;
clearvars;
clearvars –global;

% Step 1: Read the audio sample
[y,fs] = audioread('F:\BE Project Final\Audio Class Samples\Highway Noise\podcast2+highway_noise\podcast2+highway_noise1.m4a');
%[y,fs] = audioread('F:\Train_8hr.m4a',[52920001 66150001]);
    %('F:\College Stuff\BE Project\Database\Databases\Speech\NOIZEUS\station\15dB\sp05_station_sn15.wav');
%info = audioinfo('F:\BE Project Final\Audio Class Samples\pure_podcast2_2min.m4a');

%info = audioinfo('F:\Train_8hr.m4a');
    %('F:\College Stuff\BE Project\Database\Databases\Speech\NOIZEUS\station\15dB\sp05_station_sn15.wav');

% %Plotting the audio data
% t = 0:(1/fs):(info.Duration);
% t = t(1:end-1);
% figure(1)
% plot(t,y)
% xlabel('Time')
% ylabel('Audio Signal')

% Step 2: if signal is stereo i.e. it has more than two channel
if (size(y,2)>1)
    y = (sum(y,2)/2);   % converting to mono
end;

% Step 3: Calculate the total number of frames
window = input('Enter the window step in seconds: ');
hop = input('Enter the overlap duration in seconds: ');
L = length(y);
       
window_len = window * fs ;  %No. of samples in window
hop_len = hop * fs ; %No. of samples in the overlap duration

numframes = floor((L-window_len)/hop_len) + 1; %No. of frames

MFCC13 = zeros(numframes,13);
hamm1 = hamming(window_len); %Creating Hamming Window

% Step 4: Calculate the FFT Squared power spectrum
position = 1;
for i = 1:numframes
    
    frame = y(position:position+window_len - 1);
    frame = frame .* hamm1;      %Hamming window to reduce spectral leakage
    
    N = length(frame);
    FFT_frame = abs(fft(frame));
    for j=1:N
        FFT_frame(j)=FFT_frame(j)*conj(FFT_frame(j));   %Calculation of Squared Power
    end;
    
    temp1=(FFT_frame);
    %temp1=log10(FFT_frame);
    
 % Step 5: Calculate frequency in Hz for every FFT bin
    for k=1:ceil(N/2)
        f(k)=((fs)/N)*k;
    end;
    
    for k=1:ceil(N/2)
        temp2(k)=temp1(k);
    end;
    
 % Step 6: Calculate mel scale frequency for each frequency
 %         in Hz corresponding to FFT bin
    for k=1:ceil(N/2)
        m(k)=2595*log10(1+f(k)/700);
    end;
    
 % Step 7: Divide mel scale in equally spaced triangular filters each of
 %         width equal to 300 mel with 50% overlap, starting from 300mel
 %         upto 28 such filters
 
    for p=1:19
       sum(p)=0;
       for k=1:ceil(N/2)
             if((m(k)>300+(p-1)*150)&&(m(k)<600+(p-1)*150))
                 if(m(k)<450+(p-1)*150)
                     g(k)=((m(k)-(300+150*(p-1)))*1/150);
                 else
                     g(k)=((600+150*(p-1)*m(k))*1/150);
                 end;
                 sum(p)=sum(p)+temp2(k)*g(k);
             end;
       end;    
    end;
    
 % Step 8: Find DCT of the integrated output. This is the cepstral
 %         domain
     for p=1:19
     if sum(p)~=0
      temp3(p)=log10(sum(p));
     else
         temp3(p)=0;
     end;
     end;
     temp3=(ifft(temp3));
%      temp3=dct(sum);
     temp3=abs(temp3);
 
  % Step 9: Spectral Smoothing by truncating the cepstrum by using only 13
  %         coefficients
     for q=1:13
         temp4(q)=temp3(q);
     end
    
    MFCC13(i,:) = temp4;
   
    position = position + hop_len;
end;

% figure(2)
% hold on;
% for q=1:numframes
%    plot(MFCC13(q,:));
% end;
% grid on;