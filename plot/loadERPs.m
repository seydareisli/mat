rootDir = '/Volumes/users/Seydanur Tikir/';
mat = '/Users/Albert/Desktop/mat/'; addpath(genpath(mat)); 
cd([mat,'plot']); 
grps = {'Neurotypical','Autism'};
splt_turq4shades = [1 66 66; 32 107 107; 103 167 167 ; 167 204 204]/255;
cases={'item1','item2','target','invalidThird','correct','catch','easyFiller','ctrlFiller'};
rejTypes = {'SelectedBrain50','SelectedBrain20','RejectedNoise80','RejectedNoise50BrainSafety5'};
r=4;rejType = rejTypes{r};
load('timePts_122');EEGtimes=t;
lenT=122; nbchan=160;

subIDs={}; subGrps={}; for i = 1:length(grps); IDs = dir([rootDir,'Analyses',filesep,'4DmatFiles',filesep,rejType,filesep,'noBaseline',filesep,grps{i},filesep,'1*']); for j = 1:size(IDs,1)
ID=IDs(j).name; subIDs = [subIDs; ID]; subGrps = [subGrps; grps{i}]; end; end %.. and ..\.. is same. be safe
b=3;baselineNames={'baseline50','baseline100','noBaseline'};baselineName=baselineNames{b};
loadPath =[rootDir,filesep,'Analyses',filesep,'4DmatFiles',filesep,rejType,filesep,baselineName,filesep];
%% Load avgERPs and create a 5D allERPs matrix, the last dimension storing subjects 
allERPs= zeros(4,length(t),length(cases),160,length(subIDs));
for k=1:length(subIDs)
load([loadPath,subGrps{k},filesep,subIDs{k},filesep,'avgERPs.mat']);
allERPs(:,:,:,:,k) = avgERPs;
end % allERPs(1,2,1,8,44)
%% exclude subjects (it does a great job!!) 
outlierSubInds=[];
for co=1:2; for cs=1:3
    data=allERPs(co,:,cs,:,:); data=reshape(data,nbchan,lenT,size(data,5));
    GFP=mean(std(data));
    outlierSubInds =[outlierSubInds; find(isoutlier(GFP)==1)]; %subAvgGFP(outlierSubIDs) mean(subAvgGFP)+2*std(subAvgGFP)
end; end
unq=unique(outlierSubInds);
[a,b]=hist(outlierSubInds,unq); %returns distribution of outlierSubIDs, among bins with centers specified at inq
outlierSubInds=b((a>3));
subIDs{outlierSubInds};

% outlierSubInds=[2 9 12 23 ]
%outlierSubInds=[2 9 12 23 26 28] bu iyi bir fikir degil. 
%23 messes up! 12 messes up! if you dont reject 2, you dont plot NT at all
subIDs(outlierSubInds)=[]; subGrps(outlierSubInds)=[]; allERPs(:,:,:,:,outlierSubInds)=[];
fprintf('%d subjects were excluded\n',length(outlierSubInds));

%% Plot Indiv. GFPs and see if you want to reject further subjects
for k=1:length(subIDs)
figure; hold on; for cs=1:3; for co=1:4
    V = squeeze(allERPs(co,:,cs,:,k)); gfp=std(V'); 
    subplot(3,1,cs); hold on; plot(1:122,gfp,'Color',splt_turq4shades(co,:),'lineWidth',1); 
end; end;  sgtitle([num2str(k),'-',subIDs(k)]); 
pause(0.2); close
end
outlierSubInds=[2];
subIDs(outlierSubInds)=[]; subGrps(outlierSubInds)=[]; allERPs(:,:,:,:,outlierSubInds)=[];

% 12386 has alpha
% '12414' and '12443' has no catch trials? Subjects on and until 05/17/18: 10478,10906,12443,10594,12414 (no catch?)

subIDs(outlierSubInds)=[]; subGrps(outlierSubInds)=[]; allERPs(:,:,:,:,outlierSubInds)=[];
save('S:/pool/SPLT-allERPs.mat','subIDs', 'subGrps', 'allERPs');

%% further exclusion acc to late response - may not do a good job
%{
devs=zeros(1,length(subGrps));
chans15Oz=[10 11 12 13 14 15 23 24 25 26 27 28 39 40 41];
for k=1:length(subGrps); lateResp=reshape(squeeze(allERPs(1,[62:122],1,chans15Oz,k)),[1,61*15]);
devs(k)=std(lateResp); end
outlierSubIDs=find(isoutlier(devs)==1);
fprintf('%d subjects were excluded\n',length(outlierSubIDs));
subIDs{outlierSubIDs}
subIDs(outlierSubIDs)=[]; subGrps(outlierSubIDs)=[]; allERPs(:,:,:,:,outlierSubIDs)=[];
%}


