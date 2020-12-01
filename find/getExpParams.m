

if strcmp(expName,'Closure');
    
    cd('P:\Analyses\Matlab'); addpath(pwd); 
    
    cases = {'L1';'L2'; 'L3';'L4';'L5';'L6';'L7';'L8';'P1';'P2';'P3';'P4';'P5';'P6'; 'P7';'P8'};
    trigger_codes = {{1};{2};{3};{4};{5};{6};{7};{8};{91};{92};{93};{94};{95};{96};{97};{98}};
    stimuliTrigArr = {1,2,3,4,5,6,7,8,91,92,93,94,95,96,97,98};
    stimuliTrigMat = [1,2,3,4,5,6,7,8,91,92,93,94,95,96,97,98];

    trigger_names = {'L1';'L2'; 'L3';'L4';'L5';'L6'; 'L7';'L8';'P1';'P2'; 'P3';'P4';'P5';'P6'; 'P7';'P8'};
    grps = {'Adult'};
    rejTypes = {'rejNoise50Br5','noICrej','rejNoise30','selBrain30','rejEye70'};
    drive ='P:\';
    epochTime = [-.10 .50]; BaselineTime = [-99 0];
    
    trialRejThrs= [150] ; %'mickRej'
    refTypes ={'refAll'};% {'refAll','e16', 'e17', 'e19', 'a12', 'a10', 'a8', 'a25', 'a23,' 'a21', 'b9' ,'b7', 'b5', 'b18' ,'b16', 'b19'};% 144 145 147 12 10 8 25 23 21 41 39 37 50 48 51
    rejTypes = {'rejNoise50Br5','noICrej','rejNoise30','selBrain30','rejEye70'};
tinyEEG128 = pop_loadset('tinyEEG128.set');

    epochLen = 600; preStimTime = 150;
    donorlocs = tinyEEG128.chanlocs;
    
    




end


end