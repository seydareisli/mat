function time = ms2time(ms)
if length(ms)>1; time= [round(ms(1)/7.8125)+1 :round(ms(end)/7.8125)+1];
else; time= round(ms/7.8125)+1;
end
end
