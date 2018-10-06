function KNN_Confusion_Calculation(model_name,test_model)
output=zeros(1,5);
m=size(test_model,1);
 for i=1:m
     if test_model(i,1)==1
        output(1,1)=output(1,1)+1;
     elseif test_model(i,1)==2
        output(1,2)=output(1,2)+1;
     elseif test_model(i,1)==3
        output(1,3)=output(1,3)+1;
     elseif test_model(i,1)==4
        output(1,4)=output(1,4)+1;
     else 
        output(1,5)=output(1,5)+1;
     end;
 end;
 percentage=output*100/m;
 fprintf('               Confusion matrix for %s \n',model_name);
 fprintf('No. of frames:           %d          %d         %d       %d         %d\n',...
     output(1,1),output(1,2),output(1,3),output(1,4),output(1,5));
 fprintf('Percentage of frames:    %f    %f    %f    %f    %f\n',...
     percentage(1,1),percentage(1,2),percentage(1,3),percentage(1,4),...
     percentage(1,5));
 fprintf('                         1              2             3          4            5\n');
 fprintf('\n');
end

