% Author: Seydanur Tikir (seydanurtikir@gmail.com)

drive='\\data.einsteinmed.org\Users\CNL Lab\Data_new\SPLT\';
%drive='/Volumes/users/Data_new/SPLT/'
loadPath=[drive,'\Analyses\ICAweightsApplied\']; 
grps={'Neurotypical','Autism'};
rejTypes={'RejectedNoise50BrainSafety5'  'RejectedNoise80' 'SelectedBrain20' 'BrainGreaterThanNoise' 'SelectedBrain50'};
addpath('S:/pool');
addpath('S:/pool/functions');
  %addpath('P:\Analyses\Matlab')';
  
rejectionStats=zeros(50,6);
subj=0;
for i = 1:2
    IDs =dir([loadPath,grps{i},'\1*']);
    for j=1:length(IDs)
    fprintf(['Starting on ',IDs(j).name,'\n']);
    for r=1:length(rejTypes)
        rejType=rejTypes{r};
        
     %1. load EEG set (IC-rejected)
    EEG = pop_loadset([loadPath,grps{i},filesep,IDs(j).name,filesep,rejType,filesep,IDs(j).name,'.set']);
    EEG = pop_loadset([loadPath,grps{i},filesep,IDs(j).name,filesep,IDs(j).name,'.set']);

    %2. Remove any remaning bad channels
    [EEG, badChans] = pop_rejchan(EEG, 'elec',[1:EEG.nbchan],'threshold',3.5,'norm','on','measure','spec','freqrange',[0.1 50] ); % 

    %3. interpolate 
    EEG = interpolate160(EEG,'S:/pool/');
    
    end
    end
end
