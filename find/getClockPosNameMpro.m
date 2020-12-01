function [clockPosName] = getClockPosName(chanLabel)

if strcmp('AN1', chanLabel); clockPos = 0; centralness=0; centralnessName = 'Cz'; else
        
veryCentr  = {'CN25' 'CN2'  'CN3' 'B25' 'B2' 'AN3'  'E24'  'E23' 'E2'  'D16' 'D15' 'D2'};
centr      = {'CN27' 'CN23' 'CN7' 'B27' 'B3' 'AN19' 'E26'  'E21' 'E4'  'D27' 'D18' 'D4'};
perph      = {'CN20' 'CN14' 'B30' 'B15' 'B5' 'AN21' 'AN8'  'E20' 'E11' 'D30' 'D20' 'D6'};
veryPerph  = {'CN18' 'CN12' 'B32' 'B17' 'B7' 'AN23' 'AN10' 'E18' 'E9'  'D32' 'D22' 'D8'};


all        = {veryCentr centr perph veryPerph};

for i=1:4; for j=1:12
    if strcmp(all{i}{j}, chanLabel)
        clockPos = j;
        centralness = i;
    end
end; end

if     centralness ==1; centralnessName='veryCentr';
elseif centralness ==2; centralnessName='centr';
elseif centralness ==3; centralnessName='perph';
elseif centralness ==4; centralnessName='veryPerph';
end
end
clockPosName = ['ClockPos',num2str(clockPos),'-',centralnessName];
end