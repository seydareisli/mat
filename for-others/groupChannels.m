% Running ANOVA
% Author: Seydanur Tikir  Contact: seydanurtikir@gmail.com
% This is an early version of the code. come back to check updates
% Version adjusted to 64 channel system for MOBI  

function [reorderedChans, reorderedChanLabels,grInd] = groupChannels(chanlocs, numGroups)

    num_chans=length(chanlocs); 
    if numGroups==9
        chanNames={'F','F-L','F-R', 'C-L', 'C', 'C-R',   'P-L','O','P-R' };
        chanNames2={'afz','f7','f8',  'c5','cz','c6',   'p9','oz','p10' };
        chanInds    =  [37 7 42     14 47 51    24 29 61  ];
    end

    if numGroups==10
        chanNames={'F','F-L','F-R', 'C-L', 'C', 'C-R',   'P-L','P','P-R' , 'O'};
        chanNames2={'afz','f7','f8',  'c5','cz','c6',   'p9','Pz','p10', 'Oz' };
        chanInds    =  [37 7 42     14 47 51    24 31 61   29];
    end
    
  %  {'AFz',0,  7.9,6.6,   0,  39.7 ,10.3 , 0 , 0.2}
  %  {'F7', 6.8,4.9,3.2, 54.10,21.02,9.08,-54.1,0.38}
  %  {'F8',-6.8,4.9,3.2,-54.10,21.02,9.08, 54.1,0.38}
    
    numChanGr=length(chanInds);grChans=[];
    dis=zeros(numChanGr,1);
    for l=1:num_chans
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
    grChans =[grChans [1:num_chans]'];
    grChans = sortrows(grChans,1);
    reorderedChans=grChans(:,2);
    grInd=grChans(:,1);
    for c=1:num_chans;reorderedChanLabels{c}=chanNames{grChans(c,1)};end
end

