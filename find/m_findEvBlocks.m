% Author: Seydanur Tikir (seydanurtikir@gmail.com)

   function [evBlocks evConds]= m_findEvBlocks(EEG,stimuliTrigMat,  boundaryCodes)
    events = []; for e = 1:length(EEG.event); events = [events str2num(EEG.event(e).type)]; end 
    events = events(find(ismember(events,[stimuliTrigMat boundaryCodes]))); %6636 (temporarily bigger size)
    prev=1; block=1; evConds=zeros(1,length(events)); evBlocks=zeros(1,length(events));
    
    for e=1:length(events)
        if ismember(events(e),[101,102,103,104])
        evBlocks(prev:e)=zeros(1,e-prev+1)+block; block=block+1; 
        evConds(prev:e)=zeros(1,e-prev+1)+events(e)-100; prev=e+1; 
    end
    end
    ind=find(ismember(events,[101 102 103 104])); 
    events(ind)=[]; evConds(ind)=[]; evBlocks(ind)=[]; %event size back to 6576 (mathing data size)
   end