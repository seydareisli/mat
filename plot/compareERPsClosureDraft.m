% Author: Seydanur Tikir (seydanurtikir@gmail.com)

nbchan=128;
length(t)
grpInds={[1:length(subIDs)]};
grps={'Adult'};
conds={'C'};
   
%% Load avgERPs and create a 5D allERPs matrix, the last dimension storing subjects 
allERPs= zeros(1,length(t),length(cases),128,length(subIDs));
for k=1:length(subIDs)
load(['P:\Analyses\4DmatFiles\',rejType,filesep,subGrps{k},filesep,subIDs{k},'\avgERPs.mat'],'t','avgERPs','subIDs','subGrps','rejType','cases','msBaseRemoved');
allERPs(:,:,:,:,k) = avgERPs;
end % allERPs(1,2,1,8,44)

%Quick look at ERPs   allERPs(co,tWin,cs,ch,k)
%co=1;cs=4;ch=14;for k=2:4;figure; plot(t,allERPs(co,:,cs,ch,k0)); title(num2str(k));pause(1);close;end

%% Calculating GFPs
GFPs=zeros(length(conds),length(t),length(cases),length(subIDs));
for k=1:length(subIDs)
    for cs=1:length(cases)
        for co=1:length(conds)
            data = squeeze(allERPs(co,:,cs,:,k)); 
            GFPs(co,:,cs,k)=std(data');
        end
    end
end


%% exclude subjects (it does a great job!!) 
outlierSubIDs=[];
exCos=[1]; exCss=[1:8];
for co=exCos; for cs=exCss;
subAvgGFP= squeeze(mean(GFPs(co,:,cs,:),2));
outlierSubIDs =[outlierSubIDs; find(isoutlier(subAvgGFP)==1)]; %subAvgGFP(outlierSubIDs) mean(subAvgGFP)+2*std(subAvgGFP)
end; end
outlierSubIDs=sort(outlierSubIDs); 
unq = unique(outlierSubIDs);
freqs = [unq,histc(outlierSubIDs(:),unq)];
outlierSubIDs=freqs(find(freqs(:,2)>2),1);
subIDs(outlierSubIDs)=[]; subGrps(outlierSubIDs)=[]; allERPs(:,:,:,:,outlierSubIDs)=[]; GFPs(:,:,:,outlierSubIDs)=[]; 
fprintf('%d subjects were excluded\n',length(outlierSubIDs));

%% Plot Indiv. GFPs and see if you want to reject further subjects
for k= 1:length(subIDs); 
figure; hold on; 
for cs=1:3; 
for co=1:length(conds);
    V = squeeze(allERPs(co,:,cs,:,k)); gfp=std(V'); 
    subplot(3,1,cs); hold on; plot(1:length(t),gfp,'Color',splt_turq4shades(co,:),'lineWidth',1); 
end; end; 
sgtitle([num2str(k),'-',subIDs(k)]); pause(0.5); close
end
%outlierSubIDs=[ 9 35 38];
%subIDs(outlierSubIDs)=[]; subGrps(outlierSubIDs)=[]; allERPs(:,:,:,:,outlierSubIDs)=[]; GFPs(:,:,:,outlierSubIDs)=[]; 
% '12414' and '12443' has no catch trials? Subjects on and until 05/17/18: 10478,10906,12443,10594,12414 (no catch?)


%% further exclusion acc to late response
devs=zeros(1,length(subGrps));
chans15Oz=[10 11 12 13 14 15 23 24 25 26 27 28 39 40 41];
for k=1:length(subGrps); lateResp=reshape(squeeze(allERPs(1,[62:length(t)],1,chans15Oz,k)),[1,61*15]);
devs(k)=std(lateResp); end
outlierSubIDs=find(isoutlier(devs)==1);
GFPs(:,:,:,outlierSubIDs)=[]; 
fprintf('%d subjects were excluded\n',length(outlierSubIDs));
subIDs{outlierSubIDs}
subIDs(outlierSubIDs)=[]; subGrps(outlierSubIDs)=[]; allERPs(:,:,:,:,outlierSubIDs)=[];

% find indNT and indASD
for k=1:length(subGrps); if strcmp(subGrps{k},'Autism'); ind=k; break; end; end
indASD = [ind:length(subGrps)]; indNT = [1:ind-1]; indAll=[1:length(subGrps)];
grpInds={indNT,indASD,indAll}; grpIndNames= {'NT','ASD','All'};

%take avg of ERPs for each grp
grpERPs=zeros(5,length(t),length(cases),nbchan,2);
grpERPs(:,:,:,:,1) = mean(allERPs(:,:,:,:,indNT),5);
grpERPs(:,:,:,:,2) = mean(allERPs(:,:,:,:,indASD),5);



%% Pre-calculating grpGFPs
grpGFPs=zeros(1,length(t),length(cases),length(grps));
for i=1:length(grps); k=grpInds{i}; for cs=1:length(cases); for co=1:length(conds); g=squeeze(allERPs(co,:,cs,:,k)); 
gfp=[]; for kk=1:length(k); gfp=[gfp; std(g(:,:,kk)')]; end; grpGFPs(co,:,cs,i)=mean(gfp,1);
end; end; end

