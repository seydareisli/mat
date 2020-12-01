
clear; clc;

matlabSession = input('Is this Matlab Session 1 or Session 2? (choose 0 for all subjects)\n ');%%feature('getpid')
paths; 

load_path=path01c; mkdir(path02c); save_path=path02c;
eeglab; pop_editoptions( 'option_storedisk', 0, 'option_savetwofiles', 0, 'option_saveversion6', 1, 'option_single', 1, 'option_memmapdata', 0, 'option_eegobject', 0, 'option_computeica', 1, 'option_scaleicarms', 1, 'option_rememberfolder', 1, 'option_donotusetoolboxes', 0, 'option_checkversion', 1, 'option_chat', 0);
trigType='all_items'; triggerDefinitions; 


% PC_Subjects = {'11051','1838','10056','1106'}; % cnl2013
PC_Subjects = {'11673','10049','10257','12433'}; %venes00
PC_Subjects = {'12433'};
PC_Subjects = {'11977'};

for i = 1:numel(group), fprintf('Group: %s\n',group{i})
    
    mkdir(save_path,group{i}) ;
    id = dir([load_path,group{i},filesep,'1*']); 
    for j = 1:size(id,1)
        if ismember(id(j).name,PC_Subjects)
        else
            continue
        end 
        fprintf('___ID: %s\n',id(j).name)
        
        mkdir([save_path,group{i},filesep,id(j).name]);
        subject_save_path = [save_path,group{i},filesep,id(j).name];
        subject_load_path = [load_path,group{i},filesep,id(j).name];
        
        files = dir([subject_load_path,filesep,'*.set']);
        
        for k=1:length(files)  
            
            % DO YOU WANT TO REJECT CHANNELS BEFORE ICA? check getBadChanIndices
                %try; channels2reject = getBadChanIndices(files(k).name(1:5),'type3') %1:5 --> '1108_' or '1108.'
                %catch; continue; end
                
            % start
                cd(subject_save_path); diary Diary_Subject; cd(path_Matlab);fprintf(['\n\n***** Date and Time:',datestr(now, 'dd/mm/yy HH:MM'),' ****\n\n']);
                EEG = pop_loadset(files(k).name, subject_load_path);            
                fprintf('___File: %s\n',files(k).name);  
                EEG = pop_select(EEG,'nochannel',{'RH','LH','RTM','LTM','RBM','LBM','Snas'}); 

             %   EEG = pop_select(EEG,'nochannel',channels2reject);

                tic;
                currentFile=files(k).name(1:end-4);
                EEG = pop_runica(EEG, 'extended',1,'stop',1e-006,'maxsteps',1000000,'interupt','on');
                runtime_runica = toc; dlmwrite([save_path,'RunicaRuntime.txt'],[datestr(now, 'yymmdd') '   ' currentFile '   ' num2str(runtime_runica)],'delimiter','','precision','%.0f','newline','pc','-append');               
                %[weights,sphere]= runica(EEG.data,'extended',1,'interupt','on','ncomps', 80);%ncomp is number of ica components to compute);
                %ICAwSave = [subject_save_path, filesep,currentFile,'_originalICAweigths.mat'];
                %save(ICAwSave,'data','weights','sphere'); clear data weights sphere fileSave
                EEG = pop_saveset( EEG, 'filename',files(k).name,'filepath',subject_save_path);
               
                
            %Temporary-Epoch,ICLabel,LabelStatistics,MatrixSave
                EEG2 = pop_epoch(EEG,trigger_codes,[0.05,0.6]);%this is temporary-not saving-to improveICLabel quality            
                EEG2 = pop_iclabel(EEG2, 'default'); %Run IC Label. Now label info is saved to EEG struct.             
                ICLabel_Matrix = EEG2.etc.ic_classification.ICLabel.classifications; 
                ICLabel_Matrix(:,8) = sum(ICLabel_Matrix(:,2:6),2);%add a 8th column for sumNoise           
                ICLabel_Matrix(:,9) = sum(ICLabel_Matrix(:,[1 7]),2);%add a 9th column for sumBrainOhter 
                %ICLabel_Matrix, summary and statistics
                save([subject_save_path,filesep,files(k).name(1:end-4),'.mat'],'ICLabel_Matrix');
                fileID = [subject_save_path,filesep,'ICLabel_Matrix_Summary.txt']; title=['n' 'b' 'm' 'e' 'c' 'o' 'N'];
                dlmwrite(fileID,title,'delimiter','\t','roffset', 0,'newline','pc','-append'); 
                for m=1:length(ICLabel_Matrix)
                    dlmwrite(fileID,[m/10 ICLabel_Matrix(m,[1 2 3 6 7 8])]*10,'precision','%.0f','delimiter','\t','roffset', 0,'newline','pc','-append'); 
                end
                writeIClabelStatistics(subject_save_path,currentFile,ICLabel_Matrix);
 
%EEG = pop_loadset('filename','1106.set','filepath','X:\\Analyses\\firstICAonMergedSessionsLightCleaning\\Autism\\1106\\');
%load('X:\Analyses\firstICAonMergedSessionsLightCleaning\Autism\1106\1106.mat','ICLabel_Matrix');
               
                
            % Plot components and component ERPs with temporary epoch
                mkdir([subject_save_path,filesep,'componentPlots']); plot_save_path=[subject_save_path,filesep,'componentPlots'];
                epochNames={'longEpoch-item3_C1','longEpoch-item3_C3&4'}; epochs = {{'13' '16'}, {'33' '36' '43' '46'}}; conds={'C1','C34'};
                for e=1:length(epochs)                         
                    EEGplot = pop_epoch( EEG, epochs{e}, [-3  1]); EEGplot = pop_rmbase( EEGplot, [-2100     -1900]);%soa=950. item1onset=-1900
                    numICsTemp=size(EEGplot.icaweights); numICs=numICsTemp(1); ICprintLoop=(numICs-mod(numICs,25))/25;
                    for p=1:ICprintLoop                       
                        %component erps in rectengular array. 
                        if p==1 %the first 5 component can depress the amplitudes of next 20. print separately as well. 
                        pop_plotdata(EEGplot, 0, [6:25] , [1:EEGplot.trials],[currentFile,'-',epochNames{e}] , 0, 1, [0 0]);
                        print('-dpng',[plot_save_path,filesep,'componentERPs_page',num2str(p),'b_',conds{e},'.png']);close;
                        end
                        pop_plotdata(EEGplot, 0, [p*25-24:p*25] , [1:EEGplot.trials],[currentFile,'-',epochNames{e}] , 0, 1, [0 0]);
                        print('-dpng',[plot_save_path,filesep,'componentERPs_page',num2str(p),'_',conds{e},'.png']);close;
                        %map of ICs
                        if e==2; continue; end; %because ICs won't change with different epoching
                        pop_topoplot(EEGplot,0, [p*25-24:p*25] ,[currentFile,'-',epochNames{e}],[5 6] ,0,'electrodes','off');
                        print('-dpng',[plot_save_path,filesep,'ICs_page',num2str(p),'.png']);close;
                    end
                end

            
             %Save individual ICs with labels (+ ifchanNoise>30, saves again)
                mkdir([subject_save_path,filesep,'individual_ICs']);  mkdir([subject_save_path,filesep,'BadChannelsProb30']);
                ind_ICs = 1:EEG.nbchan;%find(ICLabel_Matrix(:,6)>0.3);
                for c=1:length(ind_ICs)
                    fullfig('Border',10);pop_topoplot(EEG,0, ind_ICs(c) ,currentFile,[3 4] ,0, 'electrodes', 'numbers', 'masksurf', 'on');     
                    scaleYlim=ylim;
                    text(-19,scaleYlim(2)*1.55,'ICLabelProbs','FontSize',13,'FontName','FixedWidth');
                    text(-19,scaleYlim(2)*1.4,['  brain:', sprintf('%.3f',ICLabel_Matrix(ind_ICs(c),1)) ],'FontSize',13,'FontName','FixedWidth');
                    text(-19,scaleYlim(2)*1.3,[' muscle:', sprintf('%.3f',ICLabel_Matrix(ind_ICs(c),2)) ],'FontSize',13,'FontName','FixedWidth');
                    text(-19,scaleYlim(2)*1.2,['    eye:', sprintf('%.3f',ICLabel_Matrix(ind_ICs(c),3)) ],'FontSize',13,'FontName','FixedWidth');
                    text(-19,scaleYlim(2)*1.1,['   chan:' sprintf('%.3f',ICLabel_Matrix(ind_ICs(c),6)) ],'FontSize',13,'FontName','FixedWidth');
                    text(-19,scaleYlim(2)*1.0,['  other:', sprintf('%.3f',ICLabel_Matrix(ind_ICs(c),7)) ],'FontSize',13,'FontName','FixedWidth');
                    print('-dpng',[subject_save_path,filesep,'Individual_ICs',filesep,'IC_',num2str(ind_ICs(c)),'.png']);
                    if ICLabel_Matrix(ind_ICs(c),6)>0.3
                        print('-dpng',[subject_save_path,filesep,'BadChannelsProb30',filesep,'IC_',num2str(ind_ICs(c)),'.png']);
                    end
                    close;
                end
                

             %EEG3: Rejection of Noise>50 & Brain<5
                ind_ICs = find(ICLabel_Matrix(:,8)>ICLabel_Matrix(:,9) & ICLabel_Matrix(:,1)<0.05);              
                EEG3 = pop_subcomp( EEG, ind_ICs, 0); rejName='RejectedNoise50BrainSafety5';
                EEG3.setname = [currentFile, rejName];
                %EEG.comments = char([V_Participant, '_bp03_40r_ica_bc'], '; Sampling Rate: 500 Hz; BPF: 0.3-40 Hz; ReRef: Linked Mastoids;');
                mkdir([subject_save_path,filesep,rejName]);
                subject_save_path_rejected = [subject_save_path,filesep,rejName];
                pop_saveset( EEG3, 'filename',files(k).name,'filepath',subject_save_path_rejected);
                writeDataQuality(subject_save_path,currentFile,EEG,'before_ICA');
                writeDataQuality(subject_save_path,currentFile,EEG3,rejName);
               %epoch to print one page of componentERPs
                EEG3 = pop_epoch( EEG3, {'13' '16' '23' '26' '33' '36' '43' '46'}, [-3  1]); EEG3 = pop_rmbase( EEG3, [-2100     -1900]);%soa=950. item1onset=-1900
                pop_plotdata(EEG3, 0, 1:(EEG3.nbchan-length(ind_ICs)) , [1:EEG3.trials],[currentFile,' ',rejName,' all conditions'] , 0, 1, [0 0]);
                print('-dpng',[subject_save_path_rejected,filesep,currentFile,'_componentERPs.png']);close;

                
                
             %EEG6: The most Conservative Rejection so far! of SumNoise>80
                ind_ICs = find(ICLabel_Matrix(:,8)>0.8); 
                rejName='RejectedNoise80';
                EEG6 = pop_subcomp( EEG, ind_ICs, 0); 
                EEG6.setname = [currentFile, rejName];
                %EEG.comments = char([V_Participant, '_bp03_40r_ica_bc'], '; Sampling Rate: 500 Hz; BPF: 0.3-40 Hz; ReRef: Linked Mastoids;');
                mkdir([subject_save_path,filesep,rejName]);
                subject_save_path_rejected = [subject_save_path,filesep,rejName];
                pop_saveset( EEG6, 'filename',files(k).name,'filepath',subject_save_path_rejected);
                writeDataQuality(subject_save_path,currentFile,EEG,'before_ICA');
                writeDataQuality(subject_save_path,currentFile,EEG6,rejName);
           %epoch to print one page of componentERPs
                EEG6 = pop_epoch( EEG6, {'13' '16' '23' '26' '33' '36' '43' '46'}, [-3  1]); EEG6 = pop_rmbase( EEG6, [-2100     -1900]);%soa=950. item1onset=-1900
                pop_plotdata(EEG6, 0, 1:(EEG6.nbchan-length(ind_ICs)) , [1:EEG6.trials],[currentFile,' ',rejName,' all conditions'] , 0, 1, [0 0]);
                print('-dpng',[subject_save_path_rejected,filesep,currentFile,'_componentERPs.png']);close;
            
                            
            try

               %EEG7:Rejection of Brain Components Brain<20
                ind_ICs = find(ICLabel_Matrix(:,1)<0.2);  
                EEG7 = pop_subcomp( EEG, ind_ICs, 0); rejName='SelectedBrain20';
                EEG7.setname = [currentFile, rejName];
                %EEG.comments = char([V_Participant, '_bp03_40r_ica_bc'], '; Sampling Rate: 500 Hz; BPF: 0.3-40 Hz; ReRef: Linked Mastoids;');
                mkdir([subject_save_path,filesep,rejName]);
                subject_save_path_rejected = [subject_save_path,filesep,rejName];
                pop_saveset( EEG7, 'filename',files(k).name,'filepath',subject_save_path_rejected);
               writeDataQuality(subject_save_path,currentFile,EEG7,rejName);
           %epoch to print one page of componentERPs
                EEG7 = pop_epoch( EEG7, {'13' '16' '23' '26' '33' '36' '43' '46'}, [-3  1]); EEG7 = pop_rmbase( EEG7, [-2100     -1900]);%soa=950. item1onset=-1900
                pop_plotdata(EEG7, 0, 1:(EEG7.nbchan-length(ind_ICs)) , [1:EEG7.trials],[currentFile,' ',rejName,' all conditions'] , 0, 1, [0 0]);
                print('-dpng',[subject_save_path_rejected,filesep,currentFile,'_componentERPs.png']);close;

                
                %EEG5:reject if noise greater than brain
                ind_ICs = find(ICLabel_Matrix(:,1)<ICLabel_Matrix(:,8)); 
                EEG5 = pop_subcomp( EEG, ind_ICs, 0); rejName='BrainGreaterThanNoise';
                EEG5.setname = [currentFile, rejName];
                %EEG.comments = char([V_Participant, '_bp03_40r_ica_bc'], '; Sampling Rate: 500 Hz; BPF: 0.3-40 Hz; ReRef: Linked Mastoids;');
                mkdir([subject_save_path,filesep,rejName]);
                subject_save_path_rejected = [subject_save_path,filesep,rejName];
                pop_saveset( EEG5, 'filename',files(k).name,'filepath',subject_save_path_rejected);
                writeDataQuality(subject_save_path,currentFile,EEG5,rejName);           %epoch to print one page of componentERPs
                EEG5 = pop_epoch( EEG5, {'13' '16' '23' '26' '33' '36' '43' '46'}, [-3  1]); EEG5 = pop_rmbase( EEG5, [-2100     -1900]);%soa=950. item1onset=-1900
                pop_plotdata(EEG5, 0, 1:(EEG5.nbchan-length(ind_ICs)) , [1:EEG5.trials],[currentFile,' ',rejName,' all conditions'] , 0, 1, [0 0]);
                print('-dpng',[subject_save_path_rejected,filesep,currentFile,'_componentERPs.png']);close;


               %EEG4:Rejection of Brain Components Brain<50 
                ind_ICs = find(ICLabel_Matrix(:,1)<0.5);  
                EEG4 = pop_subcomp( EEG, ind_ICs, 0); rejName='SelectedBrain50';
                EEG4.setname = [currentFile, rejName];
                %EEG.comments = char([V_Participant, '_bp03_40r_ica_bc'], '; Sampling Rate: 500 Hz; BPF: 0.3-40 Hz; ReRef: Linked Mastoids;');
                mkdir([subject_save_path,filesep,rejName]);
                subject_save_path_rejected = [subject_save_path,filesep,rejName];
                pop_saveset( EEG4, 'filename',files(k).name,'filepath',subject_save_path_rejected);
               writeDataQuality(subject_save_path,currentFile,EEG4,rejName);
           %epoch to print one page of componentERPs
                EEG4 = pop_epoch( EEG4, {'13' '16' '23' '26' '33' '36' '43' '46'}, [-3  1]); EEG4 = pop_rmbase( EEG4, [-2100     -1900]);%soa=950. item1onset=-1900
                pop_plotdata(EEG4, 0, 1:(EEG4.nbchan-length(ind_ICs)) , [1:EEG4.trials],[currentFile,' ',rejName,' all conditions'] , 0, 1, [0 0]);
                print('-dpng',[subject_save_path_rejected,filesep,currentFile,'_componentERPs.png']);close;
                diary off;

            catch
                diary off; msg_eeg4='SomeComponentsCouldNotBeSelected';
                ErrorfileID = [subject_save_path,filesep,msg_eeg4,'.txt'];
                dlmwrite(ErrorfileID,['**** Error occured at ',datestr(now, 'HH:MM'),' on ',datestr(now, 'dd/mm/yy'),' ***'], 'delimiter','','roffset', 1,'newline','pc','-append');
                dlmwrite(ErrorfileID,['File: ',currentFile, ' PC: ',pc_name], 'delimiter','','newline','pc','-append');
            end
                %Recompute Data Quality            
                  
                
            %catch

                %continue; 
            %end           
        end
    end
end
