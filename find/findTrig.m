% Author: Seydanur Tikir (seydanurtikir@gmail.com)

%cases={'item1',item2',target',invalidThird',correct',catch',filler'};

function [class,classNum] = findTrig(trig)

    P1_C1 = [11, 14];  if ismember(trig,P1_C1); class = 'item1'; end
    P1_C2 = [21, 24, 61, 64]; if ismember(trig,P1_C2); class = 'item1'; end
    P1_C3 = [31, 34, 71, 74];  if ismember(trig,P1_C3); class = 'item1'; end
    P1_C4 = [41, 44, 81, 84]; if ismember(trig,P1_C4); class = 'item1'; end

    P2_C1 = [12, 15];  if ismember(trig,P2_C1); class = 'item2'; end
    P2_C2 = [22, 25, 62, 65];  if ismember(trig,P2_C2); class = 'item2'; end
    P2_C3 = [32, 35, 72, 75];  if ismember(trig,P2_C3); class = 'item2'; end
    P2_C4 = [42, 45, 82, 85]; if ismember(trig,P2_C4); class = 'item2'; end
    
    target_C1 = [13, 16];  if ismember(trig,target_C1); class = 'target'; end
    target_C2 = [23, 26]; if ismember(trig,target_C2); class = 'target'; end
    target_C3 = [33, 36];  if ismember(trig,target_C3); class = 'target'; end
    target_C4 = [43, 46];  if ismember(trig,target_C4); class = 'target'; end

    invalidThird_C2 = [92];  if ismember(trig,invalidThird_C2); class = 'invalidThird'; end
    invalidThird_C3 = [93];  if ismember(trig,invalidThird_C3); class = 'invalidThird'; end
    invalidThird_C4 = [94];  if ismember(trig,invalidThird_C4); class = 'invalidThird'; end
    
    correct_C1 = [50];  if ismember(trig,correct_C1); class = 'correct'; end
    correct_C2 = [60]; if ismember(trig,correct_C2); class = 'correct'; end
    correct_C3 = [70];  if ismember(trig,correct_C3); class = 'correct'; end
    correct_C4 = [80]; if ismember(trig,correct_C4); class = 'correct'; end
 
    catch_C1 = [53, 56]; if ismember(trig,catch_C1); class = 'catch'; end
    catch_C2 = [63, 66]; if ismember(trig,catch_C2); class = 'catch'; end
    catch_C3 = [73, 76]; if ismember(trig,catch_C3); class = 'catch'; end
    catch_C4 = [83, 86]; if ismember(trig,catch_C4); class = 'catch'; end

    
    easyFiller_C1 = [1001 1002 1003 1004]; if ismember(trig,easyFiller_C1); class = 'easyFiller'; end
    easyFiller_C2 = [2001 2002 2003 2004]; if ismember(trig,easyFiller_C2); class = 'easyFiller'; end
    easyFiller_C3 = [3001 3002 3003 3004]; if ismember(trig,easyFiller_C3); class = 'easyFiller'; end
    easyFiller_C4 = [4001 4002 4003 4004]; if ismember(trig,easyFiller_C4); class = 'easyFiller'; end

    ctrlFiller_C1 = [5]; if ismember(trig,ctrlFiller_C1); class = 'ctrlFiller'; end
    ctrlFiller_C2 = [6]; if ismember(trig,ctrlFiller_C2); class = 'ctrlFiller'; end
    ctrlFiller_C3 = [7]; if ismember(trig,ctrlFiller_C3); class = 'ctrlFiller'; end
    ctrlFiller_C4 = [8]; if ismember(trig,ctrlFiller_C4); class = 'ctrlFiller'; end

    
    wrong_C1 = [59]; if ismember(trig,wrong_C1); class = 'wrong'; end
    wrong_C2 = [69]; if ismember(trig,wrong_C2); class = 'wrong'; end
    wrong_C3 = [79]; if ismember(trig,wrong_C3); class = 'wrong'; end
    wrong_C4 = [89]; if ismember(trig,wrong_C4); class = 'wrong'; end

    miss_C1 = [57]; if ismember(trig,miss_C1); class = 'miss'; end
    miss_C2 = [67]; if ismember(trig,miss_C2); class = 'miss'; end
    miss_C3 = [77]; if ismember(trig,miss_C3); class = 'miss'; end
    miss_C4 = [87]; if ismember(trig,miss_C4); class = 'miss'; end


    early_C1 = [58]; if ismember(trig,early_C1); class = 'early'; end
    early_C2 = [68]; if ismember(trig,early_C2); class = 'early'; end
    early_C3 = [78]; if ismember(trig,early_C3); class = 'early'; end
    early_C4 = [88]; if ismember(trig,early_C4); class = 'early'; end
    
    response = [99]; if ismember(trig,response); class = 'response'; end
    
    if ismember(class,'item1'); classNum=1; 
    elseif ismember(class,'item2'); classNum=2;
    elseif ismember(class,'target'); classNum=3;
    elseif ismember(class,'invalidThird'); classNum=4;
    elseif ismember(class,'correct'); classNum=5;
    elseif ismember(class,'catch'); classNum=6;
    elseif ismember(class,'easyFiller'); classNum=7;
    elseif ismember(class,'ctrlFiller'); classNum=7;
    else classNum=444; %keep this number big. bec you run loops saying if classNum< etc. it shouldnt enter
    end
        
end
