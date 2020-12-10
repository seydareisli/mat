% Author: Seydanur Tikir (seydanurtikir@gmail.com)

 %j=5 11106 error
clc 
clear all

load_path_ica='X:\Analyses\ICAafterChannelSpectraCleaning\';
load_path_newfilt='X:\Analyses\01Filtered001Hz\';
save_path='X:\Analyses\ICAweightsApplied\';
n_conds=4; 
epochLen=950;
stimuliTrigArr = {11, 14, 21, 24, 61, 64, 31, 34, 71, 74 41, 44, 81, 84, 12, 15, 22, 25, 62, 65, 32, 35, 72, 75, 42, 45, 82, 85, 13, 16, 23, 26, 33, 36, 43, 46, 92, 93, 94, 50, 60, 70, 80, 59, 69, 79, 89, 57, 67, 77, 87, 53, 56, 63, 66, 73, 76, 83, 86, 58, 68, 78, 88, 1, 2, 3, 4, 5, 6, 7, 8};
stimuliTrigMat = [11, 14, 21, 24, 61, 64, 31, 34, 71, 74 41, 44, 81, 84, 12, 15, 22, 25, 62, 65, 32, 35, 72, 75, 42, 45, 82, 85, 13, 16, 23, 26, 33, 36, 43, 46, 92, 93, 94, 50, 60, 70, 80, 59, 69, 79, 89, 57, 67, 77, 87, 53, 56, 63, 66, 73, 76, 83, 86, 58, 68, 78, 88, 1, 2, 3, 4, 5, 6, 7, 8];
group = {'Neurotypical','Autism'};
addpath('S:\eeglab'); eeglab; close;
epochLen = 950; preStimTime = 150;

for i = 2:2%numel(group), fprintf('Group: %s\n',group{i})
        id = dir([load_path_newfilt,group{i},'\1*']);
        
    for j = 1:size(id,1)
        try
        subject_load_path_newfilt = [load_path_newfilt,group{i},filesep,id(j).name];
        subject_load_path_ica = [load_path_ica,group{i}, filesep, id(j).name, filesep];        
        subject_save_path = [save_path,filesep,group{i},filesep,id(j).name]; mkdir(subject_save_path);
       
        isThisDone = dir([subject_save_path, filesep, id(j).name,'.set']);
        if length(isThisDone)==1; continue; end 
        
        EEGmerged=mergeEEGsetsInFolder(subject_load_path_newfilt);
        EEGmerged = pop_resample( EEGmerged, 128);
        EEG4ica= pop_loadset([subject_load_path_ica,id(j).name,'.set']);
        EEGep1 = pop_epochNoSelect(EEG4ica,stimuliTrigArr,[0 epochLen/1000]); 
        events1=m_findEvents(EEG4ica,stimuliTrigMat);        
        EEGep2 = pop_epochNoSelect(EEGmerged,stimuliTrigArr,[0 epochLen/1000]); 
        events2=m_findEvents(EEGmerged,stimuliTrigMat);
         [evBlocks, evConds] =m_findEvBlocks(EEG4ica, stimuliTrigMat, [101 102 103 104]);
        clear EEG4ica EEGmerged
        

        del=[]; x=0; d=0;match=[];
        for e=1:length(events1)-5
            e1=events2(e+d:e+d+5); e2=events1(e:e+5);
            if e1~=e2;d=d+1;e1=events2(e+d:e+d+5); e2=events1(e:e+5);
                if e1==e2;fprintf("shifting one helped at e %d!\n",e); del=[del e];
                end
            end        
        end
        if length(del)==length(events2)-length(events1);
            fprintf("del was calculated correctly\n");
            events2(del)=[];
            indNomatch=find(events2~=events1);
            if length(indNomatch)<60; delBoth=indNomatch;
                fprintf("you need to delete %d indices from both EEGs\n",length(indNomatch));
            else fprintf("problems");
            end
        end

        EEGep2 = pop_rejepoch( EEGep2, del, 0);
        EEGep1 = pop_rejepoch( EEGep1, delBoth, 0);
        EEGep2= pop_rejepoch( EEGep2, delBoth, 0);
        if EEGep1.trials ~= EEGep2.trials; break; end
        events1(delBoth)=[]; events2(delBoth)=[]; evBlocks(delBoth)=[]; evConds(delBoth)=[]; 
        if sum(events1~=events2)>0; break; else; events=events1; end
        clear events1 events2

        %math nchan 
        nchan=length(EEGep1.chanlocs); 
        chans2keep={};for ch=1:nchan; chans2keep{ch}=EEGep1.chanlocs(ch).labels; end
        EEGep2 = pop_select(EEGep2,'channel',chans2keep);
        EEGep2.chanlocs=EEGep1.chanlocs;
        
        %Copy ICA info
        EEGep2.icaact = EEGep1.icaact;
        EEGep2.icawinv = EEGep1.icawinv;
        EEGep2.icasphere = EEGep1.icasphere;
        EEGep2.icaweights = EEGep1.icaweights;
        EEGep2.icachansind = EEGep1.icachansind;
        
        EEG=EEGep2; clear EEG4ica EEGmerged EEGep1 EEGep2
        iclabelSelectSave(EEG,id(j).name,subject_save_path)
        pop_saveset( EEG, id(j).name, subject_save_path);
        
        end
        
       
    end
end

