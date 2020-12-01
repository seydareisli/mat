% Author: Seydanur Tikir  Contact: seydanurtikir@gmail.com
% This is an early version of the code, come back to check updates

% Date of last update: 06.20.2020.

% p_val must be a 2D vector in the shape of numTimePts x numChan.

% There are 3 main inputs:
%   1. The 2D matrix "P", storing P values for all electrodes and time points
%   2. Your choice of significance level (alpha; e.g. 0.05)
%   3. The number consecutive time points that you want to control for 

% The code then modifies matrix P, checking for significancess for consecutive time points
% if a significant time point, isn't accompanied with consecutive time
% points, the value for that point in P stays "1" 

% if the criteria is not met, the P value for that point is made 1.1 

function [P_new] = findConsecutiveSignificances2(P,alpha,numConsecTimes,numConsecChans,chanlocs)

addpath('S:\pool\functions\');
num_chans = size(P,1);
num_timePts = size(P,2);
P_new=P;
prev=floor(numConsecTimes/2);
next=numConsecTimes-prev-1;

% Check consecutive time points
% criteria: it should be sign for all specifified consecutive time points
for ch=1:num_chans
    neighbouringChans = getClosestChanInd(chanlocs,chanlocs(ch).labels,8,chanlocs);% inputChanLabel = 'D19';
    for tp=1:num_timePts
        neighbouringTimes=[tp-prev:tp+next];
        try
            sign= P(neighbouringChans,neighbouringTimes)<alpha; 
            if sum(sum(sign))<numConsecTimes*numConsecChans
                P_new(ch, tp)=1.1;
            end
        end
    end
end


