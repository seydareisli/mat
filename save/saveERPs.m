clear all

cd('S:\Pool'); addpath(pwd); 
%addpath('P:\eeglab14_1_2b'); 
drive='X:\';
grps = {'Neurotypical','Autism'};

cases={'item1','item2','target','invalidThird','correct','catch','easyFiller','ctrlFiller'};

loadPath=[drive,'\Analyses\3DmatFiles\3Dmat4ML\preprocessed\']; 

subIDs={}; subGrps={}; for i = 1:length(grps); IDs = dir([loadPath,grps{i},'\1*.mat']); for j = 1:size(IDs,1)
ID=IDs(j).name(1:end-4); subIDs = [subIDs; ID]; subGrps = [subGrps; grps{i}]; end; end

load('timePts_122.mat','t');
    splt_turq4shades = [1 66 66; 32 107 107; 103 167 167 ; 167 204 204]/255;

rejTypes = {'SelectedBrain50','SelectedBrain20','RejectedNoise80','RejectedNoise50BrainSafety5'};
r=4; %for r=1:length(rejTypes)
rejType=rejTypes{r}; 
savePath =['X:\Analyses\4DmatFiles\',rejType,'\']; mkdir(savePath);

for k = 1:length(subIDs)
    
    load([loadPath,subGrps{k},filesep,subIDs{k},'.mat']);
    fprintf(['Loaded Subject ',subIDs{k},'\n']);
    
    for b=1:3
        if b==1; baseline=baseline50; baselineName='baseline50';
        elseif b==2; baseline=baseline100;baselineName='baseline100';
        elseif b==3; baseline=zeros(160,size(ERPs,3));baselineName='noBaseline';
        end
        
    % remove baseline
    for tr=1:size(ERPs,3);  ERPs(:,:,tr) = ERPs(:,:,tr) -baseline(:,tr); end
    
    %calculate avg ERPs for subject  4D:(cond,time,case,chan)
    clear avgERPs; avgERPs=zeros(4,length(t),8,160); 
    for ch=1:160;  for cs=1:length(cases); trig = trigs(cases{cs});
    for co=1:4; data=ERPs(ch,:,find(ismember(events,trig(co,:))));  
    avgERPs(co,:,cs,ch) = mean(data,3); end;end;end
    
%{
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
%}

    subSavePath = [savePath,baselineName,filesep,subGrps{k},filesep,subIDs{k},filesep]; mkdir(subSavePath);
    %save([subSavePath,'avgERPs.mat'],'t','avgERPs','subIDs','subGrps','avgBlockERPs','conds4blocks','rejType','cases','msBaseRemoved');
    save([subSavePath,'avgERPs.mat'],'avgERPs');
   
    end
end




