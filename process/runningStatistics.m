% Author: Seydanur Tikir (seydanurtikir@gmail.com)

clear 
cd('A:\Matlab');
alpha=0.05;
tail='both'; % or use 'right' 'left'
group = {'ASD Child', 'TD Child'};

runningTtestT = zeros(64,308);
runningTtestP = zeros(64,308);


c=4;
i=1;
load(['3D ERPs for all ',group{i}, ' ', 'Cond', num2str(c), ' subjects.mat'],'ERPallSubjects'); 
ASD=ERPallSubjects;
i=2;
load(['3D ERPs for all ',group{i}, ' ', 'Cond', num2str(c), ' subjects.mat'],'ERPallSubjects'); 
NT=ERPallSubjects;
    
    
% Run t-test between ASD and NT in loops for each channel & each time point
for ch=1:64 %for each channel
    for tp=1:308 %for each time point
       [h,p,ci,stats] = ttest2(ASD(ch,tp,:),NT(ch,tp,:),'Tail',tail,'Alpha',alpha);
        runningTtestT(ch,tp)=squeeze(stats.tstat);
        runningTtestP(ch,tp)=squeeze(p);  
    end
end

%how many consec time points you want to correct the results for?
load('t');
lasting = 1*(t(2)-t(1)); 
numconsec=round(lasting/(t(2)-t(1))); 
realLasting=round((t(2)-t(1))*numconsec);

% get channel labels
load('chanlocs64'); chanlocs=chanlocs64;
numChans=64; labels={}; 
for c=1:numChans; labels{c}=chanlocs(c).labels; end

figure;
epochLen=time2ms(length(t))-time2ms(1);

p_val=runningTtestP;
t_val=runningTtestT;

figname=['Cluster Plot for NT vs ASD', ' (p<',num2str(alpha), ') (effects lasting ',num2str(realLasting), ' ms+)'];
plotRunningTtest(p_val,t_val,alpha,numconsec,t,labels,epochLen,numChans,figname);
sgtitle(figname);

