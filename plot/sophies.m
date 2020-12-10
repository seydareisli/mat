% Author: Seydanur Tikir (seydanurtikir@gmail.com)
% July 10  2020

%draws scalp comparision maps as Sophie likes
%using pop_comperp function
%input: 3D array for times x conds x chans
%output: ALLEEG (in case needed), in addition the the  plot

%{
Sample uSage:a
ERPs2comp=squeeze(avgERPs(1,:,[9 11 13],:,1));
chansPlot=[1:1:128];
names={'ID','ID-2','ID-4'};
sophies(ERPs2comp,names, 'testPlotName', chansPlot)
%}

% Do not delete this:
%{
    EEG = pop_loadset('X:\Analyses\epochedSets\correct[-3 0] RefAll\Autism_1108_correct_C1.set');
    EEG.nbchan=128; EEG.trials=2; 
    tinyEEG128 = pop_loadset('tinyEEG128.set');
    EEG.chanlocs=tinyEEG128.chanlocs;
    EEG.data(:,:,3:end)=[]; EEG.data(129:end,:,:)=[];EEG.data(:,155:end,:)=[];  
    EEG.srate=256; EEG.xmin=0; EEG.xmax=time2ms(154);
    newEpochStruc=struct();
    newEpochStruc(1).event=EEG.epoch(1).event;newEpochStruc(2).event=EEG.epoch(2).event;
    newEpochStruc(1).eventtype=EEG.epoch(1).eventtype;newEpochStruc(2).eventtype=EEG.epoch(2).eventtype;
    newEpochStruc(1).eventlatency=EEG.epoch(1).eventlatency;newEpochStruc(2).eventlatency=EEG.epoch(2).eventlatency;
    newEpochStruc(1).eventurevent=EEG.epoch(1).eventurevent;newEpochStruc(2).eventurevent=EEG.epoch(2).eventurevent;
    newEpochStruc(1).eventduration=EEG.epoch(1).eventduration;newEpochStruc(2).eventduration=EEG.epoch(2).eventduration;
    EEG.epoch=newEpochStruc;
    pop_saveset(EEG,'filename','pseudoEEG4comperps_cap128','filepath','S:\pool')'
 %}
function []= sophies(ERPs2comp, setnames,plot_name, chansPlot)
ALLEEG=[];
addpath('S:/eeglab');%eeglab; close; pop_editoptions( 'option_storedisk', 0, 'option_savetwofiles', 0, 'option_saveversion6', 1, 'option_single', 1, 'option_memmapdata', 0, 'option_eegobject', 0, 'option_computeica', 1, 'option_scaleicarms', 1, 'option_rememberfolder', 1, 'option_donotusetoolboxes', 0, 'option_checkversion', 1, 'option_chat', 0);
numComp=size(ERPs2comp,2);
EEGpseudo=pop_loadset('S:\pool\pseudoEEG4comperps_cap128.set');
for c=1:numComp
    erps=squeeze(ERPs2comp(:,c,:))';
    EEG=EEGpseudo;
    EEG.data(:,:,1)=squeeze(erps); EEG.data(:,:,2)=squeeze(erps);
    EEG.setname=setnames{c};
    try; EEG = pop_select( EEG,'channel',chansPlot); end
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
end

eegS = [1:numComp];
pop_comperp( ALLEEG, 1, eegS ,[],'title',plot_name,'addavg','off','addstd','off','addall','on','diffavg','off','diffstd','off','tplotopt',{'ydir' 1});
%clipboard('copy',plot_name);
%print('-dpng',['M:\Plots',filesep,'auto_avgRef',plot_name,'.png']);
end


%{
ALLEEG=[];
for c=1:length(cond_list)
EEG = pop_loadset([pathRoot,session,'_2chanSubset2_',cond_list{c},'.set']);
EEG.setname=regexprep(cond_list{c},'_','-');
EEG = pop_select( EEG,'channel',chansPlot);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
end
eegS = [1:length(cond_list)];
%added 'tlim',[0 200]
pop_comperp( ALLEEG, 1, eegS ,[],'addavg','off','addstd','off','addall','on','diffavg','off','diffstd','off','tplotopt',{'ydir' 1});

plot_name=[subjectID,'_',session,'_',cond_list_name];
clipboard('copy',plot_name);
end


ALLEEG=[];
EEG = pop_loadset([pathRoot,session,'_2chanSubset2_',cond_list{c},'.set']);
EEG.setname=regexprep(cond_list{c},'_','-');
%EEG = pop_select( EEG,'channel',chansPlot);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
eegS = [1:length(cond_list)];
pop_comperp( ALLEEG, 1, eegS ,[],'addavg','off','addstd','off','addall','on','diffavg','off','diffstd','off','tplotopt',{'ydir' 1});
clipboard('copy',plot_name);
print('-dpng',['M:\Plots',filesep,'auto_avgRef',plot_name,'.png']);
 
 %}
