% Author: Seydanur Tikir (seydanurtikir@gmail.com)

function myStr = findNtypeTimeRanges(x)
    lenRanges=diff([0 find([diff(x) inf]>1)]); 
    endPts=cumsum(lenRanges); startPts=endPts-lenRanges+1;
    myStr=[]; for s=1:length(startPts); myStr=[myStr num2str(time2ms(x(startPts(s)))) '-' num2str(time2ms(x(endPts(s)))) '  ']; end
end