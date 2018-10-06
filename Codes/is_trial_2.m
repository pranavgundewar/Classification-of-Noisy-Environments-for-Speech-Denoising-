% Each calculated for 2 different methods of enhancement:
%  1. Autocorrelation subtraction
%  2. Iterative spectral subtraction
% for each frame of each file two distances are computed
%  1. distance between clean frame and noisy frame
%  2. distance between clean frame and enhanced frame.


clc;
clear all;
close all;
%%
% directory paths for the clean files
clean_paths={'F:\College Stuff\BE Project\Final\Audio Class Samples\Restaurant Noise\filtered_podcast1_restaurant2.m4a'};
% directory paths for the input files
input_paths={'F:\College Stuff\BE Project\Final\Audio Class Samples\Restaurant Noise\podcast1+restaurant_noise\podcast1+restaurant_noise2.m4a'};
%%
%finds maximum number of frames present in a file
len = length(input_paths); 
nFrames_max = 0;
Frames = zeros(len,1);
for index = 1:len
    ip = input_paths{index};
    [arr,Fs] =audioread(ip);
    if index==1
        samples = floor(Fs*20/1000);
    end
    temp = floor(length(arr)/samples);
    Frames(index)= temp;
    if nFrames_max < temp
        nFrames_max = temp;
    end
end
%%
%initializations for calulating LP parameters
order = 12;
a    = zeros(len,nFrames_max,order);
rs   = zeros(len,nFrames_max,order);
aEn  = zeros(len,nFrames_max,order);
rsEn = zeros(len,nFrames_max,order);
aCl  = zeros(len,nFrames_max,order);
rsCl = zeros(len,nFrames_max,order);



%calculating various distance measures
for index= 1:len
  %Reading noisy file, reading corresponding clean file and enhanced file  
    ip = input_paths{index};
    [arr,Fs] = audioread(ip); 
    select_clean=mod(index,7);
    if select_clean==0
        select_clean=7;
    end
    cl_ip=clean_paths{select_clean};
    arrCl= audioread(cl_ip);
    nFrames= Frames(index);    
    ip1= ip(1:end-4);
    for method=1:2
                
        switch method
            case 1
                enFName= strcat(ip1,'_enhan_autosub.wav');              
            case 2
                enFName= strcat(ip1,'_enhan_iter.wav');                
                          
        end
        % directory paths for the pure speech files
        arrEn = audioread('F:\College Stuff\BE Project\Final\Audio Class Samples\pure_podcast1_2min.m4a');

        arrEn=arrEn';
        if (size(arrEn,2)>1)
            arrEn = (sum(arrEn,2)/2);   % converting to mono
        end;
%         N1=min(length(arr),length(arrEn));
%         N2=min(length(arrCl),N1);
%         arrEn=arrEn(1:N2,:);
%         arr=arr(1:N2,:);
%         arrCl=arrCl(1:N2,:);
        arrEn= [arrEn; zeros(length(arr)-length(arrEn),1)];              
  
        %doing framewise calculations required for IS measure and LLR measure   
        for i = 1 : nFrames
           
            if ( i == nFrames )
                currFrame = arr(((i-1)*samples+1):end);
                currFrame = [currFrame; zeros(samples-length(currFrame),1)];
                
                currFrameEn = arrEn(((i-1)*samples+1):end);
                currFrameEn = [currFrameEn; zeros(samples-length(currFrameEn),1)];
                
                currFrameCl= arrCl(((i-1)*samples+1):end);
                currFrameCl = [currFrameCl; zeros(samples-length(currFrameCl),1)];
                for eta = 1:order
                    for n = 1+eta: samples
                        rs(index,i,eta) = rs(index,i,eta)+currFrame(n)*currFrame(n-eta);
                        rsEn(index,i,eta) = rsEn(index,i,eta)+currFrameEn(n)*currFrameEn(n-eta);
                        rsCl(index,i,eta)= rsCl(index,i,eta) +currFrameCl(n)*currFrameCl(n-eta);
                    end
                  %treating this case sepearately so as to do the
                  %required padding for completing the last frame    
                end
          
            else
                currFrame = arr(((i-1)*samples+1): i*samples);
                currFrameEn = arrEn(((i-1)*samples+1): i*samples);
                currFrameCl = arrCl(((i-1)*samples+1): i*samples);
                
                for eta = 1:order
                    for n = 1+eta: samples
                        rs(index,i,eta) = rs(index,i,eta)+currFrame(n)*currFrame(n-eta);
                        rsEn(index,i,eta) = rsEn(index,i,eta)+currFrameEn(n)*currFrameEn(n-eta);
                        if index<=8
                            rsCl(select_clean,i,eta)= rsCl(select_clean,i,eta) +currFrameCl(n)*currFrameCl(n-eta);
                        end
                    end
                end
            end
            
            a(index,i,:)= lpc(currFrame,order-1);
            aEn(index,i,:)=lpc(currFrameEn,order-1);                        
            gains(index,i)= sqrt(abs(squeeze(rs(index,i,:))'*squeeze(a(index,i,:))));
            gains_enhan(index,i)=sqrt(abs(squeeze(rsEn(index,i,:))'*squeeze(aEn(index,i,:))));            
            if index <= 8
                aCl(select_clean,i,:)=lpc(currFrameCl,order-1);
                gains_clean(select_clean,i)=sqrt(abs(squeeze(rsCl(select_clean,i,:))'*squeeze(aCl(select_clean,i,:))));
            %calculation of these parameters can be done only for the first 8
            %times as the same are used repeatedly
            end            
            alpha = squeeze(squeeze(aCl(select_clean,i,:)));
            beta  = squeeze(squeeze(a(index,i,:)));
            gamma = squeeze(squeeze(aEn(index,i,:)));            
            R = toeplitz(rsCl(select_clean,i,:));
                     
            %At this stage we have parameters for calculating the
            %IS measure and LLR measure. Following are required for calculating segmental SNR                                        
            
            ener_currCl(i,1)= sum(currFrameCl.^2);
%            ener_noise_CE(i,1)= sum((currFrameCl-currFrameEn).^2);
 %           ener_noise_CN(i,1)= sum((currFrameCl-currFrame).^2);
                        
            switch method
                %implementing formulae for distance measures for the
                %appropriate method of enhancement
                case 1
                    ISdistCN_autosub(index,i) = (((beta'*R*beta)/(alpha'*R*alpha))*gains_clean(select_clean,i)/gains(index,i))+log(gains(index,i)/gains_clean(select_clean,i))-1;
                    ISdistCE_autosub(index,i) =  (((gamma'*R*gamma)/(alpha'*R*alpha))*gains_clean(select_clean,i)/gains_enhan(index,i))+log(gains_enhan(index,i)/gains_clean(select_clean,i))-1;
                
                    
                case 2
                    ISdistCN_iter(index,i) = (((beta'*R*beta)/(alpha'*R*alpha))*gains_clean(select_clean,i)/gains(index,i))+log(gains(index,i)/gains_clean(select_clean,i))-1;
                    ISdistCE_iter(index,i) =  (((gamma'*R*gamma)/(alpha'*R*alpha))*gains_clean(select_clean,i)/gains_enhan(index,i))+log(gains_enhan(index,i)/gains_clean(select_clean,i))-1;
                
            end
        end
    end
   
end



%calculating mean IS measure and LLR measure by removing the frames for
%which we get absolute silence and hence don't have a LP model assosiated with them 
for method =1:4
    sum=0;
    count=0;
 
    
    switch method
        case 1          
                    
            rem_abssi_frames= isnan(ISdistCE_autosub);
            rem_abssi_frames_CN= isnan(ISdistCN_autosub);

            for index=1:len
               nFrames= Frames(index);
                  ISdistCE_autosub_avg(index,1)= nanmean(ISdistCE_autosub(index,1:nFrames),2);

                sum=0;
                count=0;
   
                for i= 1:nFrames
                    
                    if rem_abssi_frames(index,i)==0 && rem_abssi_frames_CN(index,i)==0
                        sum=sum+ISdistCN_autosub(index,i);
                        count=count+1;
                    end
                    ISdistCN_autosub_avg(index,1)= sum/count;
                end
                 
            end
            
        case 2
                     
            rem_abssi_frames= isnan(ISdistCE_iter);
            rem_abssi_frames_CN= isnan(ISdistCN_iter);
          
            for index=1:len
                 nFrames= Frames(index);
                  ISdistCE_iter_avg(index,1)= nanmean(ISdistCE_iter(index,1:nFrames),2);
             
                  sum=0;
                count=0;
             
                for i= 1:Frames(index)
                    
                    if rem_abssi_frames(index,i)==0 && rem_abssi_frames_CN(index,i)==0
                        sum=sum+ISdistCN_iter(index,i);
                        count=count+1;
                    end
                    ISdistCN_iter_avg(index,1)= sum/count;
                end
               
            end
           
            
      
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


input_paths={'F:\College Stuff\BE Project\Final\Audio Class Samples\Restaurant Noise\podcast1+restaurant_noise\podcast1+restaurant_noise2.m4a'};

figure(1)
hold on
stem(ISdistCN_autosub_avg,':ok','MarkerFaceColor','red','MarkerEdgeColor','k')
stem(abs(ISdistCE_autosub_avg),':ok','MarkerFaceColor','cyan','MarkerEdgeColor','k')
%set(gca, 'XTick', 1:length(input_paths), 'XTickLabel', input_paths)
set(gca, 'XTick', 1:length(input_paths))
%rotateXLabels(gca,90);
hold off
xlabel('Input Files');
ylabel('IS Distance');
title({'Itakura-Saito Distance'})
legend('Clean-Noisy','Clean-Enhanced')

% figure(2)
% hold on
% stem(ISdistCN_autosub_avg(15:28),':ok','MarkerFaceColor','red','MarkerEdgeColor','k')
% stem(abs(ISdistCE_autosub_avg(15:28)),':ok','MarkerFaceColor','cyan','MarkerEdgeColor','k')
% set(gca, 'XTick', 1:length(input_paths(15:28)), 'XTickLabel', input_paths(15:28))
% rotateXLabels(gca,90);
% hold off
% xlabel('Input Files');
% ylabel('IS Distance');
% title({'Itakura-Saito Distance For Different Files ( Using Autosub Implementation )',' Environment - Street'})
% legend('Clean-Noisy','Clean-Enhanced')
% 
% figure(3)
% hold on
% stem(ISdistCN_autosub_avg(29:42),':ok','MarkerFaceColor','red','MarkerEdgeColor','k')
% stem(abs(ISdistCE_autosub_avg(29:42)),':ok','MarkerFaceColor','cyan','MarkerEdgeColor','k')
% set(gca, 'XTick', 1:length(input_paths(29:42)), 'XTickLabel', input_paths(29:42));
% rotateXLabels(gca,90);
% hold off
% xlabel('Input Files');
% ylabel('IS Distance');
% title({'Itakura-Saito Distance For Different Files ( Using Autosub Implementation )',' Environment - Exibition '})
% legend('Clean-Noisy','Clean-Enhanced')
% hold off
% 
% %%
% 
% figure(4)
% hold on
% stem(ISdistCN_iter_avg(1:14),':ok','MarkerFaceColor','red','MarkerEdgeColor','k')
% stem(abs(ISdistCE_iter_avg(1:14)),':ok','MarkerFaceColor','cyan','MarkerEdgeColor','k')
% set(gca, 'XTick', 1:length(input_paths(1:14)), 'XTickLabel', input_paths(1:14))
% rotateXLabels(gca,90);
% hold off
% xlabel('Input Files');
% ylabel('IS Distance');
% title({'Itakura-Saito Distance For Different Files ( Using ''Iterative method'' )',' Environment - Car'})
% legend('Clean-Noisy','Clean-Enhanced')
% 
% 
% figure(5)
% hold on
% stem(ISdistCN_iter_avg(15:28),':ok','MarkerFaceColor','red','MarkerEdgeColor','k')
% stem(abs(ISdistCE_iter_avg(15:28)),':ok','MarkerFaceColor','cyan','MarkerEdgeColor','k')
% set(gca, 'XTick', 1:length(input_paths(15:28)), 'XTickLabel', input_paths(15:28))
% rotateXLabels(gca,90);
% hold off
% xlabel('Input Files');
% ylabel('IS Distance');
% title({'Itakura-Saito Distance For Different Files ( Using Iterative method )',' Environment - Street '})
% legend('Clean-Noisy','Clean-Enhanced')
% 
% figure(6)
% hold on
% stem(ISdistCN_iter_avg(29:42),':ok','MarkerFaceColor','red','MarkerEdgeColor','k')
% stem(abs(ISdistCE_iter_avg(29:42)),':ok','MarkerFaceColor','cyan','MarkerEdgeColor','k')
% set(gca, 'XTick', 1:length(input_paths(29:42)), 'XTickLabel', input_paths(29:42));
% rotateXLabels(gca,90);
% hold off
% xlabel('Input Files');
% ylabel('IS Distance');
% title({'Itakura-Saito Distance For Different Files ( Using Iteration method )',' Environment - Exibition'})
% legend('Clean-Noisy','Clean-Enhanced')
hold off


