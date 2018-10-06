clc;
clear all;

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
p=size(w12,1);
X=[w7;w8;w9;w10;w11];

%target=[zeros(29999,1), ones(29999,1), zeros(29999,1), zeros(29999,1), zeros(29999,1)];
y=[ones(119993,1);2*ones(119993,1);3*ones(119996,1);4*ones(119970,1);5*ones(119994,1)];

%% ========Part 2:Training KNN models with different distance metrics=====

z=input('Enter the number of neighbors: ');
Md1=fitcknn(X,y,'NumNeighbors',z);
%Md2=fitcknn(X,y,'NumNeighbors',z,'Distance','chebychev');
%Md3=fitcknn(X,y,'NumNeighbors',z,'Distance','seuclidean');

fprintf('Training complete....Press enter to continue\n');
pause;
%% ========Part 3: Testing the trained models for a given input==========
 tic;
 test_model_1=predict(Md1,w12);
%  test_model_2=predict(Md2,w12);
%  test_model_3=predict(Md3,w12); 

 fprintf('Testing complete....Press Enter to Continue\n');
 %pause;
 %% =====Part 4: Calculation of Confusion Matrix=========================
 
fprintf('Input class: 5\n\n');
% KNN_Confusion_Calculation(model_name,test_model,input,input_class);
 KNN_Confusion_Calculation('Euclidean',test_model_1);
%  KNN_Confusion_Calculation('Chebyshev',test_model_2);
%  KNN_Confusion_Calculation('SEuclidean',test_model_3);
 total_time=toc;