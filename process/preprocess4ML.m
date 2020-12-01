grps = {'Neurotypical','Autism'};
cases={'item1','item2','target','invalidThird','correct','catch','easyFiller','ctrlFiller'};

for i = 1:numel(group); grp=group{i};
    id = dir(['M:\M-PRO Analyses\',filesep,grp,filesep,'*.mat']) ; 
    for j = 1:size(id,1) ; subjectID = id(j).name; fprintf('___ID: %s\n',subjectID)
      
    load(['.',filesep,grp,filesep,id(j).name,'ERPs.mat']);
    
    %Plot subject std of all trials for each channel
    chansAVGed4Trials=[]; for ch=1:160; chansAVGed4Trials= [chansAVGed4Trials; mean(squeeze(ERPs(ch,:,:)),2)']; end
    figure; hold on; subplot(2,1,1); plot(t(:),chansAVGed4Trials); title('Std of all trials for each channel');  ylim([-15 15]);
 
   % Calculate max/min values of epochs
    maxVals = squeeze(max(max(abs(ERPs(:,:,:)))));
    thr1=100; maxVals(maxVals>thr1) = [];% Get rid of outliers
    thr2 = mean(maxVals) + 3*std(maxVals);% Set threshold based on normal distribution
    trOutVal =[];   for tr=1:size(ERPs,3); trOutVal = [trOutVal  mean(sum((ERPs(:,:,tr)>thr2))) + mean(sum((ERPs(:,:,tr)<-thr2)))]; end
    indNonZero=find(trOutVal~=0);
    outlierOfNonZero = find(isoutlier(trOutVal(indNonZero),'grubbs')==1);
    outlierTrials = indNonZero(outlierOfNonZero);
    fprintf('Rejecting %d trials  \n',length(outlierTrials));
    subplot(2,1,2); scatter(1:length(trOutVal),trOutVal,3,'filled');  xlabel('trials'); sgtitle(subIDs{k});
    hold on; scatter(outlierTrials,trOutVal(outlierTrials),3,'markerFaceColor','r','markerEdgeColor','r');xlabel('trials');
    print('-dtiff','-r500',[savePath,filesep,'Subject',subIDs{k},'.jpeg']);
    pause(1); close
    ERPs(:,:,outlierTrials)=[]; preStim(:,:,outlierTrials)=[]; events(outlierTrials)=[]; evConds(outlierTrials)=[]; evBlocks(outlierTrials)=[];
                                     
    splt_turq4shades = [1 66 66; 32 107 107; 103 167 167 ; 167 204 204]/255;
    figure; hold on; for co=1:4; coInd=find(evConds==co); scatter(coInd,zeros(1,length(coInd))+co,10,'filled', 'MarkerFaceColor',splt_turq4shades(co,:)); end
    pause(1); close

    
    % remove baseline
    msBaseRemoved=50; [m1,m2]=min(abs(t_preStim+msBaseRemoved)); 
    %m2 will give you the time index for 'msBaseRemoved'
    baseline=squeeze(mean(preStim(:,m2:end,:),2)); for tr=1:size(ERPs,3);  ERPs(:,:,tr) = ERPs(:,:,tr) -baseline(:,tr); end

    %calculate avg ERPs for subject  4D:(cond,time,case,chan)
    clear avgERPs; avgERPs=zeros(4,length(t),8,160); 
    for ch=1:160;  for cs=1:length(cases); trig = trigs(cases{cs});
    for co=1:4; data=ERPs(ch,:,find(ismember(events,trig(co,:))));  
    avgERPs(co,:,cs,ch) = mean(data,3); end
    avgERPs(5,:,cs,ch) = mean(ERPs(ch,:,find(ismember(events,trig))),3);end;end
    

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


