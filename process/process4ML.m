% Author: Seydanur Tikir (seydanurtikir@gmail.com)

drive='\\data.einsteinmed.org\Users\CNL Lab\Data_new\SPLT\';
%drive='/Volumes/users/Data_new/SPLT/'
loadPath=[drive,'\Analyses\ICAweightsApplied\']; 
savePath3D=[drive,'\Analyses\3DmatFiles\ICAweightsApplied']; 
savePath4D=[drive,'\Analyses\4DmatFiles\ICAweightsApplied']; 

cases={'item1','item2','target','invalidThird','correct','catch','easyFiller','ctrlFiller'};
grps={'Neurotypical','Autism'};
rejTypes={'RejectedNoise50BrainSafety5'  'RejectedNoise80' 'SelectedBrain20' 'BrainGreaterThanNoise' 'SelectedBrain50'};

addpath('S:/pool');

addpath('S:/eeglab');
eeglab;close;
addpath('S:/pool/functions');
  %addpath('P:\Analyses\Matlab')';
  
rejectionStats=zeros(50,6);
subj=0;
for i = 1:2
    IDs =dir([loadPath,grps{i},'\1*']);
    for j=1:length(IDs)
    fprintf(['Starting on ',IDs(j).name,'\n']);
    for r=1:length(rejTypes)
        rejType=rejTypes{r};
        
     %1. load EEG set (IC-rejected)
    EEG = pop_loadset([loadPath,grps{i},filesep,IDs(j).name,filesep,rejType,filesep,IDs(j).name,'.set']);

    %2. Remove any remaning bad channels
   % [EEG, badChans] = pop_rejchan(EEG, 'elec',[1:EEG.nbchan],'threshold',3.5,'norm','on','measure','spec','freqrange',[0.1 50] ); % 

    %3. interpolate 
    EEG = interpolate160(EEG,'S:/pool/');
    
    %1. set2mat 
    blockEndEvents=[101 102 103 104];
    epochLen=950;
    preStimTime = 150;

    stimuliTrigArr = {11, 14, 21, 24, 61, 64, 31, 34, 71, 74 41, 44, 81, 84, 12, 15, 22, 25, 62, 65, 32, 35, 72, 75, 42, 45, 82, 85, 13, 16, 23, 26, 33, 36, 43, 46, 92, 93, 94, 50, 60, 70, 80, 59, 69, 79, 89, 57, 67, 77, 87, 53, 56, 63, 66, 73, 76, 83, 86, 58, 68, 78, 88, 1, 2, 3, 4, 5, 6, 7, 8};
    stimuliTrigMat = [11, 14, 21, 24, 61, 64, 31, 34, 71, 74 41, 44, 81, 84, 12, 15, 22, 25, 62, 65, 32, 35, 72, 75, 42, 45, 82, 85, 13, 16, 23, 26, 33, 36, 43, 46, 92, 93, 94, 50, 60, 70, 80, 59, 69, 79, 89, 57, 67, 77, 87, 53, 56, 63, 66, 73, 76, 83, 86, 58, 68, 78, 88, 1, 2, 3, 4, 5, 6, 7, 8];
     [ERPs,preStim,events,evConds,evBlocks] = m_set2mat(EEG,stimuliTrigArr,stimuliTrigMat,blockEndEvents,epochLen,preStimTime);

     std([size(ERPs,3),size(preStim,3),size(events,2),size(evConds,2),size(evBlocks,2)])
    %2. correct fillers 
    ind = find(ismember(events,[1 2 3 4])); events(ind) = events(ind) + 1000* evConds(ind);

    %3. reject incorrects   
    trigCodes2remove=[ 59 69 79 89 57 67 77 87 58 68 78 88]);
    [ERPs,preStim,events,evConds,evBlocks] = m_rejectIncorrects(trigCodes2remove,ERPs,preStim,events,evConds,evBlocks);

      
    %4 reject Outlier trials 
    [subjRejStats,ERPs,preStim,events,evConds,evBlocks]= m_rejectOutliers(cases,ERPs,preStim,events,evConds,evBlocks);
    subj=subj+1; rejectionStats(subj,:)=[i str2num(IDs(j).name(1:end-4)) subjRejStats];

    %5. calculate baseline (nchanxnumTrials) 
    msBaseToRemove=50; baseline50=squeeze(mean(preStim(:,end-ms2time(msBaseToRemove):end,:),2)); 
    msBaseToRemove=100; baseline100=squeeze(mean(preStim(:,end-ms2time(msBaseToRemove):end,:),2)); 
  
    %6. save 3D
    subject_save_path_3D = [savePath3D,filesep,group{i},filesep,id(j).name]; mkdir(subject_save_path_3D);
    subject_save_path_4D  =[savePath4D,filesep,rejType,filesep,group{i},filesep,id(j).name];mkdir(subject_save_path_4D);
   
    save(subj_save_path_nondiv,'ERPs','evConds','events','evBlocks','t','baseline50','baseline100');
    saveDivided(subj_save_path_divided,ERPs,events,cases,n_conds,baseline50,baseline100);

    % 7. remove baseline :
    for tr=1:size(ERPs,3);  ERPs(:,:,tr) = ERPs(:,:,tr) -baseline50(:,tr); end

    % 8. calculate avg erps
    avgERPs = m_findAvgERPs(n_conds, cases,ERPs,events);

    % 9. save 4D
    
    
    %make dirs and save
    subj_save_path_divided=[savePath, grps{i},filesep,IDs(j).name,'\divided\'];mkdir(subj_save_path_divided);
    subj_save_path_nondiv=[savePath, grps{i},filesep,IDs(j).name,'\non-divided\'];mkdir(subj_save_path_nondiv);
    save(subj_save_path_nondiv,'ERPs','evConds','events','evBlocks','t','baseline50','baseline100');
    n_conds=4; saveDivided(subj_save_path_divided,ERPs,events,cases,n_conds,baseline50,baseline100);
    %Clean after yourself
    clear ERPs evConds events evBlocks t baseline50 baseline100 subjRejStats
        
    end
    rejectionStats(subj+1: end,:)=[];
end

rmdir([savePath, grps{1},filesep,'10056'],'s')

save('rejectionStats.mat','rejectionStats');
for s=1:50; if rejectionStats(s,1)==10056; break; end; end; rejectionStats(s,:)=[];
for s=1:50; rejectionStats(s,6)=rejectionStats(s,4)/rejectionStats(s,3)*100; end
for s=1:50; rejectionStats(s,7)=rejectionStats(s,5)/rejectionStats(s,3)*100; end
for s=1:50; rejectionStats(s,8)=rejectionStats(s,6)+rejectionStats(s,7); end
rejs=rmmissing(rejectionStats(:,8));
fprintf('On average, %.1f percent of trials were rejected (range:%.1f - %.1f)\n',mean(rejs),min(rejs),max(rejs));

drive='\\data.einsteinmed.org\Users\CNL Lab\Data_new\SPLT\';

splt_turq4shades = [1 66 66; 32 107 107; 103 167 167 ; 167 204 204]/255;
savedPath=[drive,'\Analyses\3DmatFiles\3Dmat4ML\preprocessed\']; 
savePath='X:\Analyses\conditionDesign\trials-on-x-axis';
grps={'Neurotypical','Autism'};
for i = 1:2
    IDs =dir([savedPath,grps{i},'\1*.mat']);
    for j=1:length(IDs)
clear 'evConds';load([savedPath, grps{i},filesep,IDs(j).name],'evConds');
    figure; hold on; for co=1:4; coInd=find(evConds==co); scatter(coInd,zeros(1,length(coInd))+co,10,'filled', 'MarkerFaceColor',splt_turq4shades(co,:)); end
    ylabel('Conditions');xlabel('trials');title(IDs(j).name(1:end-4));
    xlim([0 7500]); ylim([0.5 4.5]); yticks([1 2 3 4]); xticks([0 7500]);
        pause(0.3); 
    
    print('-dtiff','-r500',[savePath,filesep,IDs(j).name(1:end-4),'.jpeg']);
  clear  'evConds'
    close
    end
end
    
    
figure; for k=1:70;plot(std(mean(ERPs(:,:,outlierTrials1(k)),3)));pause(1);end


%THOSE OUTLIERS THAT ARE FOUND BY CHANNEL METHODS
% ARE THE ONES WHO HAVE HIGH GFP OUTLIERS!
    
  %  chansAVGed4Trials=[]; for ch=1:nchan; chansAVGed4Trials= [chansAVGed4Trials; mean(squeeze(ERPs(ch,:,:)),2)']; end
  %  figure; hold on; subplot(3,1,1); plot(t(:),chansAVGed4Trials); title('Std of all trials for nchan channels before trial rejection');  ylim([-15 15]);
   %if you say mean rather than grubbs, it will find 3STD from mean
   %Applies Grubbs' test for outliers, which is an iterative method that removes one outlier per iteration until no more outliers are found. 
%Grubbs method uses formal statistics   of hypothesis testing and gives more objective reasoning backed by statistics behind its outlier identification. It assumes normal distribution
   io=[]; for tm=1:122; for ch=1:nchan; data=squeeze(ERPs(ch,tm,:));  io = [io; find(isoutlier(data,'grubbs'))]; end; end
   [a,b]=hist(io,unique(io)); outlierTrials1 =b(find(isoutlier(a,'Mean')));
    fprintf('%d trials are labaled for rejection based on grubbs \n',length(outlierTrials1));
 %  figure;scatter(1:length(a),a,3,'filled')
   %numOuts=zeros(size(ERPs,3),1); numOuts(b)=a; thr_tm=min(numOuts(find(isoutlier(numOuts,'Grubbs'))));  fprintf(['thr_tm is %d \n'],thr_tm);
    
    io=[]; for tm=1:122; for ch=1:nchan; data=squeeze(ERPs(ch,tm,:));  io = [io; find(isoutlier(data,'mean'))]; end; end
    [a,b]=hist(io,unique(io)); outlierTrials2 =b(find(isoutlier(a,'Mean')));
    fprintf('%d trials are labaled for rejection based on mean \n',length(outlierTrials2));

    
    outlierTrials=outlierTrials2;
    ERPs(:,:,outlierTrials)=[]; preStim(:,:,outlierTrials)=[]; events(outlierTrials)=[]; evConds(outlierTrials)=[]; evBlocks(outlierTrials)=[];
    

end
end



    sgtitle(IDs(j).name(1:end-4));
    figure;scatter(1:size(ERPs,3),max(maxChans),3,'markerFaceColor','r','markerEdgeColor','r');xlabel('trials');
    hold on; scatter(outlierTrials,max(maxChans(:,outlierTrials)),3,'markerFaceColor','r','markerEdgeColor','r');xlabel('trials');
    ERPs(:,:,outlierTrials)=[]; preStim(:,:,outlierTrials)=[]; events(outlierTrials)=[]; evConds(outlierTrials)=[]; evBlocks(outlierTrials)=[];
    chansAVGed4Trials=[]; for ch=1:nchan; chansAVGed4Trials= [chansAVGed4Trials; mean(squeeze(ERPs(ch,:,:)),2)']; end
    hold on; subplot(3,1,3); plot(t(:),chansAVGed4Trials); title('Std of all trials for nchan channels after trial rejection');  ylim([-15 15]);
    pause(1); print('-dtiff','-r500',[savedPath,'figures-trial-stats',filesep,IDs(j).name(1:end-4),'.jpeg']);
    close
     


    
    end    
end

%{

 %calculate avg ERPs for subject  4D:(cond,time,case,chan)
    clear newERPs; newERPs=zeros(4,length(t),8,nchan); 
    for ch=1:nchan;  for cs=1:length(cases); trig = trigs(cases{cs});
    for co=1:4; data=ERPs(ch,:,find(ismember(events,trig(co,:))));  
    newERPs(co,:,cs,ch) = mean(data,3); end
    end;end

%}