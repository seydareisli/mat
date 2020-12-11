% Running ANOVA
% The script can be used to
%   1) run a 2-way ANOVA for each channel and time point 
%   2) check for consecutive significances
%   3) plots results (i.e.statistcal cluster plot)

% This version is adjusted for MOBI project at CNLx
% Author/Contact: Seydanur Tikir seydanurtikir@gmail.com

% keep in mind that you first line up all conditions for one group, and  then move to the other group

clear all
vol='/Volumes/users/CNL Lab/';
exp={'Walk&Stand'};
loadPath=[vol,'Seyda_douwe_temp'];
load([loadPath,filesep,'64ChStructure.mat']); 
chanlocs=Ch64; clear Ch64
num_chans = size(chanlocs,2);
conditionNames={'standing','walkingNoFlow','walkingFlow'}; 
conds_Hit= {'data_S_Hit_NF_T','data_W_Hit_NF_T', 'data_W_Hit_0_T' };
conds_CR= {'data_S_CR_NF_T','data_W_CR_NF_T', 'data_W_CR_0_T' };
conds_FA= {'data_S_FA_NF_T','data_W_FA_NF_T', 'data_W_FA_0_T' };
cases={'Hit','CR','FA','Hit-CR'};
num_conds=length(conditions);
groups={'ASD','TD'};
num_grps=length(groups);
effects={'Group Effect','Condition Effect','Group-Cond Interaction'};

cs=1;
%% Prepare data and input arrays 


data=struct;
data(1).data=[];
cndArr=[];
grpArr=[];

for g=1:num_grps
    
    data_gr=struct;
    
    for cs=1:3
        conditions = eval(['conds_',cases{cs}]);
        load([loadPath,filesep,groups{g},'_',exp{1},'.mat']);
        num_grpSubj= size(eval(conditions{1}),3);
        dat=cat(3, eval(conditions{1}), eval(conditions{2}), eval(conditions{3}));
        data(cs).name=cases{cs};
        data(cs).data=cat(3,data(cs).data,dat);
    end
    
    cndArr_gr=zeros(num_grpSubj*num_conds,1);
    for c=1:num_conds
        cndArr_gr(num_grpSubj*(c-1)+1:num_grpSubj*c)=zeros(num_grpSubj,1)+c;
    end
    grpArr_gr=zeros(num_grpSubj*num_conds,1)+g;
    
    grpArr=[grpArr; grpArr_gr];
    cndArr=[cndArr; cndArr_gr];
    
end

%Hit - FA
data(4).data=data(1).data-data(2).data;
data(4).name=cases{4};

%% Run ANOVA
% As we now have data  grpArr cndArr, we are ready to run ANOVA in loop:
% (This may take a few minutes)

[num_chans,num_timePts,~]= size(data(1).data);
P_anova=zeros(num_timePts,num_chans,4,3); %a placeholder for recording upcoming results
for cs=1:4
for ch=1:num_chans
for tp=1:num_timePts
    V=squeeze(data(cs).data(ch,tp,:));
    [p, tbl, stats]=anovan(V,{grpArr,cndArr},'model','interaction','display' ,'off'); 
    P_anova(tp,ch,cs,1)=p(1);  P_anova(tp,ch,cs,2)=p(2);  P_anova(tp,ch,cs,3)=p(3);  
end
end
end

%save([loadPath,filesep,'P_anova.mat'],'P_anova');
%load([loadPath,filesep,'P_anova.mat'],'P_anova');

% Part 2. PLOTTING
%Plot Modes:
%1) you want subplots be your conditions to compare
%2) You want subplots be different effects in your ANOVA results 

%% PLOT
cd(loadPath);
figPath=loadPath;
numConsecTimes=2; numConsecChans=2; % at least 3 of the 8 surrounding channels 
numSubPlots=num_conds;
time = (-100:1000/512:799);
[reorderedChans, reorderedChanLabels,grInd] = groupChannels(chanlocs, 10);
close all

% PLOT MODE 1:one figure 
e=3;
for cs=1:4
    figure; 
    P = squeeze(P_anova(:,reorderedChans,cs,e))'; % P should be nChans x nTimePts 
    P = findConsecutiveSignificances2(P,0.05,numConsecTimes,numConsecChans,chanlocs);
    im=image(time,1:num_chans,P,'CDataMapping','scaled');  
    colormap(flipud(parula)); axis xy; 
    yticks([1:2:num_chans]); yticklabels(reorderedChanLabels(1:2:num_chans)); ylabel('channels');
    xticks(-100:50:800); xtickangle(90);
    caxis([0 0.1]); xlabel('ms'); 
    runname=['ANOVA ',cases{cs},' ',effects{e},' (Controlled for ',num2str(numConsecTimes),'+timePts-',num2str(numConsecChans),'+channels)'];
    sgtitle(runname); 
    print('-dpng','-r500',[figPath,filesep,'Running', runname, '.png']);
    close;
end

% PLOT MODE 2:subplots show three effects
for cs=1:4
    figure; 
    for e=1:3
    subplot(1,3,e);
        P = squeeze(P_anova(:,reorderedChans,cs,e))'; % P should be nChans x nTimePts 
        P = findConsecutiveSignificances2(P,0.05,numConsecTimes,numConsecChans,chanlocs);
        im=image(time,1:num_chans,P,'CDataMapping','scaled');  
        colormap(flipud(parula)); axis xy; 
        yticks([1:2:num_chans]); yticklabels(reorderedChanLabels(1:2:num_chans)); ylabel('channels');
        xticks(-100:50:800); xtickangle(90);
        caxis([0 0.1]); xlabel('ms'); 
        title(cases{cs});
    end
    runname=['ANOVA ',cases{cs},' (Controlled for ',num2str(numConsecTimes),'+timePts-',num2str(numConsecChans),'+channels)'];
    sgtitle(runname); 
    print('-dpng','-r500',[figPath,filesep,'Running', runname, '.png']);
    close;
end
  