% Author: Seydanur Tikir (seydanurtikir@gmail.com)

function iclabelSelectSaveV2(EEG,fileName,save_path)
%{'RejectedNoise50BrainSafety5'  'RejectedNoise80' 'SelectedBrain20' 'BrainGreaterThanNoise' 'SelectedBrain50'}

% extract all event codes (for any experiment) for temp epoch
if isstr(EEG.event(1).type);
    events=[]; for e=1:length(EEG.event); events=[events str2num(EEG.event(e).type)]; end
else
    events=[]; for e=1:length(EEG.event); events=[events EEG.event(e).type]; end
end
events=unique(events);
trigger_codes={}; for e=1:length(events); trigger_codes{e}= events(e); end
EEG2 = pop_epoch(EEG,trigger_codes,[0.05,0.6]);%this is temporary-not saving-to improveICLabel quality            

%ICLabel
EEG2 = pop_iclabel(EEG2, 'default'); %Run IC Label. Now label info is saved to EEG struct.             
ICLabel_Matrix = EEG2.etc.ic_classification.ICLabel.classifications; 
ICLabel_Matrix(:,8) = sum(ICLabel_Matrix(:,2:6),2);%add a 8th column for sumNoise           
ICLabel_Matrix(:,9) = sum(ICLabel_Matrix(:,[1 7]),2);%add a 9th column for sumBrainOhter 
        
       % RejNoise50Br5  RejNoise30  rejEye70 RejNoise80  SelBrain30  BrainGreaterThanNoise  

                %EEG3: Rejection of Noise>50 & Brain<5
                %RejNoise50Br5
                ind_ICs = find(ICLabel_Matrix(:,8)>0.5 & ICLabel_Matrix(:,1)<0.05);              
                EEG3 = pop_subcomp( EEG, ind_ICs, 0); rejName='RejNoise50Br5';
                mkdir([save_path,filesep,rejName]);save_path_rejected = [save_path,filesep,rejName];
                pop_saveset( EEG3, 'filename',fileName,'filepath',save_path_rejected);
                EEG3 = pop_epoch(EEG3,trigger_codes,[0.05,0.6]);%this is temporary-not saving    
                pop_plotdata(EEG3, 0, 1:(EEG3.nbchan-length(ind_ICs)) , [1:EEG3.trials],[fileName,' ',rejName,' all conditions'] , 0, 1, [0 0]);
                print('-dpng',[save_path_rejected,filesep,fileName,'_componentERPs.png']);close;
             
             %EEG6: The most Conservative Rejection so far! of SumNoise>80
             %RejNoise80
                ind_ICs = find(ICLabel_Matrix(:,8)>0.7);  rejName='RejNoise80';
                EEG6 = pop_subcomp( EEG, ind_ICs, 0); 
                mkdir([save_path,filesep,rejName]);save_path_rejected = [save_path,filesep,rejName];
                pop_saveset( EEG6, 'filename',fileName,'filepath',save_path_rejected);
                EEG6 = pop_epoch(EEG6,trigger_codes,[0.05,0.6]);%this is temporary-not saving    
                pop_plotdata(EEG6, 0, 1:(EEG6.nbchan-length(ind_ICs)) , [1:EEG6.trials],[fileName,' ',rejName,' all conditions'] , 0, 1, [0 0]);
                print('-dpng',[save_path_rejected,filesep,fileName,'_componentERPs.png']);close;
                
             %EEG8:
             %RejNoise30
                ind_ICs = find(ICLabel_Matrix(:,8)>0.3);  rejName='RejNoise30';
                EEG8 = pop_subcomp( EEG, ind_ICs, 0); 
                mkdir([save_path,filesep,rejName]);save_path_rejected = [save_path,filesep,rejName];
                pop_saveset( EEG8, 'filename',fileName,'filepath',save_path_rejected);
                EEG8 = pop_epoch(EEG8,trigger_codes,[0.05,0.6]);%this is temporary-not saving    
                pop_plotdata(EEG8, 0, 1:(EEG8.nbchan-length(ind_ICs)) , [1:EEG8.trials],[fileName,' ',rejName,' all conditions'] , 0, 1, [0 0]);
                print('-dpng',[save_path_rejected,filesep,fileName,'_componentERPs.png']);close;
            try

               %EEG7:Rejection of Brain Components Brain<30
               %SelBrain30
                ind_ICs = find(ICLabel_Matrix(:,1)<0.3);  
                EEG7 = pop_subcomp( EEG, ind_ICs, 0); rejName='SelectedBrain30';
                mkdir([save_path,filesep,rejName]);save_path_rejected = [save_path,filesep,rejName];
                pop_saveset( EEG7, 'filename',fileName,'filepath',save_path_rejected);
                EEG7 = pop_epoch(EEG7,trigger_codes,[0.05,0.6]);%this is temporary-not saving    
                pop_plotdata(EEG7, 0, 1:(EEG7.nbchan-length(ind_ICs)) , [1:EEG7.trials],[fileName,' ',rejName,' all conditions'] , 0, 1, [0 0]);
                print('-dpng',[save_path_rejected,filesep,fileName,'_componentERPs.png']);close;

                %EEG5:reject if noise greater than brain
                %BrainGreaterThanNoise
                ind_ICs = find(ICLabel_Matrix(:,1)<ICLabel_Matrix(:,8)); 
                EEG5 = pop_subcomp( EEG, ind_ICs, 0); rejName='BrainGreaterThanNoise';
                mkdir([save_path,filesep,rejName]);save_path_rejected = [save_path,filesep,rejName];
                pop_saveset( EEG5, 'filename',fileName,'filepath',save_path_rejected);
                EEG5 = pop_epoch(EEG5,trigger_codes,[0.05,0.6]);%this is temporary-not saving    
                pop_plotdata(EEG5, 0, 1:(EEG5.nbchan-length(ind_ICs)) , [1:EEG5.trials],[fileName,' ',rejName,' all conditions'] , 0, 1, [0 0]);
                print('-dpng',[save_path_rejected,filesep,fileName,'_componentERPs.png']);close;

               %EEG4:
               %rejEye70
                ind_ICs = find(ICLabel_Matrix(:,3)>0.07); 
                EEG4 = pop_subcomp( EEG, ind_ICs, 0); rejName='rejEye70';
                mkdir([save_path,filesep,rejName]);save_path_rejected = [save_path,filesep,rejName];
                pop_saveset( EEG4, 'filename',fileName,'filepath',save_path_rejected);
                EEG4 = pop_epoch(EEG4,trigger_codes,[0.05,0.6]);%this is temporary-not saving    
                pop_plotdata(EEG4, 0, 1:(EEG4.nbchan-length(ind_ICs)) , [1:EEG4.trials],[fileName,' ',rejName,' all conditions'] , 0, 1, [0 0]);
                print('-dpng',[save_path_rejected,filesep,fileName,'_componentERPs.png']);close;                
                
            catch
                msg_eeg4='SomeComponentsCouldNotBeSelected';
                ErrorfileID = [save_path,filesep,msg_eeg4,'.txt'];
                dlmwrite(ErrorfileID,['**** Error occured at ',datestr(now, 'HH:MM'),' on ',datestr(now, 'dd/mm/yy'),' ***'], 'delimiter','','roffset', 1,'newline','pc','-append');
            end
end