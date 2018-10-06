%% Initialization
%tic;
clear ; close all; clc

%% Setup the parameters you will use for this part of the exercise
input_layer_size  = 13;  
num_labels = 5;          
                          

%% =========== Part 1: Loading Data =============


% Load Training Data
fprintf('Loading Data ...\n')
w1=load('F:\College Stuff\BE Project\Final\Training and Testing MAT files\rest_MFCC_20min.mat');
w2=load('F:\College Stuff\BE Project\Final\Training and Testing MAT files\Train_MFCC_20min.mat');
w3=load('F:\College Stuff\BE Project\Final\Training and Testing MAT files\Airport_MFCC_20min.mat');
w4=load('F:\College Stuff\BE Project\Final\Training and Testing MAT files\rain_MFCC_20min.mat');
w5=load('F:\College Stuff\BE Project\Final\Training and Testing MAT files\highway_MFCC_20min.mat');
w6=load('F:\College Stuff\BE Project\Final\Training and Testing MAT files\highway_MFCC_20to25min.mat');
w7=w1.MFCC13;
w8=w2.MFCC13;
w9=w3.MFCC13;
w10=w4.MFCC13;
w11=w5.MFCC13;
w12=w6.MFCC13;
X=[w7;w8;w9;w10;w11];
y1=1*ones(29999,1);
y2=2*ones(29999,1);
y3=3*ones(29999,1);
y4=4*ones(29999,1);
y5=5*ones(29999,1);
y=[ones(119993,1);2*ones(119993,1);3*ones(119996,1);4*ones(119970,1);5*ones(119994,1)];
%load('ex3data1.mat'); % training data stored in arrays X, y
m = size(X, 1);


fprintf('Program paused. Press enter to continue.\n');

%pause;

%% ============ Part 2: Vectorize Logistic Regression ============


fprintf('\nTraining One-vs-All Logistic Regression...\n')

lambda = 0;
[all_theta] = oneVsAll(X, y, num_labels, lambda);
%total_time=toc;
fprintf('Program paused. Press enter to continue.\n');
pause;


%% ================ Part 3: Predict for One-Vs-All ================
tic;
pred = predictOneVsAll(all_theta, X);
pred2=predictOneVsAll(all_theta, w12);
fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);
fprintf('\nTesting Accuracy: %f\n\n', mean(double(pred2 == y5)) * 100);

Confusion_Calculation('Multi-class Logistic Regression',pred2);
total_time=toc;