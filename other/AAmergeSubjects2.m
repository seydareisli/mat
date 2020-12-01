% Merge all subjects. (loadingFrom & savingTo "epochedSet" folder) 
% bu kodun sonunda dusundugum diger dataset avg metodlari var

clear;  clc; rejName='RejectedNoise50BrainSafety5'; paths; load_path=path02c; 
save_path=[path_Data_SPLT,'mergedAfterICArej']; mkdir(save_path); 
eeglab;
trigType='correct'; itemsTimelocked=[-4 1]; triggerDefinitions; RefChans=[];
load_path=[path_Data_SPLT,'epochedSets',filesep,getProcessName(RefChans,'noShowName', trigType, itemsTimelocked, 'short')]; 
%load_path=[path_Data_SPLT,'epochedSets',filesep'0323 5-items-long-nobase timeLocked correct[-4 1] RefAll'];
load_path=['X:\Analyses\epochedSets\NoBaseday0820 showing[-4 1]stimuli from correctonset baselineStim[short] RefAll'];
save_path=load_path;

temp_set=[]; 
for i = 1:numel(group), fprintf('Group: %s\n',group{i})
   for n = 1:length(trigger_names)
       trigger_name = trigger_names{n};
       files=dir([load_path,filesep,group{i},'*',trigger_name,'*','.set']);
  
       for k=1:length(files)
           EEG = pop_loadset(files(k).name,load_path);         
            if k==1 
                temp_set= EEG;
            else 
                session_set = EEG;
                temp_set = pop_mergeset( temp_set,session_set,1);
            end
            k 
        end
        EEG=temp_set; groupEEG=EEG;
        EEG.setmame = ['Merged-',group{i},'-',trigger_name]; EEG.filemame=EEG.setmame;
        pop_saveset( EEG,EEG.filemame,save_path);     
        clear temp_set session_set
   end
end

%subject_trig_filename = [subject_name,'--',trigger_name, '--', num2str(EEG.trials) 'trials'];


% ALL OTHER POTENTIAL DATASET AVERAGING METHODS

% pop_compareerps	Compare the (ERP) averages of two datasets.   
% pop_comperp	Compute average ERP  of multiple datasets
%pop_compareerps( ALLEEG, datasetlist, chansubset, title);
%pop_compareerps(ALLEEG(1,1), ALLEEG(1,2));
%pop_envtopo( EEG, 'key', 'val', ...); % butterfly plot. Plot envelope of an averaged EEG epoch, plus scalp maps
%eeg_multieegplot( data,trialrej, elecrej, 'key1', value, 'key2', value ... );


%ALLEEG(i).filename;
%Finally understood ALLEEG! It is alwaysautomatically added by eeglab  
% eeg_store() - store  EEG dataset(s)in the ALLEEG variable 
%eeg_retrieve	Retrieve an EEG dataset from the variable containing all datasets (standard:ALLEEG).

%ALLEEG EEG index] = eeg_store(ALLEEG, EEG, group{i});
%pop_comperp( ALLEEG, 0, [2 3] ,[],'addavg', 'off','addstd','off', 'addall', 'on', 'diffavg','off','diffstd','off', 'tplotopt',{'title',[group{1} ' vs ' group{i} ' ERPs'], 'ydir', 1});
%[erp1 erp2 erpsub time sig] = pop_comperp( ALLEEG, flag, datadd, datsub, 'key', 'val');
% save([save_path,filesep,'ALLEEG.mat'],'ALLEEG'); 
