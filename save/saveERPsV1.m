clear all

cd('X:\_Matlab'); addpath(pwd); 
%addpath('P:\eeglab14_1_2b'); 
grps = {'Neurotypical','Autism'};

cases={'item1','item2','target','invalidThird','correct','catch','easyFiller','ctrlFiller'};
 
subIDs={}; subGrps={}; for i = 1:length(grps); IDs = dir(['X:\Analyses\3DmatFiles\',grps{i},'\1*']); for j = 1:size(IDs,1)
ID=IDs(j).name; subIDs = [subIDs; ID]; subGrps = [subGrps; grps{i}]; end; end
load('X:\_Matlab\timePts_122.mat','t');

rejTypes = {'SelectedBrain50','SelectedBrain20','RejectedNoise80','RejectedNoise50BrainSafety5'};
for r=1:length(rejTypes)
rejType=rejTypes{r}; savePath =['X:\Analyses\4DmatFiles\',rejType,'\']; mkdir(savePath);

for k = 1:length(subIDs)
    
    load(['X:\Analyses\3DmatFiles\',subGrps{k},filesep,subIDs{k},filesep,rejType,filesep,'ERPs.mat']);
    fprintf(['Loaded Subject ',subIDs{k},'\n']);
    
    % remove baseline
    msBaseRemoved=50; [m1,m2]=min(abs(t_preStim+msBaseRemoved));  %m2 will give you the time index for 'msBaseRemoved'
    baseline=squeeze(mean(preStim(:,m2:end,:),2)); for tr=1:size(ERPs,3);  ERPs(:,:,tr) = ERPs(:,:,tr) -baseline(:,tr); end

    
    %Plot subject std of all trials for each channel
    chansAVGed4Trials=[]; for ch=1:160; chansAVGed4Trials= [chansAVGed4Trials; mean(squeeze(ERPs(ch,:,:)),2)']; end
    figure; hold on; subplot(2,1,1); plot(t(:),chansAVGed4Trials); title('Std of all trials for each channel');  ylim([-15 15]);
  %{ 
%reject channels
    areaUnder = sum(abs(chansAVGed4Trials)');
    thr1=10000; maxVals(areaUnder>thr1) = [];% Get rid of outliers
    thr2 = mean(areaUnder) + 3*std(areaUnder);% Set threshold based on normal distribution
    chans=[1:160]; outlierCh = chans(areaUnder>thr2);
    fprintf('Number of channels to reject is %d \n',length(outlierCh));
    ERPs(outlierCh,:,:)=[]; preStim(outlierCh,:,:)=[]; % nothing to delete from trials/events
%}
       
   % Find outliers 
    maxVals = squeeze(max(max(abs(ERPs(:,:,:)))));
    maxVals(maxVals>100) = [];% Get rid of outliers
    thr = mean(maxVals) + 3*std(maxVals);% Set threshold based on normal distribution
    trOutVal =[];   for tr=1:size(ERPs,3); trOutVal = [trOutVal  mean(sum((ERPs(:,:,tr)>thr))) + mean(sum((ERPs(:,:,tr)<-thr)))]; end
    indNonZero=find(trOutVal~=0);
    outlierOfNonZero = find(isoutlier(trOutVal(indNonZero),'grubbs')==1);
    outlierTrials3 = indNonZero(outlierOfNonZero);
    fprintf('Rejecting %d trials  \n',length(outlierTrials3));
    

   
    %Plot outliers
    subplot(2,1,2); scatter(1:length(trOutVal),trOutVal,3,'filled');  xlabel('trials'); sgtitle(subIDs{k});
    hold on; scatter(outlierTrials,trOutVal(outlierTrials),3,'markerFaceColor','r','markerEdgeColor','r');xlabel('trials');
    print('-dtiff','-r500',[savePath,filesep,'Subject',subIDs{k},'.jpeg']);
    pause(1); close
    ERPs(:,:,outlierTrials)=[]; preStim(:,:,outlierTrials)=[]; events(outlierTrials)=[]; evConds(outlierTrials)=[]; evBlocks(outlierTrials)=[];
     
        
    splt_turq4shades = [1 66 66; 32 107 107; 103 167 167 ; 167 204 204]/255;
    figure; hold on; for co=1:4; coInd=find(evConds==co); scatter(coInd,zeros(1,length(coInd))+co,10,'filled', 'MarkerFaceColor',splt_turq4shades(co,:)); end
    pause(1); close

 
    %calculate avg ERPs for subject  4D:(cond,time,case,chan)
    clear avgERPs; avgERPs=zeros(4,length(t),8,160); 
    for ch=1:160;  for cs=1:length(cases); trig = trigs(cases{cs});
    for co=1:4; data=ERPs(ch,:,find(ismember(events,trig(co,:))));  
    avgERPs(co,:,cs,ch) = mean(data,3); end;end;end
    

    %test calculate avg blocks ERPs for subject  5D:(block,time,case,chan)
    clear avgBlockERPs; avgBlockERPs=zeros(70,length(t),8,160); conds4blocks=zeros(1,70);
    for ch=1:160;  for cs=1:length(cases); trig = trigs(cases{cs});
    for bl=unique(evBlocks)
            ind1=find(evBlocks==bl);
            ind2=find(ismember(events,trig));
            ind=intersect(ind1,ind2);
            data=ERPs(ch,:,ind); conds4blocks(bl)=mean(evConds(ind));
            avgBlockERPs(bl,:,cs,ch) = mean(data,3); 
    end;end;end


    subSavePath = [savePath,subGrps{k},filesep,subIDs{k},filesep]; mkdir(subSavePath);
    save([subSavePath,'avgERPs.mat'],'t','avgERPs','subIDs','subGrps','avgBlockERPs','conds4blocks','rejType','cases','msBaseRemoved');
    
   
end
end


