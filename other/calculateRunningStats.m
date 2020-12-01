
%running dependent samples t-tests were performed between summed and multisensory conditions (for aligned and misaligned conditions) 
%across all channels and time points
%The rationale for this method is that Type I errors are unlikely to endure for several consecutive time points.
%This approach gives an assessment of significant effects of response type across the entire epoch and displays the p-values as a two-dimensional statistical color-scaled map [see Statistical Cluster Plots (SCPs)].
addpath('S:\pool\functions\permutools');
clear all
addpath('S:\pool\functions');
load('S:\pool\chanlocs');
load('S:\pool\chanlocs.mat');numChans = length(chanlocs);
alphas=[0.01 0.05 ];
tails={'both','right','left'};
cases={'item1','item2','target','invalidThird','correct','catch','filler','ctrlFiller'};

loadERPs; % to load allERPs
k1=find(subGrps=="Neurotypical"); k2=find(subGrps=="Autism"); n=length(subGrps);
grpArr =[subGrps; subGrps; subGrps; subGrps]; 
cndArr=[zeros(n,1)+1;zeros(n,1)+2;zeros(n,1)+3;zeros(n,1)+4];


testTypes={'ANOVA','ttest','tstat','permutationTest','onesampleNT','compConds','compItemsToItem1NT','compItemsNT','compItemsASD'}; % since there is no Co variable for ANOVA, we will store 3 types of effects (grp, cond, grp-cdn interac) in co's place. 
compItemsMat=[1 2; 3 6; 4 7; 7 8; 1 8; 3 4; 6 7];

%runningP=zeros(122,7,160,4,2,3,5);
%load('S:\pool\runningP.mat','runningP');
for tt=9:9; testType=testTypes{tt};
for ta=1:1; tail=tails{ta};
for al =1:1; alpha=alphas(al);
for cs=1:7;  fprintf(['starting ', cases{cs},'\n']);
for co=1:4
    V1=squeeze(allERPs(co,:,cs,:,k1)); V2=squeeze(allERPs(co,:,cs,:,k2)); 
for ch=1:160
for tp=1:122
    if strcmp(testType,'ANOVA'); if co==4; continue; end
        V=squeeze(allERPs(:,tp,cs,ch,[k1;k2])); V=V'; V=reshape(V,4*size(V,1),1);
        [p, tbl, stats]=anovan(V,{grpArr,cndArr},'model','interaction','display' ,'off'); 
        if co==1; p=p(1); elseif co==2; p=p(2); elseif co==3; p=p(3); elseif co==4; p=missing; end
    elseif strcmp(testType,'ttest')
        [h,p,ci,stats] = ttest2(V1(tp,ch,:),V2(tp,ch,:),'Tail',tail,'Alpha',alpha);
    elseif strcmp(testType,'tstat')
        [h,~,ci,stats] = ttest2(V1(tp,ch,:),V2(tp,ch,:),'Tail',tail,'Alpha',alpha);
        p=squeeze(stats.tstat);
    elseif strcmp(testType,'permutationTest')
        [r,stats] = permtest_corr(V1(tp,ch,:),V2(tp,ch,:),'alpha', alpha, 'nperm',10000,'tail',tail,'rows','complete','type','Pearson');
        p=stats.p;
    elseif strcmp(testType,'onesampleNT')
        [h,p,ci,stats] = ttest(V1(tp,ch,:),V1(1,ch,:),'Tail',tail,'Alpha',alpha);
    elseif strcmp(testType,'compConds') 
        if co==1; V1=squeeze(allERPs(1,:,cs,:,k1)); V2=squeeze(allERPs(3,:,cs,:,k1)); 
        elseif co==2; V1=squeeze(allERPs(2,:,cs,:,k1)); V2=squeeze(allERPs(4,:,cs,:,k1)); 
        elseif co==3; V1=squeeze(allERPs(1,:,cs,:,k2)); V2=squeeze(allERPs(3,:,cs,:,k2)); 
        elseif co==4; V1=squeeze(allERPs(2,:,cs,:,k2)); V2=squeeze(allERPs(4,:,cs,:,k2)); 
        end
        [h,p,ci,stats] = ttest(V1(tp,ch,:),V1(1,ch,:),'Tail',tail,'Alpha',alpha);
    elseif strcmp(testType,'compItemsToItem1NT')
        V1=squeeze(allERPs(co,:,cs,:,k1)); V2=squeeze(allERPs(co,:,1,:,k1)); 
        [h,p,ci,stats] = ttest(V1(tp,ch,:),V2(tp,ch,:),'Tail',tail,'Alpha',alpha);    
    elseif strcmp(testType,'compItemsNT')
        V1=squeeze(allERPs(co,:,compItemsMat(cs,1),:,k1)); V2=squeeze(allERPs(co,:,compItemsMat(cs,2),:,k1));
        [h,p,ci,stats] = ttest(V1(tp,ch,:),V2(tp,ch,:),'Tail',tail,'Alpha',alpha);    
    elseif strcmp(testType,'compItemsASD')
        V1=squeeze(allERPs(co,:,compItemsMat(cs,1),:,k2)); V2=squeeze(allERPs(co,:,compItemsMat(cs,2),:,k2));
        [h,p,ci,stats] = ttest(V1(tp,ch,:),V2(tp,ch,:),'Tail',tail,'Alpha',alpha);    
    end
    runningP(tp,cs,ch,co,al,ta,tt)=squeeze(p); 
end;end;end;end;end;end;end
%save('S:\pool\runningP.mat','runningP');



%{
Writing about the SCP method that I applied :

ANOVA  was performed at each time Point (122 time points X 160 channels = 19520 tests). 
To control for type 2 errors, we applied a further level of analyses. We counted a test that was sound to be significant only if testi at consecutive time points and  neighbouring channels also show significance. 
Specifically, we looked at one time point before and arter, and 8 surrounding channels having the same diameter distance to our channel (8x3=24 values) and make sure that at least half of these values are significant before actually accepting the significance. 

%}


% x=6,7th



load('S:\pool\runningP.mat','runningP');
addpath('S:\pool\functions\permutools');
addpath('S:\pool\functions');
winsOf25 = zeros(38,7,160,3);
for cs=1:7; for e=1:3 for w=1:38; for ch=1:160; timeWin=ms2time((w-1)*25:w*25-1);
winsOf25(w,cs,ch,e)=mean(runningP(timeWin,cs,ch,e,1,1,1));
end; end; end; end
labels25ms=zeros(1,38);for w=1:38; labels25ms(w)=floor(w*25-25/2); end
effects={'Group Effect','Condition Effect','Group-Cond Interaction'};
for e=2:3; for cs=1:7
P=squeeze(winsOf25(:,cs,:,e));  figure; hold on;
[x,y]=find(P<0.05); scatter(labels25ms(x),y,13,'filled','r'); xlim([0 2300]);
title([effects{e},'-',cases{cs}]); 
end;end

wins=[875 900; 0 75; 125 200; 200 275; 75 175; 875 949; 310 380; 400 600; 300 500; 550 575];
erpWins = zeros(10,7,160,3);
for cs=1:7; for e=1:3; for w=1:10; for ch=1:160; timeWin=ms2time([wins(w,1):wins(w,2)]);
erpWins(w,cs,ch,e)=mean(runningP(timeWin,cs,ch,e,1,1,1));
end; end; end; end
maplim=[0.8 1]
for e=1:3; for cs=1:7; fullfig; hold on; for w=1:10; P=squeeze(erpWins(w,cs,:,e));
subplot(2,5,w); topoplot(1-P,chanlocs,'maplimits', maplim,'intsquare','off'); cbar('vert',0,maplim); 
title([num2str(wins(w,1)),'-',num2str(wins(w,2))]);
sgtitle([effects{e},'-',cases{cs}]);end
end; end

wins=[875 900; 0 75; 125 200; 200 275; 75 175; 875 949; 310 380; 400 600; 300 500; 550 575];
erpWins = zeros(10,7,160,3);
for cs=1:7; for e=1:3; for w=1:10; for ch=1:160; timeWin=ms2time([wins(w,1):wins(w,2)]);
erpWins(w,cs,ch,e)=mean(runningP(timeWin,cs,ch,e,1,1,1));
end; end; end; end
maplim=[0.8 1]
for e=1:3; for cs=1:7; fullfig; hold on; for w=1:10; P=squeeze(erpWins(w,cs,:,e));
subplot(2,5,w); topoplot(1-P,chanlocs,'maplimits', maplim,'intsquare','off'); cbar('vert',0,maplim); 
title([num2str(wins(w,1)),'-',num2str(wins(w,2))]);
sgtitle([effects{e},'-',cases{cs}]);end
end; end


%CNV ANOVA (group cond
windows4stats = importWindows4stats("S:\pool\windows4stats.xlsx", "Sheet1", [2, 13])
for i=1:size(windows4stats,1)
    try
    ch = findChanNum(windows4stats.chan(i));
    win = windows4stats.w(i);timeWin=ms2time(str2num(win));
    name = windows4stats.item(i);
    cs1 = windows4stats.cs1(i); cs2=windows4stats.cs2(i);    
    
if cs2==0; P=squeeze(runningP(timeWin,cs1,ch,1:3,1,1,1)); else; P=squeeze(runningP(timeWin,cs1,ch,1:3,1,1,1))-squeeze(runningP(timeWin,cs2,ch,1:3,1,1,1));  end
P=mean(P);
fprintf(['Ps for win ' , num2str(min(str2num(win))),'-',num2str(max(str2num(win))),': ',num2str(round(P*100)),'\n']);

    %if cs2==0; V=squeeze(allERPs(:,timeWin,cs1,ch,[k1;k2])); else; V=squeeze(allERPs(:,timeWin,cs1,ch,[k1;k2]))-squeeze(allERPs(:,timeWin,cs2,ch,[k1;k2]));  end
    %V=squeeze(mean(V,2)); V=V'; V=reshape(V,4*size(V,1),1);
    %[p, tbl, stats]=anovan(V,{grpArr,cndArr},'model','interaction','display' ,'off');
	%fprintf(strcat(name,'Ps for win ' , num2str(min(str2num(win))),'-',num2str(max(str2num(win))),': ',num2str(round(p*100)'),'\n'))
    end
end

if p(3)<0.05;
text=[' Two way ANOVA at channel ',chanlocs(19).labels, ' showed a significant group-condition interaction (p=',num2str(p(3)),').']
end

    
    
    %runningPerp=zeros(38,7,13,4,2,3,5);
[reorderedChans, reorderedChanLabels,grInd] = groupChannels(chanlocs, 13);
chanGroups=unique(reorderedChanLabels,'stable'); 
%load('S:\pool\runningPerp.mat','runningPerp');
%For each of 50ms windows and 13 channel groups.
for tt=4:4; testType=testTypes{tt};
for ta=1:1; tail=tails{ta};
for al =2:2; alpha=alphas(al);
for cs=1:7;  fprintf(['starting ', cases{cs},'\n']);
for co=1:4
for w=1:38; timeWin=ms2time((w-1)*25:w*25-1);
for cg=1:13
    chans=reorderedChans(grInd==cg);
    V1=squeeze(allERPs(co,timeWin,cs,chans,k1)); V1=squeeze(mean(mean(V1,2),1));
    V2=squeeze(allERPs(co,timeWin,cs,chans,k2)); V2=squeeze(mean(mean(V2,2),1));
    V1mean=squeeze(allERPs(co,:,cs,chans,k1)); V1mean=squeeze(mean(mean(V1mean,2),1));
    if strcmp(testType,'ANOVA')
        V=squeeze(allERPs(:,timeWin,cs,chans,[k1;k2])); V=squeeze(mean(mean(V,2),3));V=V'; V=reshape(V,4*size(V,1),1);
        [p, tbl, stats]=anovan(V,{grpArr,cndArr},'model','interaction','display' ,'off'); 
        if co==1; p=p(1); elseif co==2; p=p(2); elseif co==3; p=p(3); elseif co==4; p=missing; end
    elseif strcmp(testType,'onesampleNT')
        [h,p,ci,stats] = ttest(V1(:),V1mean,'Alpha',alpha);
    elseif strcmp(testType,'ttest')
        [h,p,ci,stats] = ttest2(V1(:),V2(:),'Tail',tail,'Alpha',alpha);
    elseif strcmp(testType,'rmANOVA')
        V1=squeeze(allERPs(co,timeWin,cs,chans,k1));V1=squeeze(mean(V1,1));
        V2=squeeze(allERPs(co,timeWin,cs,chans,k2));V2=squeeze(mean(V2,1));
        p = anova_rm({V1' V2'},'off'); if co==1; p=p(2); elseif co==3; p=p(3); else; p=missing; end
    elseif strcmp(testType,'permutationTest')
        [r,stats] = permtest_corr(V1,V2,'alpha', alpha, 'nperm',10000,'tail',tail,'rows','complete','type','Pearson');
        p=stats.p;
    end
    runningPerp(w,cs,cg,co,al,ta,tt)=squeeze(p); 
end;end;end;end;end;end;end
%save('S:\pool\runningPerp.mat','runningP');