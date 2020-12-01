function [reorder] = createChanGroups(chanlocs, numGroups)

    channels={chanlocs.labels}; X=[chanlocs.X]; Y=[chanlocs.Y]; Z=[chanlocs.Z]; 
    numChanSubsets=floor(length(chanlocs)/numGroups);
    chanSections=cell(numChanSubsets,numGroups); %empty cell array. each column is a section; each row is a channel subset
    chanSections2=zeros(numChanSubsets,numGroups);
    
    centralChan=channels(find(Z==max(Z))); %usually Cz, if not rejected
    for n=1:numGroups
        myChan=find(Z==min(Z)); %start from the most peripheral channel
        for c=1:length(channels) %calculate its distance to all other channels
            dis(c)=((X(myChan)-X(c))^2+(Y(myChan)-Y(c))^2+(Z(myChan)-Z(c))^2)^0.5; 
        end
        [temp,I]=sort(dis); clear temp dis %sort the distance matrix
        for g=1:numChanSubsets
            chanSections{g,n} = channels(I(g)); %create bundles/sections of neighbouring channels
            chanSections2(g,n) = I(g);
        end
        channels(I(1:numChanSubsets))=[]; X(I(1:numChanSubsets))=[]; Y(I(1:numChanSubsets))=[]; Z(I(1:numChanSubsets))=[]; %remove bundled channels from list and go to next peripheral channel. 
    end
    
    reorder=[];
    for g=1:numGroups
        grp=[chanSections2(:,g)]; 
        reorder=[reorder; grp];
    end
      
end

%saveNameRoot is something like 10545_WithResponse
