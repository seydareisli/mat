% filtered at 0.01 Hz 
%i=2, j=11 probem. skipped. it/s 64 chans!
clear all
load_path='X:\DATA organized by ST\';
save_path='X:\Analyses\01Filtered001Hz\';
group = {'Neurotypical','Autism'};
addpath('S:\eeglab'); eeglab; close;
fileID = [datestr(now, 'yymmdd'),'_initialProcessing_Filt001'];

for i = 1:2
    mkdir(save_path,group{i}) 
    id = dir([load_path,group{i},filesep,'1*']); 
    
    for j = 1:size(id,1) 
        mkdir([save_path,group{i},filesep,id(j).name]);
        subject_load_path = [load_path,group{i}, filesep, id(j).name, filesep];
        subject_save_path = [save_path,group{i}, filesep, id(j).name, filesep];
        mkdir(subject_save_path)
                
        files = dir([subject_load_path, filesep, '*.bdf']);
        for k=1:length(files)             
            currentFile = files(k).name(1:end-4);
            fprintf('___File: %s\n',currentFile); 
            clear EEG;
            EEG = pop_biosig([subject_load_path,files(k).name]);
            EEG.nbchan = 167;
            path_sfp_167='S:\headmaps\Biosemi167.sfp';
            EEG.chanlocs = pop_chanedit(EEG.chanlocs, 'load',{ path_sfp_167, 'filetype', 'autodetect'});
            EEG.nbchan = 167;
            EEG.data([167 169:end],:)=[]; 
            figure; topoplot([],EEG.chanlocs, 'style', 'blank',  'electrodes', 'labelpoint', 'chaninfo', EEG.chaninfo); close;
            EEG = pop_eegfiltnew(EEG, 0.05,[]);
            EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:EEG.nbchan],'computepower',1,'linefreqs',[60 180] ,'normSpectrum',0,'p',0.05,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',4,'winstep',4);
            EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:EEG.nbchan],'computepower',1,'linefreqs',[60 180] ,'normSpectrum',0,'p',0.05,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',4,'winstep',4);
            close all;

            pop_saveset( EEG, files(k).name(1:end-4), subject_save_path);
            
        end 
    end
end

%{
%variance of wavelet-cleaned data to be kept = varianceWav:
%store IC variables and calculate variance of data that will be kept after IC rejection:
ICs_to_keep =find(EEG.reject.gcompreject == 0); 
[projWav, varianceWav] =compvar(EEG.data, ICA_act, ICA_winv, ICs_to_keep);
Percent_Variance_Kept_of_Post_Waveleted_Data(current_file)=varianceWav;
%}
