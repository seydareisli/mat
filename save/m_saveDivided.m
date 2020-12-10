% Author: Seydanur Tikir (seydanurtikir@gmail.com)

%Save divided

function m_saveDivided(dividedSavePath,ERPs,events,cases,n_conds,base50,base100)
    addpath('S:\pool\functions\trig.m');
    for cs=1:length(cases); trig = trigs(cases{cs}); 
    for co=1:n_conds; trials = find(ismember(events,trig(co,:)));
        data=ERPs(:,:,trials); baseline50=base50(:,trials); baseline100=base100(:,trials);
        save([dividedSavePath,cases{cs},'-C',num2str(co),'.mat'],'data','baseline50','baseline100');
        clear 'data' 'baseline50' 'baseline100'
        fprintf('Subject data was saved\n');

    end
    end
end