% Author: Seydanur Tikir (seydanurtikir@gmail.com)

%searches for the closest chans to your chan within 160 cap
% its ok to use 64 chan as an input and it will find the closest ones
% within 160 cap. 

% inputChanLabel = 'D19' ;
% chanlocs_input= EEG32.chanlocs;
% chanlocs_search= EEG160.chanlocs;

%loading DURING TESTS
%EEG160 = pop_loadset('S:\pool\EEG160-do-not-delete.set');
%chan160locs = pop_chanedit(chanlocs, 'load',{ 'BioSemi160.sfp', 'filetype', 'autodetect'});
% EEG =  pop_loadset('tinyEEG_2chanSubset1.set'); ;
%load('S:\pool\chanlocs.mat','chanlocs'); chan160locs = chanlocs;

function [closestChanInd] = getClosestChanInd(chanlocs_input,inputChanLabel,numChans2return,chanlocs_search)

%search for the name of your chan in all names 
% chan label  that channel label in chanlocs_search. find its X1 Y1 Z1 coordinates. 
for l=1:length(chanlocs_search); label=chanlocs_search(l).labels; 
    if strcmp(label,inputChanLabel)
    X1 =chanlocs_search(l).X ; Y1=chanlocs_search(l).Y; Z1=chanlocs_search(l).Z; end
end
% you found X1 Y1 Z1 for your chan!

%loop thrU chans of INPUT EEG and their distance to X1 Y1 Z1
for c=1:length(chanlocs_input)
    X= chanlocs_input(c).X; Y=chanlocs_input(c).Y; Z=chanlocs_input(c).Z; 
    dis(c)=((X1-X)^2+(Y1-Y)^2+(Z1-Z)^2)^0.5; 
end

%find the closest one within the distance matrix
[temp,I]=sort(dis); I(1)=[];
closestChanInd = I(1:numChans2return);

end
            
