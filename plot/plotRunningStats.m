% Author: Seydanur Tikir (seydanurtikir@gmail.com)

addpath('S:\pool\');%addpath('S:\eeglab');eeglab;close
figPath='X:\Analyses\PaperPosterFigures\';
% Note there are 2 Versions of the code findConsecutiveSignificances2 and findConsecutiveSignificances
numConsecTimes=3; numConsecChans=3;
[reorderedChans, reorderedChanLabels,grInd] = groupChannels(chanlocs, 13);
%load('S:\pool\runningP.mat','runningP');
load('S:\pool\chanlocs.mat');
cd('S:\pool\');
for tt=8:8; if tt==1; numSubPlots=3; else; numSubPlots=4; end
for al=1:1; alpha=alphas(al); 
for ta=1:1; tail=tails{ta};
for cs=1:7; fullfig; hold on; %fullfig('Border',[25 5]);
for co=1:numSubPlots; subplot(1,numSubPlots,co);
    P = squeeze(runningP(:,cs,:,co,al,ta,tt))'; %P(reorderedChans,:);
    P = findConsecutiveSignificances2(P,alpha,numConsecTimes,numConsecChans,chanlocs);
    f=surf(time2ms(1:122),1:160,P); 
    set(f,'EdgeColor','none'); ylabel('channels'); xlabel('ms'); set(gcf,'Renderer','zbuffer');view(2);axis tight  ;grid off; box on;colorbar; 
    colormap(flipud(parula)); yticks([1:2:160]); yticklabels(reorderedChanLabels(1:2:160)); 
    xticks(0:100:900);xtickangle(90);caxis([0 0.1]);
    if tt==1; if co==1; title('Group Effect'); elseif co==2; title('Condition Effect'); elseif co==3; title('Group-Cond Interaction'); end; end
    if tt==2 || tt==8 || tt==9; title(['Condition ', num2str(co)]); end
    if tt==6; if co==1; title('NT C1 vs C3'); elseif co==2; title('NT C2 vs C4'); elseif co==3; title('ASD C1 vs C3'); elseif co==4; title('ASD C2 vs C4'); end; end
end;runname=[testTypes{tt},'-',cases{cs},'-p0',num2str(alpha*100),'-',tail,'Tailed-','codeV2-',num2str(numConsecTimes),'+timePts-',num2str(numConsecChans),'+channels'];
    if tt==8||tt==9; runname=[testTypes{tt},'-',cases{compItemsMat(cs,1)},'VS',cases{compItemsMat(cs,2)},'-p0',num2str(alpha*100),'-',tail,'Tailed-','codeV2-',num2str(numConsecTimes),'+timePts-',num2str(numConsecChans),'+channels']; end
    sgtitle(runname); print('-dpng','-r500',[figPath,'Running', runname, '.png']);close;
end
end
end
end


%plot scalp maps of channel groups - calculate 
[reorderedChans, reorderedChanLabels,grInd] = groupChannels(chanlocs, 13);
chanGroups=unique(reorderedChanLabels,'stable'); 
%signTimes={};
for tt=7:7; if tt==1; numSubPlots=3; else; numSubPlots=4; end
for al=1:1; alpha=alphas(al); 
for ta=1:1; tail=tails{ta};
for cs=1:7
for co=1:numSubPlots
    P = squeeze(runningP(:,cs,:,co,al,ta,tt))'; %P(reorderedChans,:);
    P = findConsecutiveSignificances(P,alpha,numConsecTimes,numConsecChans,chanlocs);
    for cg=1:13; chans=reorderedChans(grInd==cg); Pcg= mean(P(chans,:),1); 
        signTimes{cs,co,tt,cg}= find(Pcg<0.05); 
    end
end; end; end; end; end

for cs=1:7; compItemsLab{cs}=[cases{compItemsMat(cs,1)},'VS',cases{compItemsMat(cs,2)}]; end

%plot scalp maps of channel groups - plot 
cgSubplt= [ 3 7 8 9 11 12 13 14 15 18 17 19 23];   %cgPos=[0 2; -1 1; 0 1; 1 1; -2 0; -1 0; 0 0; 1 0; 2 0; -1 -1; 0 -1; 1 -1; 0 -2];  
for tt=7:7
for co=1:4
fullfig; hold on; 
for cs=1:7
for cg=1:13; subplot(5,5,cgSubplt(cg)); hold on;
    x1=[]; x2=[]; x= signTimes{cs,co,tt,cg}; x1=[x1 x]; if isempty(x); continue; else; x=findNtypeTimeRanges(x); x2=[x2 x]; end
    fprintf('%d-',length(x1));
    scatter(time2ms(x1),zeros(1,length(x1))+cs,20,getColors('turq8shades',3)); xlim([0 950]); ylim([0 8]);  %hist(time2ms(x1)); 
    title(chanGroups{cg}); yticks([1:7]); yticklabels(cases); if tt==8||tt==9; yticklabels(compItemsLab); end
end
if tt==1; if co==1; runname=('ANOVA Group Effect'); elseif co==2; runname=('ANOVA Condition Effect'); elseif co==3; runname=('ANOVA Group-Cond Interaction'); end; end
if tt==2 || tt==8 || tt==9; runname=(['T-test for NT vs ASD in Condition ', num2str(co)]); end
if tt==6; if co==1; runname=('T-test for NT C1 vs C3'); elseif co==2; runname=('T-test for NT C2 vs C4'); elseif co==3; runname=('T-test for ASD C1 vs C3'); elseif co==4; runname=('T-test for ASD C2 vs C4'); end; end
if tt==5 || tt==7 || tt==8||tt==9; runname=([testTypes{tt},'- co',num2str(co)]);end
end
sgtitle(runname);print('-dpng','-r500',[figPath,'ScalpStats-', runname, '.png']);close;
end 
end




for cs=1:7; figure; hold on; %fullfig('Border',[25 5]);
for co=1:numSubPlots; subplot(1,numSubPlots,co);
    title(cases{cs}); xlim([-4 4]); ylim([-4 4]); hold on; 
    st=signTimes{cs,co,cg}; if isempty(st); continue; end; if st(1)==1; st(1)=[]; end
text(cgPos(cg,1),cgPos(cg,2),myStr);


    



signTimes
chanInds    =  [104 119 100 81       137 132 1 71 64           19 158  44   23 ];
topoplot([],EEG160.chanlocs(ch), 'style', 'blank','electcolor',[col col col],'emarkersize',11);title('Significant Group Effect','FontSize',13);

cg=1; cs=3; co=1; signTimes{cs,co,cg}

for s=1:length(signTimes)-1; if signTimes(s+1)-signTimes(s)==1; end; end


%runningPerp / summed version (not checking ConsecutiveSignificances)
labels25ms=zeros(1,38);for w=1:38; labels25ms(w)=floor(w*25-25/2); end
for tt=4:4; if tt==1; numSubPlots=3; else; numSubPlots=4; end
for al=2:2; alpha=alphas(al); 
for ta=1:1; tail=tails{ta};
for cs=1:7;fullfig; hold on; %fullfig('Border',[25 5]);
for co=1:numSubPlots; subplot(1,numSubPlots,co);
    P = squeeze(runningPerp(:,cs,:,co,al,ta,tt)); f=surf(1:13,labels25ms',P); 
    set(f,'EdgeColor','none'); xlabel('channels'); ylabel('ms'); set(gcf,'Renderer','zbuffer');view(2);axis tight  ;grid off; box on;colorbar; 
    colormap(flipud(parula)); yticks(0:25:925);xtickangle(90);caxis([0 0.1]); xticks(1:13); xticklabels(unique(reorderedChanLabels,'stable')); 
    if tt==1; if co==1; title('Group Effect'); elseif co==2; title('Condition Effect'); elseif co==3; title('Group-Cond Interaction'); end; end
    if tt~=1; title(['Condition ', num2str(co)]); end
end; runname=['sum-',testTypes{tt},'-',cases{cs},'-p0',num2str(alpha*100),'-',tail,'Tailed']; sgtitle(runname); 
    print('-dpng','-r500',[figPath,'Running', runname, '.png']);close;
end
end
end
end







addpath('S:/eeglab');eeglab;close;
EEG160 = pop_loadset('EEG160-do-not-delete.set');
%TOPOPLOT FOR SIGNIFICANCE
tt=2; ta=3; tail=tails{ta}; al=2; alpha=alphas(al); numConsecTimes=2; 
figure; hold on;
for cs=3:3; fullfig; hold on; for co=1:3; subplot(1,3,co);
    p_val = squeeze(runningP(:,cs,:,co,al,ta,tt))'; %160x122
    P=p_val; %P = findConsecutiveSignificances(p_val,alpha,numConsecTimes);
    P_avgChanP3=mean(P(:,ms2time(250:400)),2);
for ch=1:160; col=P_avgChanP3(ch); 
    topoplot([],EEG160.chanlocs(ch), 'style', 'blank','electcolor',[col col col],'emarkersize',11);title('Significant Group Effect','FontSize',13);
end; end; end 

lasting = numConsecTimes*(time2ms(2)-time2ms(1));  
%['T-tests for NT vs ASD for co',(effects lasting ',num2str(lasting), ' ms+)']);

cs=3;co=3;
P = squeeze(runningP(:,cs,:,co,al,ta,tt))'; %160x122
    P= findConsecutiveSignificances(P,alpha,numConsecTimes,chanlocs,9)

runningPavgChan=mean(runningP, 3);
    p_val = squeeze(runningP(:,cs,:,co,al,ta,tt))'; %160x122

fullfig; 
for cs=1:3
P=plotRunningStatistics(p_val,t_val,alpha,numConsecTimes,labels,epochLen,numChans,figname);
Psum=sum(P);
subplot(3,1,cs);plot(time,sumPs(cs,:)*-1); 
title(cases{cs});
%ylim([-1*max(max(sumPs)) -1*min(min(sumPs)) ]);
ylim([-2.25 -0.25]);
%ylim([-12 0]);
end
sgtitle(['total P value of all channels', ' (p<',num2str(alphalevel), ') (effects lasting ',num2str(realLasting), ' ms+)']);


%thr=30;timesDiffered=(sum(t_val,1)>thr);figure; scatter(1:epochLen,timesDiffered-1+thr,11,'filled'); ylim([thr-0.5 thr+0.5]);
