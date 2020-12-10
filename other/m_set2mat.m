% Author: Seydanur Tikir (seydanurtikir@gmail.com)

%{'RejectedNoise50BrainSafety5'  'RejectedNoise80' 'SelectedBrain20' 'BrainGreaterThanNoise' 'SelectedBrain50'}
%evCOnds is calculated accurately only when blokEndEvents-100 gives it
%away.

function [ERPs,preStim,events,evConds,evBlocks] = m_set2mat(EEG,stimuliTrigArr,stimuliTrigMat,blockEndEvents,epochLen,preStimTime)

    %epoch
   % EEGpre = pop_epochNoSelect(EEG,stimuliTrigArr,[-1*preStimTime/1000 0]); 
    %EEGep = pop_epochNoSelect(EEG,stimuliTrigArr,[0 epochLen/1000]); 
    EEGep = pop_epoch(EEG,stimuliTrigArr,[0 epochLen/1000]); 
    EEGpre = pop_epoch(EEG,stimuliTrigArr,[-1*preStimTime/1000 0]); 
    preStim = EEGpre.data; t_preStim=EEGpre.times; %data size 6576
    ERPs = EEGep.data; t=EEGep.times;

  % create events, evConds, evBlocks
    events = []; for e = 1:length(EEG.event); events = [events str2num(EEG.event(e).type)]; end 
    events = events(find(ismember(events,[stimuliTrigMat blockEndEvents]))); %6636 (temporarily bigger size)
    prev=1; block=1; evConds=zeros(1,length(events)); evBlocks=zeros(1,length(events)); 
    for e=1:length(events)
        if ismember(events(e),blockEndEvents)
        evBlocks(prev:e)=zeros(1,e-prev+1)+block; block=block+1; 
        evConds(prev:e)=zeros(1,e-prev+1)+events(e)-100; prev=e+1; 
    end
    end
    ind=find(ismember(events,blockEndEvents)); 
    events(ind)=[]; evConds(ind)=[]; evBlocks(ind)=[]; %event size back to 6576 (mathing data size)

    % set to initial mat

       if  std(size(ERPs,3),size(evBlocks,2))~=0; return; end
end
    
 
