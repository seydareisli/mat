% Author: Seydanur Tikir (seydanurtikir@gmail.com)

filter075 =1;
filter001 =5;

if filter075==1; 
save_path= 'X:\Analyses\_01InitialProcessed\';
elseif filter001==1; 
%I think this one ='X:\Analyses\_01InitialProcessedFilter001\';
end


% Removes EEG data within the regions of rest breaks
%   1. removes initial break where the participant is reading instructions 
%   2. removes all breaks between any two trials
%  - uses eegrej function to reject these regions
%  - generates useful messages on command window to record how many regions
%      are rejected, and the time points for the boundaries of these regions. 
% In SPLT study, the trigger codes that are ending blocks are 101,102,103,104,
% the trigger code for clikcs that are used for going to next instruction or block is 99.

% IMPORTANT NOTE: USE EEGLAB 14 OR LATER VERSIONS! - See eeglab bug 1971 for more info


% -------------------------------------------------------------------------
% Author: Seydanur Tikir stikir@mail.einstein.yu.edu
% Jan 30th, 2019
% -------------------------------------------------------------------------


%clear; clc;
%paths;
load_path = path00;  
eeglab; 
%cd([path_Diary,pc_name]);diary 'initialProcessing'; cd(path_Notes);
fileID = [datestr(now, 'yymmdd'),'_initialProcessing_',pc_name];
dlmwrite(fileID,['******** Start - Date and Time:',datestr(now, 'dd/mm/yy HH:MM'),' ********'], 'delimiter','','-append');

%PC_Subjects = {'11051','1838','10056'};
PC_Subjects = {'11977'};

for i = 1:2
    id = dir([load_path,group{i},filesep,'1*']); 
    
    for j = 1:size(id,1) 
        if ismember(id(j).name,PC_Subjects);else;continue;end         
        mkdir([save_path,group{i},filesep,id(j).name]);
        subject_load_path = [load_path,group{i}, filesep, id(j).name, filesep];
        subject_save_path = [save_path,group{i}, filesep, id(j).name, filesep];
        files = dir([subject_load_path, filesep, '*.bdf']);
        cd(subject_save_path); diary Diary_Subject; cd(path_Matlab);fprintf(['\n\n***** Date and Time:',datestr(now, 'dd/mm/yy HH:MM'),' ****\n\n']);
                        
        for k=1:length(files)             
            currentFile = files(k).name(1:end-4);
            fprintf('___File: %s\n',currentFile); 
            dlmwrite(fileID,'___________________________', 'delimiter','','-append');
            dlmwrite(fileID,['Current EEG file:',currentFile], 'delimiter','','-append');
            clear EEG;
            EEG = pop_biosig([subject_load_path,files(k).name]);
            EEG = pop_editset(EEG, 'chanlocs', path_sfp_167);
            EEG.chanlocs = pop_chanedit(EEG.chanlocs, 'load',{ path_sfp_167, 'filetype', 'autodetect'});
            EEG.nbchan = 167;
            EEG.data([167 169:end],:)=[]; 
            figure; topoplot([],EEG.chanlocs, 'style', 'blank',  'electrodes', 'labelpoint', 'chaninfo', EEG.chaninfo); close;
            EEG.data = double(EEG.data);   
            EEG = pop_resample(EEG, 128);
    if filter075 == 1;
    EEG = pop_eegfiltnew(EEG, [], 0.75, [], true, [], 0);
    elseif filter001 ==1;
    EEG = pop_eegfiltnew(EEG, [], 0.75, [], true, [], 0);
    end
            EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:EEG.nbchan],'computepower',1,'linefreqs',[60 180] ,'normSpectrum',0,'p',0.05,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',4,'winstep',4);
            EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:EEG.nbchan],'computepower',1,'linefreqs',[60 180] ,'normSpectrum',0,'p',0.05,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',4,'winstep',4);
            close all;
            dlmwrite(fileID,'Data is 1)Converted to dataset 2)downsampled to 128 Hz 3)High-Pass Filtered at 0.75 Hz 4)CleanedLined twice', 'delimiter','','-append');
            
            %EEG=pop_loadset(files(k).name,subject_load_path);
            conditions = [];

            %create matrix x to strore time between two trials.                     
            x=[]; y=[]; m=0;
            for n=1:length(EEG.event)
                try
                    if EEG.event(n).type == 101 || EEG.event(n).type == 102 || EEG.event(n).type == 103 || EEG.event(n).type == 104
                        m=m+1;
                        x(m,1)=EEG.event(n).latency+100; %add and substract 100 because you do not want to delete trigger code on boundary 
                        x(m,2)=EEG.event(n+1).latency-100; %event(n+1) is 99, which is next session
                        y(m) = x(m,2)-x(m,1);    
                        conditions = [conditions EEG.event(n).type-100];
                    end

                end
            end
            
            x(m,2)=length(EEG.data);
            
            format long g 
            dlmwrite(fileID,'The sequence of conditions:', 'delimiter','','-append');
            dlmwrite(fileID, conditions, 'delimiter',' ','precision','%.0f','-append');

            dlmwrite(fileID,'Rejecting data point intervals in the following matrix:', 'delimiter','','-append');
            dlmwrite(fileID, x, 'delimiter',' ','precision','%.0f','-append');
            EEG = eeg_eegrej( EEG, x);
            
            %event codes are now strings, not numbers, afger eegrej. 
            for first =1:50
                if EEG.event(first).type == '99'
                    continue 
                else
                    
                    EEG = eeg_eegrej( EEG, [0 EEG.event(first).latency]);
                    dlmwrite(fileID,'Initial interval is removed until the following data point:', 'delimiter','','-append');
                    dlmwrite(fileID,EEG.event(first).latency, 'delimiter','-','precision','%.0f','-append');
                    dlmwrite(fileID,'It included the following number of clicks events:' , 'delimiter','','-append');
                    dlmwrite(fileID,first-1, 'delimiter','-','precision','%.0f','-append');

                    break
                end
            end
            
          
            
            % NOW DOUBLE CHECK if it worked well. 
            x=[]; m=0;
            for n=2:length(EEG.event)
            if EEG.event(n).latency-EEG.event(n-1).latency > 200
                m=m+1;
                x(m,1)= EEG.event(n-1).latency+50;
                x(m,2)= EEG.event(n).latency-50;
                text='long interval detected: ';
                fprintf([text,'%d- %d \n'],x(m,1),x(m,2));
                
                %EEG.event(n).latency-EEG.event(n-1).latency );
                ErrorfileID = [path01,filesep,'checkBreaks.txt'];      
                dlmwrite(ErrorfileID,files(k).name(1:end-4), 'delimiter','','roffset', 2,'newline','pc','-append');
                dlmwrite(ErrorfileID,text, 'delimiter','','roffset', 1,'newline','pc','-append');
                dlmwrite(ErrorfileID,[n-1 n], 'delimiter','\t','roffset', 0,'newline','pc','-append');

            end;end;
            
            %remove remanining empty intervals, if there is any:
            if length(x)~=0; EEG = eeg_eegrej( EEG, x); end
            
            writeDataQuality(subject_save_path,currentFile,EEG,'before_ICA');
            
            pop_saveset( EEG, [files(k).name(1:end-4)], subject_save_path);
            diary off;
            
        end
    end
end



% to make sure that the breaks are calculated accurately, I did the followimg:
% new_eeg = eeg_eegrej( EEG, x);
% EEG.pnts-new_eeg.pnts is equal to sum(y). so it worked!


