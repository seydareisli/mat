  
  function [ERPs,preStim,events,evConds,evBlocks] = m_rejectIncorrects(trigCodes2remove,ERPs,preStim,events,evConds,evBlocks)

    events2remove=find(ismember(events,trigCodes2remove));
    
    if  size(events2remove,2)~=0
        
        if events2remove(1)==1; events2remove(1)=[]; end
        
        events(events2remove-1)=[]; 
        ERPs(:,:,events2remove-1)=[]; 
        preStim(:,:,events2remove-1)=[];
        evConds(events2remove-1)=[]; 
        evBlocks(events2remove-1)=[];
    end