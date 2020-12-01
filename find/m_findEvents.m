function [EEGevents,inds]=m_findEvents(EEG,stimuliTrigMat)
EEGevents=[]; inds=[];
for e=1:length(EEG.event); 
    event=str2num(EEG.event(e).type);
    if ismember(event,stimuliTrigMat); 
        EEGevents=[EEGevents event]; 
        inds=[inds e]; 
end; end
end