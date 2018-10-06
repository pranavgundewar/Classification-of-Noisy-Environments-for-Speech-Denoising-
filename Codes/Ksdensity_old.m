clc;
clear all;
x_pure=load('F:\BE Project Final\Training and Testing MAT files\podcast1_pure.mat');
x_pure=x_pure.MFCC13;
x_pure=x_pure(20,:);
x_pure=x_pure';
x_noisy=load('F:\BE Project Final\Training and Testing MAT files\podcast1_rest_noise2_noisy.mat');
x_noisy=x_noisy.MFCC13;
x_noisy=x_noisy(20,:);
x_noisy=x_noisy';
x_filtered=load('F:\BE Project Final\Training and Testing MAT files\podcast1_rest_noise2_filtered.mat');
x_filtered=x_filtered.MFCC13;
x_filtered=x_filtered(20,:);
x_filtered=x_filtered';
[f_n,xi_n] = ksdensity(x_noisy);
[f_fil,xi_fil] = ksdensity(x_filtered);
[f_pure,xi_pure] = ksdensity(x_pure);
subplot(3,1,1)
plot(xi_n,f_n);
title('speech + noise');
subplot(3,1,2)
plot(xi_pure,f_pure);
title('pure speech');
subplot(3,1,3)
plot(xi_fil,f_fil);
title('filtered speech');

%% 

mean_pure=mean(f_pure)
mean_fil=mean(f_fil)
mean_n=mean(f_n)

var_pure=var(f_pure)
var_fil=var(f_fil)
var_n=var(f_n)

% d_fil = sum((f_pure-f_fil).^2).^0.5
% d_n = sum((f_pure-f_n).^2).^0.5
% 
% is_n =