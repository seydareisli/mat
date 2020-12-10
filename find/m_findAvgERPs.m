% Author: Seydanur Tikir (seydanurtikir@gmail.com)

%calculate avg ERPs for subject  4D:(cond,time,case,chan)

%chan time trial --> cond time case chan 

function avgERPs = m_findAvgERPs(n_conds, cases,ERPs,events)

    addpath('S:/pool/functions/trigs.m');

    n_chans = size(ERPs,1);
    n_times = size(ERPs,2);
    n_trials = size(ERPs,3);
    
    avgERPs=zeros(n_conds,n_times,length(cases),n_chans); 
    for ch=1:n_chans;  for cs=1:length(cases); trig = trigs(cases{cs});
    for co=1:n_conds; data=ERPs(ch,:,find(ismember(events,trig(co,:))));  
    avgERPs(co,:,cs,ch) = mean(data,3); end;end;end

end