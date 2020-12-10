% Author: Seydanur Tikir (seydanurtikir@gmail.com)

% Running ANOVA
% Author: Seydanur Tikir  Contact: seydanurtikir@gmail.com
% This is an early version of the code, last updated on 07/02/2020)
% come back to check updates

% The script can be used to
%   1) run a 2-way ANOVA for each channel and time point (+conditions, optionally)
%   2) check for consecutive significances
%   3) plots results 

num_chans = 160;
alpha=0.01; % or use 0.05

num_conds=4;
conditions={'condition 1','condition 2','condition 3','condition 4'};

loadERPs; %loading my allERPs your ERP matrix 
k1=find(subGrps=="Neurotypical"); k2=find(subGrps=="Autism"); n=length(subGrps);
grpArr =[subGrps; subGrps; subGrps; subGrps]; 
cndArr=[zeros(n,1)+1;zeros(n,1)+2;zeros(n,1)+3;zeros(n,1)+4];

% Part 1. CALCULATING
P_anova=zeros(122,7,160,n_conds,3);
for co=1:num_conds;  fprintf(['starting ', conditions{co},'\n']);
for ch=1:160
for tp=1:122
    V=squeeze(allERPs(tp,ch,co,[k1;k2])); V=V'; V=reshape(V,4*size(V,1),1);
    [p, tbl, stats]=anovan(V,{grpArr,cndArr},'model','interaction','display' ,'off'); 
    for e=1:3; P_anova(tp,co,ch,e)=squeeze(p(e)); end % e defines the effect. 1) Group effect 2) Condition effecct 3) Group Condition Interaction
end
end
end

% Part 2. PLOTTING
%Plot Modes:
%1) you want subplots be your conditions to compare
%2) You want subplots be different effects in your ANOVA results 

figPath='S:\Figures\';
load('S:\chanlocs.mat');
load('S:\pool\runningP.mat');

numConsecTimes=3; numConsecChans=3;
[reorderedChans, reorderedChanLabels,grInd] = groupChannels(chanlocs, 13);

tt=1; cs=1; numSubPlots=3;
effects={'Group Effect','Condition Effect','Group-Cond Interaction'};

%Plot Mode 2 
for co=1:num_conds; fullfig; hold on; 
for e=1:3; subplot(1,numSubPlots,e);
    P = squeeze(runningP(:,:,co,tt))'; % P should be nChans x nTimePts 
    P = findConsecutiveSignificances2(P,alpha,numConsecTimes,numConsecChans,chanlocs);
    im=image(time2ms(1:122),1:160,P,'CDataMapping','scaled');  
    colormap(flipud(parula)); axis xy; 
    yticks([1:4:160]); yticklabels(reorderedChanLabels(1:4:160)); ylabel('channels');
    xticks(0:100:900);xtickangle(90);caxis([0 0.1]); xlabel('ms'); 
    title(effects{e});
end
    runname=[testTypes{tt},'-',cases{cs},'-p0',num2str(alpha*100),'-',tail,'Tailed-','codeV2-',num2str(numConsecTimes),'+timePts-',num2str(numConsecChans),'+channels'];
    sgtitle(runname); 
    print('-dpng','-r500',[figPath,'Running', runname, '.png']);
    close;
end



  