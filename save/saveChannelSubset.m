%saveNameRoot is something like 10545_WithResponse
% If you want to save the first subset only, enter 1 for isFirstSubsetOnly

function EEG=saveChannelSubset(EEG, numChanSubsets,subject_save_path,saveNameRoot,isFirstSubsetOnly)

if isFirstSubsetOnly ~= 1; isFirstSubsetOnly=0; end

    channels={EEG.chanlocs.labels}; X=[EEG.chanlocs.X]; Y=[EEG.chanlocs.Y]; Z=[EEG.chanlocs.Z]; 
    numSections=floor((length(channels)-1)/numChanSubsets);%-1 for the most central channel, which will be present in all subsets
    chanSections=cell(numChanSubsets,numSections+1); %empty cell array. each column is a section; each row is a channel subset

    centralChan=channels(find(Z==max(Z))); %usually Cz, if not rejected
    for n=1:numSections
        myChan=find(Z==min(Z)); %start from the most peripheral channel
        for c=1:length(channels) %calculate its distance to all other channels
            dis(c)=((X(myChan)-X(c))^2+(Y(myChan)-Y(c))^2+(Z(myChan)-Z(c))^2)^0.5; 
        end
        [temp,I]=sort(dis); clear temp dis %sort the distance matrix
        for g=1:numChanSubsets
            chanSections{g,n} = channels(I(g)); %create bundles/sections of neighbouring channels
            chanSections{g,numSections+1} = centralChan; %include the most central channel in all channel subsets
        end
        channels(I(1:numChanSubsets))=[]; X(I(1:numChanSubsets))=[]; Y(I(1:numChanSubsets))=[]; Z(I(1:numChanSubsets))=[]; %remove bundled channels from list and go to next peripheral channel. 
    end
    subsetFolder = [subject_save_path, filesep, num2str(numChanSubsets), 'channelSubsets'];
    EEGAll = EEG;
    
    if isFirstSubsetOnly == 0   
        mkdir(subsetFolder);
        for k=1:numChanSubsets %loop through channel subsets
            evenSubset=[chanSections{k,:}]; %takes one channelf rom each bundle
            EEG = pop_select( EEGAll,'channel',evenSubset); %select channels for current sample
            figure; topoplot([],EEG.chanlocs, 'electrodes', 'labelpoint'); %plot channel locations
            pop_saveset( EEG, [saveNameRoot,'_',num2str(numChanSubsets),'chanSubset',num2str(k)], subsetFolder);
            clear EEG;
        end
    elseif isFirstSubsetOnly == 1
        k=1;
        evenSubset=[chanSections{k,:}]; %takes one channelf rom each bundle
        EEG = pop_select( EEGAll,'channel',evenSubset); %select channels for current sample
        figure; topoplot([],EEG.chanlocs, 'electrodes', 'labelpoint'); %plot channel locations
        print('-dtiff','-r500',[subject_save_path,filesep,saveNameRoot,'.jpeg']); 
        pop_saveset( EEG, saveNameRoot, subject_save_path);
        pause(1);
        close;
    end
    
end

