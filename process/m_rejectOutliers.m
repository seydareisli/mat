% Author: Seydanur Tikir (seydanurtikir@gmail.com)

%check if there is any outlier channels 
%writes rejection stats as well. 
%reject outlier trials based on max GFPs


% code to remove baseline later:
% for tr=1:size(ERPs,3);  ERPs(:,:,tr) = ERPs(:,:,tr) -baseline(:,tr); end

    
function [subjRejStats,ERPs,preStim,events,evConds,evBlocks]= m_rejectOutliers(cases,ERPs,preStim,events,evConds,evBlocks)
    col=0; subjRejStats=[];
    nchan=size(ERPs,1);
    data=squeeze(mean(ERPs,3));
    outChs=[]; for ch=1:nchan; if sum(data(1,:)>mean(data)+3*std(data))>0; outChs=[outChs ch]; end
        if sum(data(1,:)<mean(data)-3*std(data))>0; outChs=[outChs ch];end
    end
    newChans=find(ismember([1:nchan],outChs)==0);
    col=col+1; subjRejStats(col)=length(outChs);
    col=col+1; subjRejStats(col)=size(ERPs,3);
    %reject outlier trials based on max GFPs 
    %3 is safer and more scientific
    mx=[];for tr=1:size(ERPs,3); mx=[mx max(std(ERPs(newChans,:,tr)))];end
    mx(find(mx>80))=[]; outlierTrials=find(mx>mean(mx)+3*std(mx));
    ERPs(:,:,outlierTrials)=[]; preStim(:,:,outlierTrials)=[]; events(outlierTrials)=[];
    try; evConds(outlierTrials)=[]; evBlocks(outlierTrials)=[]; end
    fprintf('%d out of %d trials were rejected based on max GFP method \n',length(outlierTrials),size(ERPs,3));
    col=col+1; subjRejStats(col)=length(outlierTrials);
    %reject outlier trials based on max GFPs
    outlierTrials=[];
    for cs=1:length(cases); trig = trigs(cases{cs}); trials=find(ismember(events,trig));
        trGFP=std(ERPs(newChans,:,trials));
        outTr=[]; for tr=trials; if sum(std(ERPs(newChans,:,tr))>mean(trGFP)+3*std(trGFP))+ sum(std(ERPs(newChans,:,tr))<mean(trGFP)-3*std(trGFP))...
                >0; outTr=[outTr tr]; end; end
    outlierTrials=[outlierTrials outTr];
    fprintf('%d out of %d %ss are labeled for rejection\n',length(outTr),length(trials),cases{cs});
    end
    ERPs(:,:,outlierTrials)=[]; preStim(:,:,outlierTrials)=[]; events(outlierTrials)=[]; 
    try; evConds(outlierTrials)=[]; evBlocks(outlierTrials)=[]; end
    col=col+1; subjRejStats(col)=length(outlierTrials);
    fprintf('%d out of %d trials were rejected based on their distance to mean gfp of the trial type \n',length(outlierTrials),size(ERPs,3));
    

 end
 