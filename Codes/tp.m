[d1,sr1] = audioread('F:\College Stuff\BE Project\Final\Audio Class Samples\podcast+airport_noise_2min.m4a');
[d2,sr2] = audioread('F:\College Stuff\BE Project\Filter( MATLAB inbuilt)\RLS_filtered_airport.m4a');
[d3,sr3] = audioread('F:\College Stuff\BE Project\Final\Audio Class Samples\Pure_podcast_2min.m4a');
y1 = lpcauto(d1,20);
y2 = lpcauto(d2,20);
y3 = lpcauto(d3,20);
y1 = y1'; 
y2 = y2';
y3 = y3';
b = distitar(y1,y2,'d');
figure(1)
subplot(211)
plot(b)
title('IS distance between spech+noise and output')
b = distitar(y2,y3,'d');
subplot(212)
plot(b)
title('IS distance between speech and output') 
 b = disteusq(y1,y2,'d');
figure(2)
subplot(211)
plot(b)
title('EU distance between spech+noise and output')
b = disteusq(y2,y3,'d');
subplot(212)
plot(b)
title('EU distance between speech and output') 
