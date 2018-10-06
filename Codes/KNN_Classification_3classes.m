clc;
clear all;
x1=load('F:\College Stuff\BE Project\MAT files\Train_X.mat');
x=x1.Train_X;
y=[zeros(3884,1);ones(3884,1);2*ones(3884,1)]; %0 is airport
                                               %1 is restaurant
                                               %2 is station
z=input('Enter the number of neighbors: ');
Md1=fitcknn(x,y,'NumNeighbors',z);
Md2=fitcknn(x,y,'NumNeighbors',z,'Distance','chebychev');
Md3=fitcknn(x,y,'NumNeighbors',z,'Distance','seuclidean');

temp1=load('F:\College Stuff\BE Project\MAT files\Test\air_15_5.mat');%This is the Input to be tested
test=temp1.MFCC13;

[m,n]=size(test);
 test_model1=predict(Md1,test);
 test_model2=predict(Md2,test);
 test_model3=predict(Md3,test);

 model_1_air=0;
 model_1_res=0;
 model_1_stat=0;
 model_2_air=0;
 model_2_res=0;
 model_2_stat=0;
 model_3_air=0;
 model_3_res=0;
 model_3_stat=0;
 
for i=1:m
   if(test_model1(i,1)==0)
     model_1_air=model_1_air+1;
   elseif(test_model1(i,1)==1)
     model_1_res=model_1_res+1;
   elseif(test_model1(i,1)==2)
     model_1_stat=model_1_stat+1;
   end;
   
   if(test_model2(i,1)==0)
     model_2_air=model_2_air+1;
   elseif(test_model2(i,1)==1)
     model_2_res=model_2_res+1;
   elseif(test_model2(i,1)==2)
     model_2_stat=model_2_stat+1;
   end;
   
   if(test_model3(i,1)==0)
     model_3_air=model_3_air+1;
   elseif(test_model3(i,1)==1)
     model_3_res=model_3_res+1;
   elseif(test_model3(i,1)==2)
     model_3_stat=model_3_stat+1;
   end;
end;


disp('Euclidean Distance Model');
disp('No. of frames identified as airport:');
disp(model_1_air);
disp('No. of frames identified as restaurant:');
disp(model_1_res);
disp('No. of frames identified as station:');
disp(model_1_stat);
disp('Chebychev Distance Model');
disp('No. of frames identified as airport:');
disp(model_2_air);
disp('No. of frames identified as restaurant:');
disp(model_2_res);
disp('No. of frames identified as station:');
disp(model_2_stat);
disp('SEuclidean Distance Model');
disp('No. of frames identified as airport:');
disp(model_3_air);
disp('No. of frames identified as restaurant:');
disp(model_3_res);
disp('No. of frames identified as station:');
disp(model_3_stat);