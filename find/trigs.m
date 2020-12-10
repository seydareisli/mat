% Author: Seydanur Tikir (seydanurtikir@gmail.com)

% Function for finding trigger codes for a particular type of trial
% Input: trial type. 
% Output: trigger codes defining that trial type.

% Examples for usage:
%   trigs('target') will return all tirgger codes for target(allconditions)
%   trigs('target_C1') will return trigger codes for target Condition 1
%   trig('item1') will return

% Types of trials that can be entered as input:
%   'item1','item2','target','invalidThird','correct','catch','easyFiller'
% If you want them for a particular probability condition, add condition to
% the end (e.g.  item1_C1, item1_C2, item1_C3, item1_C4)

% For questions, contact seydanurtikir@gmail.com

% P.S. I made sure that we got all events comparing a and b
%       ev=[]; for e=1:length(EEG.event); ev=[ev str2num(EEG.event(e).type)];end
%       a=sort(unique(ev));
%       b=sort(cell2mat(trigger_codes));
%
%P.S. What is 127? check that out
%cases={'item1','item2','target','invalidThird','correct','catch','easyFiller','ctrlFiller'};
%cases={'unatt_std','unatt_pitch','unatt_soa','att_std','att_pitch','att_soa'};

function trigger_codes = trigs(trigType)

if strcmp(trigType,'L1'); trigger_codes = 1; end
if strcmp(trigType,'L2'); trigger_codes = 2; end
if strcmp(trigType,'L3'); trigger_codes = 3; end
if strcmp(trigType,'L4'); trigger_codes = 4; end
if strcmp(trigType,'L5'); trigger_codes = 5; end
if strcmp(trigType,'L6'); trigger_codes = 6; end
if strcmp(trigType,'L7'); trigger_codes = 7; end
if strcmp(trigType,'L8'); trigger_codes = 8; end

if strcmp(trigType,'P1'); trigger_codes = 91; end
if strcmp(trigType,'P2'); trigger_codes = 92; end
if strcmp(trigType,'P3'); trigger_codes = 93; end
if strcmp(trigType,'P4'); trigger_codes = 94; end
if strcmp(trigType,'P5'); trigger_codes = 95; end
if strcmp(trigType,'P6'); trigger_codes = 96; end
if strcmp(trigType,'P7'); trigger_codes = 97; end
if strcmp(trigType,'P8'); trigger_codes = 98; end



unatt_C1_std = [10,50]; if strcmp(trigType,'unatt_C1_std'); trigger_codes = unatt_C1_std; end
unatt_C1_pitch = [12,52]; if strcmp(trigType,'unatt_C1_pitch'); trigger_codes = unatt_C1_pitch; end
unatt_C1_soa = [11,51]; if strcmp(trigType,'unatt_C1_soa'); trigger_codes = unatt_C1_soa; end

unatt_C2_std = [20,60]; if strcmp(trigType,'unatt_C2_std'); trigger_codes = unatt_C2_std; end
unatt_C2_pitch = [22,62]; if strcmp(trigType,'unatt_C2_pitch'); trigger_codes = unatt_C2_pitch; end
unatt_C2_soa = [21,61]; if strcmp(trigType,'unatt_C2_soa'); trigger_codes = unatt_C2_soa; end

unatt_C3_std = [30,70]; if strcmp(trigType,'unatt_C3_std'); trigger_codes = unatt_C3_std; end
unatt_C3_pitch = [32,72]; if strcmp(trigType,'unatt_C3_pitch'); trigger_codes = unatt_C3_pitch; end
unatt_C3_soa = [31,51]; if strcmp(trigType,'unatt_C3_soa'); trigger_codes = unatt_C3_soa; end

att_C1_std = [14,54]; if strcmp(trigType,'att_C1_std'); trigger_codes = att_C1_std; end
att_C1_pitch = [16,56]; if strcmp(trigType,'att_C1_pitch'); trigger_codes = att_C1_pitch; end
att_C1_soa = [15,55]; if strcmp(trigType,'att_C1_soa'); trigger_codes = att_C1_soa; end

att_C2_std = [24,64]; if strcmp(trigType,'att_C2_std'); trigger_codes = att_C2_std; end
att_C2_pitch = [26,66]; if strcmp(trigType,'att_C2_pitch'); trigger_codes = att_C2_pitch; end
att_C2_soa = [25,65]; if strcmp(trigType,'att_C2_soa'); trigger_codes = att_C2_soa; end

att_C3_std = [34,74]; if strcmp(trigType,'att_C3_std'); trigger_codes = att_C3_std; end
att_C3_pitch = [36,76]; if strcmp(trigType,'att_C3_pitch'); trigger_codes = att_C3_pitch; end
att_C3_soa = [35,75]; if strcmp(trigType,'att_C3_soa'); trigger_codes = att_C3_soa; end

if strcmp(trigType,'unatt_std'); trigger_codes = [unatt_C1_std; unatt_C2_std; unatt_C3_std]; end
if strcmp(trigType,'unatt_soa'); trigger_codes = [unatt_C1_soa; unatt_C2_soa; unatt_C3_soa]; end
if strcmp(trigType,'unatt_pitch'); trigger_codes = [unatt_C1_pitch; unatt_C2_pitch; unatt_C3_pitch]; end
if strcmp(trigType,'att_std'); trigger_codes = [att_C1_std; att_C2_std; att_C3_std]; end
if strcmp(trigType,'att_soa'); trigger_codes = [att_C1_soa; att_C2_soa; att_C3_soa]; end
if strcmp(trigType,'att_pitch'); trigger_codes = [ att_C1_pitch; att_C2_pitch; att_C3_pitch]; end



  %  trig_P1_C1 = [11, 14];  if strcmp(trigType,'P1_C1'); trigger_codes = trig_P1_C1; end
    trig_P1_C1 = [11, 14, 11, 14];  if strcmp(trigType,'P1_C1'); trigger_codes = trig_P1_C1; end
    trig_P1_C2 = [21, 24, 61, 64]; if strcmp(trigType,'P1_C2'); trigger_codes = trig_P1_C2; end
    trig_P1_C3 = [31, 34, 71, 74];  if strcmp(trigType,'P1_C3'); trigger_codes = trig_P1_C3; end
    trig_P1_C4 = [41, 44, 81, 84]; if strcmp(trigType,'P1_C4'); trigger_codes = trig_P1_C4; end
     
   % trig_P2_C1 = [12, 15];  if strcmp(trigType,'P2_C1'); trigger_codes = trig_P2_C1; end
    trig_P2_C1 = [12, 15, 12, 15];  if strcmp(trigType,'P2_C1'); trigger_codes = trig_P2_C1; end
    trig_P2_C2 = [22, 25, 62, 65];  if strcmp(trigType,'P2_C2'); trigger_codes = trig_P2_C2; end
    trig_P2_C3 = [32, 35, 72, 75];  if strcmp(trigType,'P2_C3'); trigger_codes = trig_P2_C3; end
    trig_P2_C4 = [42, 45, 82, 85]; if strcmp(trigType,'P2_C4'); trigger_codes = trig_P2_C4; end
    
    trig_target_C1 = [13, 16];  if strcmp(trigType,'target_C1'); trigger_codes = trig_target_C1; end
    trig_target_C2 = [23, 26]; if strcmp(trigType,'target_C2'); trigger_codes = trig_target_C2; end
    trig_target_C3 = [33, 36];  if strcmp(trigType,'target_C3'); trigger_codes = trig_target_C3; end
    trig_target_C4 = [43, 46];  if strcmp(trigType,'target_C4'); trigger_codes = trig_target_C4; end

    % there is actually no trig_invalidThird_C1! This is only for looping
    trig_invalidThird_C1 = [92];  if strcmp(trigType,'invalidThird_C1'); trigger_codes = trig_invalidThird_C1; end
    trig_invalidThird_C2 = [92];  if strcmp(trigType,'invalidThird_C2'); trigger_codes = trig_invalidThird_C2; end
    trig_invalidThird_C3 = [93];  if strcmp(trigType,'invalidThird_C3'); trigger_codes = trig_invalidThird_C3; end
    trig_invalidThird_C4 = [94];  if strcmp(trigType,'invalidThird_C4'); trigger_codes = trig_invalidThird_C4; end
    
    trig_correct_C1 = [50];  if strcmp(trigType,'correct_C1'); trigger_codes = trig_correct_C1; end
    trig_correct_C2 = [60]; if strcmp(trigType,'correct_C2'); trigger_codes = trig_correct_C2; end
    trig_correct_C3 = [70];  if strcmp(trigType,'correct_C3'); trigger_codes = trig_correct_C3; end
    trig_correct_C4 = [80]; if strcmp(trigType,'correct_C4'); trigger_codes = trig_correct_C4; end
    
    trig_wrong_C1 = [59]; if strcmp(trigType,'wrong_C1'); trigger_codes = trig_wrong_C1; end
    trig_wrong_C2 = [69]; if strcmp(trigType,'wrong_C2'); trigger_codes = trig_wrong_C2; end
    trig_wrong_C3 = [79]; if strcmp(trigType,'wrong_C3'); trigger_codes = trig_wrong_C3; end
    trig_wrong_C4 = [89]; if strcmp(trigType,'wrong_C4'); trigger_codes = trig_wrong_C4; end

    trig_miss_C1 = [57]; if strcmp(trigType,'miss_C1'); trigger_codes = trig_miss_C1; end
    trig_miss_C2 = [67]; if strcmp(trigType,'miss_C2'); trigger_codes = trig_miss_C2; end
    trig_miss_C3 = [77]; if strcmp(trigType,'miss_C3'); trigger_codes = trig_miss_C3; end
    trig_miss_C4 = [87]; if strcmp(trigType,'miss_C4'); trigger_codes = trig_miss_C4; end

    trig_catch_C1 = [53, 56]; if strcmp(trigType,'catch_C1'); trigger_codes = trig_catch_C1; end
    trig_catch_C2 = [63, 66]; if strcmp(trigType,'catch_C2'); trigger_codes = trig_catch_C2; end
    trig_catch_C3 = [73, 76]; if strcmp(trigType,'catch_C3'); trigger_codes = trig_catch_C3; end
    trig_catch_C4 = [83, 86]; if strcmp(trigType,'catch_C4'); trigger_codes = trig_catch_C4; end

    trig_early_C1 = [58]; if strcmp(trigType,'early_C1'); trigger_codes = trig_early_C1; end
    trig_early_C2 = [68]; if strcmp(trigType,'early_C2'); trigger_codes = trig_early_C2; end
    trig_early_C3 = [78]; if strcmp(trigType,'early_C3'); trigger_codes = trig_early_C3; end
    trig_early_C4 = [88]; if strcmp(trigType,'early_C4'); trigger_codes = trig_early_C4; end
    
    %add 1000*c for fillers    
    trig_easyFiller_C1 = [1001 1002 1003 1004]; if strcmp(trigType,'easyFiller_C1'); trigger_codes = trig_easyFiller_C1; end
    trig_easyFiller_C2 = [2001 2002 2003 2004]; if strcmp(trigType,'easyFiller_C2'); trigger_codes = trig_easyFiller_C1; end
    trig_easyFiller_C3 = [3001 3002 3003 3004]; if strcmp(trigType,'easyFiller_C3'); trigger_codes = trig_easyFiller_C1; end
    trig_easyFiller_C4 = [4001 4002 4003 4004]; if strcmp(trigType,'easyFiller_C4'); trigger_codes = trig_easyFiller_C1; end

    trig_ctrlFiller_C1 = [5]; if strcmp(trigType,'ctrlFiller_C1'); trigger_codes = trig_ctrlFiller_C1; end
    trig_ctrlFiller_C2 = [6]; if strcmp(trigType,'ctrlFiller_C2'); trigger_codes = trig_ctrlFiller_C2; end
    trig_ctrlFiller_C3 = [7]; if strcmp(trigType,'ctrlFiller_C3'); trigger_codes = trig_ctrlFiller_C3; end
    trig_ctrlFiller_C4 = [8]; if strcmp(trigType,'ctrlFiller_C4'); trigger_codes = trig_ctrlFiller_C4; end

if strcmp(trigType,'easyFiller')  
    trigger_codes = [trig_easyFiller_C1;trig_easyFiller_C2;trig_easyFiller_C3;trig_easyFiller_C4];
    trigger_names = ['easyFiller_C1';'easyFiller_C1';'easyFiller_C1';'easyFiller_C1'];
end

if strcmp(trigType,'ctrlFiller')  
    trigger_codes = [trig_ctrlFiller_C1;trig_ctrlFiller_C2;trig_ctrlFiller_C3;trig_ctrlFiller_C4];
    trigger_names = ['ctrlFiller_C1';'ctrlFiller_C2';'ctrlFiller_C3';'ctrlFiller_C4'];
end

if strcmp(trigType,'target')
    trigger_codes = [trig_target_C1;trig_target_C2;trig_target_C3;trig_target_C4];
    trigger_names = ['target_C1';'target_C2';'target_C3';'target_C4'];
end

if strcmp(trigType,'invalidThird') %early days, this was 93 96 rather than 92 93 94
    trigger_codes = [trig_invalidThird_C1; trig_invalidThird_C2;trig_invalidThird_C3;trig_invalidThird_C4];
    trigger_names = ['invalidThird_C1';'invalidThird_C2';'invalidThird_C3';'invalidThird_C4'];
end

if strcmp(trigType,'correct')
     trigger_codes = [trig_correct_C1;trig_correct_C2;trig_correct_C3;trig_correct_C4];
    trigger_names = ['correct_C1';'correct_C2';'correct_C3';'correct_C4'];
end

if strcmp(trigType, 'catch')
    trigger_codes= [trig_catch_C1;trig_catch_C2;trig_catch_C3;trig_catch_C4];
    trigger_names= ['catch_C1';'catch_C2';'catch_C3';'catch_C4'];
end
if strcmp(trigType ,'miss')
    trigger_codes= [trig_miss_C1; trig_miss_C2; trig_miss_C3;trig_miss_C4];
    trigger_names= ['miss_C1'; 'miss_C1'; 'miss_C1';'miss_C1'];
end

if strcmp(trigType ,'item2')
    trigger_codes = [trig_P2_C1;trig_P2_C2;trig_P2_C3;trig_P2_C4];
    trigger_names = ['P2_C1';'P2_C2';'P2_C3';'P2_C4'];   
end
if strcmp(trigType ,'item1')
    trigger_codes = [trig_P1_C1;trig_P1_C2;trig_P1_C3;trig_P1_C4];
    trigger_names = ['P1_C1';'P1_C2';'P1_C3';'P1_C4'];
end

if strcmp(trigType ,'wrong')
     trigger_codes= [trig_wrong_C1;trig_wrong_C2;trig_wrong_C3;trig_wrong_C4];
    trigger_names= ['wrong_C1';'wrong_C2';'wrong_C3';'wrong_C4'];
end

if strcmp(trigType ,'early')
    trigger_codes= [trig_early_C1;trig_early_C2;trig_early_C3;trig_early_C4];
    trigger_names= ['early_C1';'early_C2';'early_C3';'early_C4'];
end

if strcmp(trigType ,'response')
trig_response = [99];
end

if strcmp(trigType ,'breaks')
    trig_breaks = [ 101,102,103,104];
end

if strcmp(trigType ,'feedback')
    trigger_codes= [trig_hits; trig_miss; trig_early;trig_wrong];
    trigger_names= ['hits'; 'miss'; 'early';'wrong'];
end

if strcmp(trigType ,'all_codes')
    
    trigger_codes = [11, 14, 21, 24, 61, 64, 31, 34, 71, 74 41, 44, 81, 84, 12, 15, 22, 25, 62, 65, 32, 35, 72, 75, 42, 45, 82, 85,...
 13, 16, 23, 26, 33, 36, 43, 46, 92, 93, 94, 50, 60, 70, 80, 59, 69, 79, 89, 57, 67, 77, 87, 53, 56, 63, 66, 73, 76, 83, 86, 58, 68, 78, 88,...
 1, 2, 3, 4, 5, 6, 7, 8, 99, 101, 102, 103, 104];

    allStimuli = [11, 14, 21, 24, 61, 64, 31, 34, 71, 74 41, 44, 81, 84, 12, 15, 22, 25, 62, 65, 32, 35, 72, 75, 42, 45, 82, 85,...
 13, 16, 23, 26, 33, 36, 43, 46, 92, 93, 94, 50, 60, 70, 80, 59, 69, 79, 89, 57, 67, 77, 87, 53, 56, 63, 66, 73, 76, 83, 86, 58, 68, 78, 88,...
 1, 2, 3, 4, 5, 6, 7, 8];

trigger_names = ['11', '14', '21', '24', '61', '64', '31', '34', '71', '74', '41', '44', '81', '84', '12', '15', '22', '25', '62', '65', '32', '35', '72', '75', '42', '45', '82', '85',...
        '13', '16',   '23', '26', '33', '36', '43', '46', '92', '93', '94', '50', '60', '70', '80', '59', '69', '79', '89', '57', '67', '77', '87', '53', '56', '63', '66', '73', '76', '83', '86', '58', '68', '78', '88', ...
        '1', '2', '3', '4', '5', '6', '7', '8', '99', '101', '102', '103' '104'];
end


end

