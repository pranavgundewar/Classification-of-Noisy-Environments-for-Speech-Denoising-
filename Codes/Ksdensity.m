clc;
clear all;
 x_pure=load('F:\BE Project Final\Training and Testing MAT files\podcast1_pure.mat');
 x_pure=x_pure.MFCC13;
 x_pure=x_pure(20,:);
 x_pure=x_pure';
 
 x_fil=load('F:\BE Project Final\Training and Testing MAT files\podcast1_noise2_noisy.mat');
 x_fil=x_fil.MFCC13;
 x_fil=x_fil(20,:);
 x_fil=x_fil';
 
 x_noise=load('F:\BE Project Final\Training and Testing MAT files\podcast1_noise2_filtered.mat');
 x_noise=x_noise.MFCC13;
 x_noise=x_noise(20,:);
 x_noise=x_noise';
 
 [f_pure,xi_pure] = ksdensity(x_pure);
 [f_fil,xi_fil] = ksdensity(x_fil);
 [f_noise,xi_noise] = ksdensity(x_noise);
 
 figure(1)
 grid on;
 subplot(3,1,1)
 plot(xi_pure,f_pure);
 title('Pure speech');
 
 subplot(3,1,2)
 plot(xi_fil,f_fil);
 title('Filtered speech');
 
 subplot(3,1,3)
 plot(xi_noise,f_noise);
 title('Speech + Noise');
 
 mean_noise=mean(f_noise)
 mean_fil=mean(f_fil)
 mean_pure=mean(f_pure)
 
 var_noise=var(f_noise)
 var_fil=var(f_fil)
 var_pure=var(f_pure)
 
 eucd_fil_noise=sum((xi_fil-xi_noise).^2+(f_fil-f_noise).^2)
 eucd_fil_pure=sum((xi_fil-xi_pure).^2+(f_fil-f_pure).^2)
 
