% Running ANOVA
% Author: Seydanur Tikir  Contact: seydanurtikir@gmail.com
% This is an early version of the code. come back to check updates

function [reorderedChans, reorderedChanLabels,grInd] = groupChannels(chanlocs, numGroups)
    if numGroups==13
        chanNames={'FF','F-L','F','F-R',  'T-L','C-L', 'C', 'C-R','T-R',   'P','P-L','P-R','O' };
        chanNames2={'fpz','D23','fz','CN17',   't7','c3','cz','c4','t8',  'pz','E30','B12','oz' };
        chanInds    =  [104 119 100 81       137 132 1 71 64           19 158  44   23 ];
%b12-13 64-65 temp.
%23 Oz  B32=T8olmali
    end
    numChanGr=length(chanInds);grChans=[];
    for l=1:160
        X1 =chanlocs(l).X ; Y1=chanlocs(l).Y; Z1=chanlocs(l).Z; 
        for gr=1:numChanGr
            c=chanInds(gr); 
            X= chanlocs(c).X; Y=chanlocs(c).Y; Z=chanlocs(c).Z; 
            dis(gr)=((X1-X)^2+(Y1-Y)^2+(Z1-Z)^2)^0.5; 
        end
        [~,I]=sort(dis);
        closestgr = I(1);
        grChans=[grChans; closestgr];
    end
    grChans =[grChans [1:160]'];
    grChans = sortrows(grChans,1);
    reorderedChans=grChans(:,2);
    grInd=grChans(:,1);
    for c=1:160;reorderedChanLabels{c}=chanNames{grChans(c,1)};end
end

