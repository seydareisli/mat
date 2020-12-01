clear; clc; paths; 
eeglab;
load_path=['X:\Analyses',filesep,'EEGevents'];
save_path='X:\Analyses\conditionDesign\';

for i = 1:numel(group), fprintf('Group: %s\n',group{i})
    id = dir([load_path,filesep,group{i},filesep,'1*']) ;
    groupCondMatrix = zeros(size(id,1),80); %assuming 80 blocks
    for j = 1:size(id,1);  subjectID =str2num(id(j).name);
        subject_load_path = [load_path,filesep,group{i},filesep,id(j).name];      
        mergedSubjectConditions = []; mergedSubjectConditions(1) = subjectID;
        files = dir([subject_load_path,filesep,'1*.mat']); 
        if length(files)==0; continue; end
        for k=1:length(files)
        load([subject_load_path,filesep,files(k).name], 'eventType', 'eventLatency','srate');
            sessionConditions=[];
            x=[]; m=0;
            for n=1:length(eventType);try
                if eventType(n) == 101 | eventType(n) == 102 | eventType(n) == 103 | eventType(n) == 104 
                    m=m+1;
                    sessionConditions(m) = eventType(n)-100;
                end; end
            end
            mergedSubjectConditions = [mergedSubjectConditions 0 sessionConditions];
        end
        %{
        figure;scatter(1:length(mergedSubjectConditions)-1,mergedSubjectConditions(2:end),'filled');
        xlim([0 70]);ylim([0.5 10]);
        hold on; breaks=find(mergedSubjectConditions==0);
        for b=1:length(breaks)
            line([breaks(b)-1 breaks(b)-1], ylim, 'LineStyle', '--');
        end
        print('-dtiff','-r500',[save_path,'images',filesep,num2str(mergedSubjectConditions(1)),'.jpeg']);close;
%}
        groupCondMatrix(j,1:length(mergedSubjectConditions)) = mergedSubjectConditions;
    end
    if strcmp(group{i}, 'Autism')
        ASDconditionMatrix=groupCondMatrix; 
        fileID = [save_path,'ASDconditionMatrix.txt'];
        dlmwrite(fileID, ASDconditionMatrix, 'delimiter',' ','roffset', 0,'newline','pc');
    
    elseif strcmp(group{i}, 'Neurotypical')
        NTconditionMatrix=groupCondMatrix; 
        fileID = [save_path,'NTconditionMatrix.txt'];
        dlmwrite(fileID, NTconditionMatrix, 'delimiter','\t','roffset', 0,'newline','pc');        
    end 
end




% if at least 3 consecutive followed by another consecutive

numNT=size(NTconditionMatrix);numNT=numNT(1);
numASD=size(ASDconditionMatrix);numASD=numASD(1);

combins=[12; 13; 14; 21; 23; 24; 31; 32; 34; 41; 42; 43];
combinCounts=[combins];
for j=1:2; allSwitches=[]; 
if(j==1);grpCondMat=NTconditionMatrix; num=numNT; elseif(j==2);grpCondMat=ASDconditionMatrix; num=numASD; end
for k=1:num; 
    x=grpCondMat(k,:);
        for i=3:length(x)-1; 
        if ( x(i)==x(i-1) && x(i-1)==x(i-2) && x(i)~= x(i+1) && x(i+1)== x(i+2) ); 
        switchCode=x(i)*10+ x(i+1);
        allSwitches=[allSwitches switchCode];
    end; end; end
allSwitches(find(allSwitches==10|allSwitches==20|allSwitches==30|allSwitches==40))=[];
combinCounts = [combinCounts histc(allSwitches(:),combins)];
end

combinCounts(:,2)=combinCounts(:,2)/numNT*100;
combinCounts(:,3)=combinCounts(:,3)/numASD*100;
combinCounts =  [combinCounts combinCounts(:,2)-combinCounts(:,3)];
combinCounts = sortrows(combinCounts,4);
fileID = [save_path,'combinCounts.txt'];
dlmwrite(fileID, combinCounts, 'delimiter','\t','roffset', 0,'newline','pc');        
