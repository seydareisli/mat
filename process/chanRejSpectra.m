% Author: Seydanur Tikir (seydanurtikir@gmail.com)

% Edited on
clear; clc;
matlabSession = input('Is this Matlab Session 1 or Sessiaon 2? (choose 0 for all subjects)\n ')%%feature('getpid')
paths; 

load_path='X:\Analyses\01InitialProcessed_NoFilteringNoSampling\';
save_path=;
%PC_Subjects = {'11977'};


eeglab; pop_editoptions( 'option_storedisk', 0, 'option_savetwofiles', 0, 'option_saveversion6', 1, 'option_single', 1, 'option_memmapdata', 0, 'option_eegobject', 0, 'option_computeica', 1, 'option_scaleicarms', 1, 'option_rememberfolder', 1, 'option_donotusetoolboxes', 0, 'option_checkversion', 1, 'option_chat', 0);
EEG160 = pop_loadset('EEG160-do-not-delete.set', path_Matlab);
for i = 1:numel(group), fprintf('Group: %s\n',group{i})
        id = dir([load_path,group{i}]); id(1:num_OS) = []; 
    for j = 1:size(id,1)
        %if ismember(id(j).name,PC_Subjects); else; continue; end; fprintf('___ID: %s\n',id(j).name)
        
        subject_load_path = [load_path,group{i},filesep,id(j).name];
        subject_save_path = [save_path,group{i},filesep,id(j).name]; mkdir(subject_save_path);
        files = dir([subject_load_path,filesep,'*.set']);
        cd(subject_save_path); diary Diary_ChanRejSpectra_Subject; cd(path_Matlab);fprintf(['\n\n***** Date and Time:',datestr(now, 'dd/mm/yy HH:MM'),' ****\n\n']);
         
        clear temp_set session_set allSessBadChans EEG 
        for k=1:length(files) 
            currentFile=files(k).name(1:end-4); fprintf('___File: %s\n',files(k).name);  
            if k==1 
                EEG = pop_loadset(files(k).name, subject_load_path);
                temp_set = EEG;
            else 
                EEG = pop_loadset(files(k).name, subject_load_path);
                session_set = EEG;
                temp_set = pop_mergeset( temp_set,session_set,1);
            end 
            [EEGrej, sessionBadChans] = pop_rejchan(EEG, 'elec',[1:160],'threshold',2,'norm','on','measure','spec','freqrange',[0.1 50] );
            
            sessionBadChans
            allSessBadChans{k}= sessionBadChans
            %pop_eegplot( EEG, 1, 1, 1);disp('Program paused. Please review channels and press a key...');  pause; close all;
        end
        EEGmerged=temp_set;
        sortedBadChans = sort(cell2mat(allSessBadChans))
        unq = unique(sortedBadChans);count=histc(sortedBadChans,unq);
        multiOccur=unq(count~=1);
        subChans2reject = multiOccur;
        EEG = pop_select(EEGmerged,'nochannel',subChans2reject);
        pop_saveset( EEG, id(j).name, subject_save_path);
         if isempty(subChans2reject) ~= 1
         EEGchanFigure = pop_select( EEG160,'channel',subChans2reject);
         figure; topoplot([],EEGchanFigure.chanlocs, 'style', 'blank',  'electrodes', 'labels', 'chaninfo', EEGchanFigure.chaninfo); 
         title([id(j).name,'-rejected-channels']);
         print('-dpng',[subject_save_path,filesep,id(j).name,'-rejected-channels.png']);
         close;
         end
         

         diary off
    end
end


