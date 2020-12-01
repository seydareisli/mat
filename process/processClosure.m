expName='Closure'; getExpParams;
subNo='sub1';
trials2include=csvread(['S:\PerceptualClosure\Analyses\trials2include\trials2include',subNo,'.csv']);
ERPs=ERPs(:,:,trials2include); events=events(trials2include); 
preStimTime=300;

[ERPs,preStim,events] = m_set2mat(EEG,stimuliTrigArr,stimuliTrigMat,blockEndEvents,epochLen,preStimTime);

