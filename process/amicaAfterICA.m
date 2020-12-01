clear all
load_path='X:\Analyses\ICAafterChannelSpectraCleaning\';
path_get_ready='X:\Analyses\beforeAMICA-chanSubsetSelected\';
save_path=['X:\Analyses\AMICAafterICA\'];
rejName='RejectedNoise50BrainSafety5';
group = {'Neurotypical','Autism'};
addpath('S:\eeglab'); eeglab; close;
runtimeFile = [save_path,filesep,'runtime-AMICA.txt'];

        
for i = 1:numel(group), fprintf('Group: %s\n',group{i})
        id = dir([load_path,group{i},'\1*']);
    for j = 1:size(id,1)
        try 
        cd('S:\pool');    
        subject_load_path = [load_path,group{i},filesep,id(j).name,filesep,rejName,filesep];
        subject_save_path = [save_path,filesep,group{i},filesep,id(j).name]; mkdir(subject_save_path);
        EEG = pop_loadset([subject_load_path , filesep, id(j).name,'.set']);
        EEGsubset= saveChannelSubset(EEG,5,subject_save_path,[id(j).name,'-beforeAmica'],1) ;% divide into 4 subsets, but take the 1st subset only
        %for 12386: j=11; EEGsubset=pop_loadset([subject_save_path,filesep,id(j).name,'-beforeAmica.set']);
        chanlocs=EEGsubset.chanlocs;
        num_models = 5;  max_iter = 2000;  tic;% max number of learning steps
        fileID=[id(j).name,'-',num2str(num_models),'models-',num2str(EEGsubset.nbchan),'channels-',num2str(max_iter),'iter'];
        cd(subject_save_path);
        [weights,sphere,modelOut] = runamica15(EEGsubset.data, 'num_models',num_models, 'max_iter',max_iter);%, ...
        cd('S:\pool');
        timetrack=round(toc/60) ; %301 minutes for 11051 (3 models)
        dlmwrite(runtimeFile,[datestr(now, 'mmddyy-') fileID '  '  num2str(timetrack) 'min'],'delimiter','','precision','%.0f','newline','pc','-append');               
        save([subject_save_path,filesep,'Results-',fileID,'.mat'],'modelOut','chanlocs');
        %load([subject_save_path,filesep,'Results-',fileID,'.mat'],'modelOut','chanlocs');
        %rmdir([subject_save_path,'\amicaouttmp'],'s');
        winLen = 5; walkLen = 1;    % sec
        plotAmicaProbability(EEGsubset,modelOut,winLen,walkLen,id(j).name);
        print('-dpng',[subject_save_path,filesep,'Fig-Probs-',fileID,'.png']);close;
        %model_id=1;
        %EEGsubset.icaweights = modelOut.W(:,:,model_id);
        %EEGsubset.icasphere = modelOut.S;
        %EEGsubset.icawinv = modelOut.A(:,:,model_id);
        clear EEGsubset EEG modelOut timetrack fileID

        
        catch
            continue
        end
    end
end
