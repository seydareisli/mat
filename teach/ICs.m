
% If you want to use GUI:
	%Load 1132.set from /Dropbox (EinsteinMed)/ICAafterChannelSpectraCleaning/Autism/1132
    %Menu > Plot > Component maps > In 2-D.
    %Menu > Plot > Component activations (scroll)).
    %Menu > Plot > Component properties.

trigger_codes = [11, 14, 21, 24, 61, 64, 31, 34, 71, 74 41, 44, 81, 84, 12, 15, 22, 25, 62, 65, 32, 35, 72, 75, 42, 45, 82, 85, 13, 16, 23, 26, 33, 36, 43, 46, 92, 93, 94, 50, 60, 70, 80, 59, 69, 79, 89, 57, 67, 77, 87, 53, 56, 63, 66, 73, 76, 83, 86, 58, 68, 78, 88, 1, 2, 3, 4, 5, 6, 7, 8, 99, 101, 102, 103, 104];


% Load post-ICA dataset Using command line 
EEG=pop_loadset(filename,filepath);	%Let's load 1132.set from /ICAafterChannelSpectraCleaning/Autism/1132 as a start


%After a Temporary-Epoch, run ICLabel
EEG2 = pop_epoch(EEG,trigger_codes,[0.05,0.6]);%this is temporary-not saving-to improveICLabel quality            
EEG2 = pop_iclabel(EEG2, 'default'); %Run IC Label. Now label info is saved to EEG struct.             


% Get LabelStatistics, calculate sum of noise etc
ICLabel_Matrix = EEG2.etc.ic_classification.ICLabel.classifications; 
ICLabel_Matrix(:,8) = sum(ICLabel_Matrix(:,2:6),2);%add a 8th column for sumNoise           
ICLabel_Matrix(:,9) = sum(ICLabel_Matrix(:,[1 7]),2);%add a 9th column for sumBrainOhter 


%plot a map of ICs
pop_topoplot(EEGplot,0, [p*25-24:p*25] ,[currentFile,'-',epochNames{e}],[5 6] ,0,'electrodes','off');
print('-dpng',[plot_save_path,filesep,'ICs_page',num2str(p),'.png']);            

    
% Plot component ERPs with temporary epoch
plot_save_path=['path of your chocice here'];
epochNames={'target_C1','target_C2','target_C3','target_C4'};
epochs = {{'13' '16'},{'23' '26'},{'33' '36'}, { '43' '46'}}; 
conds={'C1','C2','C3','C4'};

for e=1:length(epochs)                         
    EEGplot = pop_epoch( EEG, epochs{e}, [-3  1]); 
    EEGplot = pop_rmbase( EEGplot, [-2100     -1900]);%soa=950. item1onset=-1900
    numICsTemp=size(EEGplot.icaweights); 
    
    %plot erps for the first 20 components  in rectengular array. 
    pop_plotdata(EEGplot, 0, [1:20] , [1:EEGplot.trials],[currentFile,'-',epochNames{e}] , 0, 1, [0 0]);
    print('-dpng',[plot_save_path,filesep,'componentERPs_page',num2str(p),'_',conds{e},'.png']); %close;

end

          
% Reject Noise>50 & Brain<5
ind_ICs = find(ICLabel_Matrix(:,8)>ICLabel_Matrix(:,9) & ICLabel_Matrix(:,1)<0.05);              
EEG3 = pop_subcomp( EEG, ind_ICs, 0); rejName='RejectedNoise50BrainSafety5';
EEG3.setname = [currentFile, rejName];


          