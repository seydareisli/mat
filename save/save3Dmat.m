% Author: Seydanur Tikir (seydanurtikir@gmail.com)

% ERPs is a 3D matrix (chan X times X trials)
%    saves for single epochs
%    trials may contain all sorts of trials (dfr stimuli or conditions)
%    conds is 
%    badTrials stores indices of badTrials to remove. Cool!  
%    t
%    preStim  = [] 
%         other:ISIs nResps nResps2 nStims R2s RTs t tasks
%No referencing
%No baseline removal 
%Short epochs for all stim (0 +950)

load_path='X:\Analyses\ICAafterChannelSpectraCleaning\';save_path=['X:\Analyses\3DmatFiles\'];
eeglab; close; pop_editoptions( 'option_storedisk', 0, 'option_savetwofiles', 0, 'option_saveversion6', 1, 'option_single', 1, 'option_memmapdata', 0, 'option_eegobject', 0, 'option_computeica', 1, 'option_scaleicarms', 1, 'option_rememberfolder', 1, 'option_donotusetoolboxes', 0, 'option_checkversion', 1, 'option_chat', 0);
epochLen = 950; preStimTime = 150;

stimuliTrigArr = {11, 14, 21, 24, 61, 64, 31, 34, 71, 74 41, 44, 81, 84, 12, 15, 22, 25, 62, 65, 32, 35, 72, 75, 42, 45, 82, 85, 13, 16, 23, 26, 33, 36, 43, 46, 92, 93, 94, 50, 60, 70, 80, 59, 69, 79, 89, 57, 67, 77, 87, 53, 56, 63, 66, 73, 76, 83, 86, 58, 68, 78, 88, 1, 2, 3, 4, 5, 6, 7, 8};
stimuliTrigMat = [11, 14, 21, 24, 61, 64, 31, 34, 71, 74 41, 44, 81, 84, 12, 15, 22, 25, 62, 65, 32, 35, 72, 75, 42, 45, 82, 85, 13, 16, 23, 26, 33, 36, 43, 46, 92, 93, 94, 50, 60, 70, 80, 59, 69, 79, 89, 57, 67, 77, 87, 53, 56, 63, 66, 73, 76, 83, 86, 58, 68, 78, 88, 1, 2, 3, 4, 5, 6, 7, 8];
rejTypes = {'SelectedBrain50','SelectedBrain20','RejectedNoise80','RejectedNoise50BrainSafety5'};

for r=1:length(rejTypes); rejType=rejTypes{r}; 
for i = 1:numel(group), fprintf('Group: %s\n',group{i})
id = dir([load_path,group{i},filesep,'1*';]);

for j = 1:size(id,1)
    if ismember(id(j).name,Exclude_Subjects); continue;  else; end; fprintf('___ID: %s\n',id(j).name)
    subject_load_path = [load_path,group{i},filesep,id(j).name,filesep,rejType ];
    subject_save_path = [save_path,group{i},filesep,id(j).name,filesep,rejType ]; mkdir(subject_save_path);
    files = dir([subject_load_path,filesep,'*.set']);

    %Load, reject chans, interpolate, epoch
    EEG = pop_loadset(files(1).name, subject_load_path); EEG_orig=EEG; EEG=EEG_orig;  
    [EEG, badChans] = pop_rejchan(EEG, 'elec',[1:EEG.nbchan],'threshold',3.5,'norm','on','measure','spec','freqrange',[0.1 50] ); % remove any remaining bad cha
    EEG = interpolate160(EEG,path_Matlab);
    
    
    
    %epoch
    EEGep = pop_epochNoSelection(EEG,stimuliTrigArr,[0 epochLen/1000]); ERPs = EEGep.data; t=EEGep.times;
    EEGpre = pop_epochNoSelection(EEG,stimuliTrigArr,[-1*preStimTime/1000 0]); preStim = EEGpre.data; t_preStim=EEGpre.times; %data size 6576

    % create events, evConds, evBlocks
    events = []; for e = 1:length(EEG.event); events = [events str2num(EEG.event(e).type)]; end 
    events = events(find(ismember(events,[stimuliTrigMat 101 102 103 104]))); %6636 (temporarily bigger size)
    prev=1; block=1; evConds=zeros(1,length(events)); evBlocks=zeros(1,length(events)); 
    for e=1:length(events)
        if ismember(events(e),[101,102,103,104])
        evBlocks(prev:e)=zeros(1,e-prev+1)+block; block=block+1; 
        evConds(prev:e)=zeros(1,e-prev+1)+events(e)-100; prev=e+1; 
    end
    end
    ind=find(ismember(events,[101 102 103 104])); 
    events(ind)=[]; evConds(ind)=[]; evBlocks(ind)=[]; %event size back to 6576 (mathing data size)

    % add 1000 to fillers 
    ind = find(ismember(events,[1 2 3 4])); events(ind) = events(ind) + 1000* evConds(ind);

    % remove wrong, missed, early 
    wrongMissEarly=find(ismember(events,[ 59 69 79 89 57 67 77 87 58 68 78 88]));
    if  size(wrongMissEarly,2)~=0
        if wrongMissEarly(1)==1; wrongMissEarly(1)=[]; end
        events(wrongMissEarly-1)=[]; ERPs(:,:,wrongMissEarly-1)=[]; preStim(:,:,wrongMissEarly-1)=[];
        evConds(wrongMissEarly-1)=[]; evBlocks(wrongMissEarly-1)=[];
    end

    % if all is fine, save it. 
    origTimes=EEG.times; origEvents=EEG.event;
    if std(EEGep.trials,EEGpre.trials, length(events))==0 
    if  std(size(ERPs,3),size(evBlocks,2))==0
        save([subject_save_path,filesep,'ERPs.mat'],'ERPs','t','events','preStim','t_preStim','evConds','evBlocks','origEvents','origTimes'); %'triggerBad'
    end; end
end
end
end



       % timePts=EEG.times;
      %  jump=EEG.times(2)-EEG.times(1);   
     %   epochTimePts=[0:jump:epochLen]; t=epochTimePts;
     %   numTimePtsEp=ceil(epochLen/jump);
     %   t_base=[0:jump:preStimTime+jump]*-1;        % kac time var? pnts kadar. eventlatency de kacinci time oldugu.
        %length(EEG.times)=812428   round(EEG.times(812428))=6347086 EEG.pnts 812428 
        %EEG.times(2)=7.8125 
        %size(EEG.data)=160 x 812428
        % length(EEG.event)=7702  ceil(EEG.event(7702).latency)=812329
 %for e = 3:length(EEG.event)-1  %start from 2 bec there is no baseline for first also potential timing issues with first stimulus 
           % timeDfrMat=abs(EEG.times-EEG.event(e).latency); 
           % timePntIndOnset=find(timeDfrMat==min(timeDfrMat));
           % timePntIndOffset = numTimePtsEp + timePntOnset -1;
    %       epPnts=[ceil(EEG.event(e).latency) : numTimePtsEp+ceil(EEG.event(e).latency)-1];
           % epTimePtInd=[timePntIndOnset : timePntIndOffset]; 
           %baseInds=[timeInd-length(t_base)+1 :timeInd];
   %         data=EEG.data(:,epPnts); % figure; plot(t,mean(data)); title(EEG.event(e).type); pause(2); close;
    %        ERPs = cat(3,ERPs,data); events = [events str2num(EEG.event(e).type)];
           % preStim = cat(3,preStim,EEG.data(:,baseInds));
   %     end
