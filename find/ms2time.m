% Author: Seydanur Tikir (seydanurtikir@gmail.com)

function time = ms2time(ms,EEGtimes)
    t=EEGtimes;
    stepSize=t(2)-t(1);
    initial=round(t(1)/stepSize);
    x1=round(ms(1)/stepSize);
    x2=round(ms(end)/stepSize);
    if length(ms)>1; time= [x1 :x2]-initial+1;
    else; time= rx+1;
    end
end

%{
    
function time = ms2time(ms)
if length(ms)>1; time= [round(ms(1)/7.8125)+1 :round(ms(end)/7.8125)+1];
else; time= round(ms/7.8125)+1;
end
end

%}