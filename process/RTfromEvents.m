% SPLT
trigC1 =[13 16]; trigC2=[23 26]; trigC3=[33 36]; trigC4=[43 46]; 
cnd=[1; 2; 3; 4];
triggers = {trigC1,trigC2,trigC3,trigC4};
trig= [trigC1,trigC2,trigC3,trigC4];
allowedTime = 950; 

for session=1:4
    %fullfig('Border',10); hold on;
    
for i = 1:numel(group), fprintf('Group: %s\n',group{i}); 
    id = dir(['X:\Analyses',filesep,'EEGevents',filesep,group{i},filesep,'1*']) ;
    subjects=[]; RTlengths=[]; allRT=[]; 
    
for j = 1:size(id,1) ; subjectID = id(j).name; fprintf('___ID: %s\n',subjectID)
    excludeSubjects=[10595 12414 12443 10594]; %1888 11160 1190 10438 10594 12005  12328 12414 12443 12497 12562 12563 12694];
    if ismember(str2num(subjectID),excludeSubjects); continue; end

    subject_load_path = ['X:\Analyses',filesep,'EEGevents',filesep,group{i},filesep,subjectID];
    files = dir([subject_load_path,filesep,'1*.mat']); 
    if length(files)<session; continue; end    
    load([subject_load_path,filesep,files(session).name], 'eventType', 'eventLatency','srate');
    
    % FOR ALL SESSIONS (1234):
    %[eventType,eventLatency] = mergeEvents4AllSessions(subject_load_path);
    %session = 1234;
    
    clear RT avgRT corrects targets respRate subConds falsePerBlock percCorrect numBlocks 
    
    %RT and Performance stats
    [RT,avgRT,corrects,targets,respRate, subConds] = findRTfromEvents(eventType, eventLatency, triggers, allowedTime,srate);
    percCorrect=[]; for q=1:4; percCorrect= [percCorrect corrects(q)/targets(q)*100]; end; percCorrects = [percCorrects; [percCorrect str2num(subjectID) i]];
    numBlocks = round([targets(1)/32 targets(2)/24 targets(3)/16 targets(4)/8]);
    [falsePerBlock, notApplicableForSPLT ] = findFalseFromEvents(eventType, targets, corrects, cnd, numBlocks);

     
    % Exclude subject if percCorrect<90
    %if max(percCorrect<80); continue; end

    % Exclude subject if length RT <275
    %if length(RT)<275; continue; end
    
   % For remaning subjects
    subjects= [subjects str2num(subjectID)];
    RTlengths= [RTlengths length(RT)]
    %allRT=[allRT; RT(1:275)]; 
    %allRT=[allRT; RT]; 
    
    t=1:length(RT);  movm=movmean(RT,binsize,'omitnan'); % movm=movmean(RT,binsize,'omitnan');%if you don't want to see empty, use omitnan. rest is same. x axis of the peak isnt affected. 
    if(session)==1234; n=90; else; n=21; end
    
    %Curve fitting and finding its peaks
    [p,S]  = polyfit(t, movm, n); v = polyval(p, t); 
    [PosPeakVal,PosPeakInd,PosPeakWid,PosPeakProm]=findpeaks(v);
    [NegPeakVal,NegPeakInd,NegPeakWid,NegPeakProm]=findpeaks(-1*v);
    peaks = [ [PosPeakVal NegPeakVal*-1]; [PosPeakInd NegPeakInd] ; [PosPeakProm NegPeakProm] ];
    promCutOff=3; peaks(:,find(peaks(2,:)<promCutOff))=[];
    peaks = sortrows(peaks',2,'ascend');
    % degisimin cond basladiktan sonra old assume ediyorum
    % rigid behv tanimlarken RT atmali mi azalmali mi diye ayirt etmiyorum


    %Calculate Cond Beginnings
    condt = subConds; switchMat=[];  prev=0; cond_begin={}; 
    for c=1:length(condt)
        if condt(c)== prev; cond_begin{c}='0';
        else; cond_begin{c}=num2str(condt(c)); 
            switchMat=[switchMat; [prev condt(c)]];
        end; prev = condt(c);
    end; ind_cond_begin = find(str2double(cond_begin)); 
    mark_cond_begin = cond_begin(ind_cond_begin);
    
    %figure
    figure; hold on; scatter(t,movm,2,'filled'); ylim([50 750]); %xlim([1 325]);
    plot(t,v,'LineWidth',2); 
    % for each cond beginning
    for c=1:length(ind_cond_begin); xline(ind_cond_begin(c),'--k'); 
        text( ind_cond_begin(c), max(ylim)-20,['C',mark_cond_begin{c}],'Color',[2, 56, 110]/256,'FontSize',10);
        try; indNextPeaks = find( ((peaks(:,2)-ind_cond_begin(c))>-2) & ((peaks(:,2)-ind_cond_begin(c))<25));
        ii=indNextPeaks(1); myProm= floor(peaks(ii,3)); myPromInd=floor(peaks(ii,2));
        text( myPromInd-4, peaks(ii,1)+20, ['P:',num2str(myProm)],'Color','k','FontSize',8);
        peakLatency= peaks(ii,2)-ind_cond_begin(c);
        text( myPromInd-4, peaks(ii,1)+50, ['L:',num2str(peakLatency)],'Color','k','FontSize',8);
        text( max(xlim)*0.77,670, ['L : Latency'],'FontSize',8); 
        text( max(xlim)*0.77,650, ['P : Prominance'],'FontSize',8);
        text( max(xlim)*0.77,625, ['of the first peak coming'],'FontSize',8);
        text( max(xlim)*0.77,605, ['after condition beginning'],'FontSize',8);
        end
    end
    xlabel('Trials'); ylabel('Reaction Time (RT)');
    
    name=['Polyfit',num2str(n),'  Subj' ,subjectID, '  Session', num2str(session),' BinSize',num2str(binsize)]; 
    sgtitle(name); %sgtitle
    print('-dtiff','-r500',['X:\Analyses\RT\',name,'.jpeg']); close; 
end
end

end


%Subject Plots(ses2 ) with optional diff labels on it
binsizes= [10 15 20 25 30 35];%[1 5 10 15 20 25 30 35]; %[subjects; RTlengths] %colArr = jet(length(subjects));  colArr(s,:)
%for b=1:length(binsizes); binsize=binsizes(b); hold on; 
binsize =10;
%Polynomial fitting ses2
for s=1:length(subjects); 
    movm=movmean(allRT(s,:),binsize,'omitnan');
    t=1:275; p = polyfit(t, movm, 21); v = polyval(p, t); 
    figure; hold on; scatter(t,movm,3,'filled'); plot(t,v); ylim([50 750]);
    xline(81,'--k');xline(145,'--r');xline(185,'--g'); sgtitle(num2str(subjects(s)));
    %hold on; scatter(t,diff(movm)+550,6,'r','filled'); yline(550,'k');
    name=['Polyfit21 ',num2str(subjects(s)), ' binsize',num2str(binsize)]; 
    print('-dtiff','-r500',['X:\Analyses\RT\',name,'.jpeg']); close; 
end

% sort Subj/RT for nice vis. & Num2Text subjects for labeling purposes:
strSubjs={};for s=1:length(sortedSubjs);strSubjs{s}=num2str(sortedSubjs(s));end
tempSort= sortrows([avgCRT subjects'],1); sortedSubjs=tempSort(:,end); 
sortedCRT = sortrows(avgCRT,1); 

%{
% Plot sortedCRTs (y) for all subjects (x)
turq4shades = [1 66 66; 32 107 107; 103 167 167 ; 167 204 204]/255;
subplot(1,2,i); hold on; for c=1:4; for s=1:length(subjects); scatter(s, sortedCRT(s,c), 25,turq4shades(c,:) ,'filled'); end; end; 
xlim([0 1+length(subjects)]); xlabel('subjects'); ylim([150 650]); ylabel('Avg RT for each condition (C1-4)')
xticks([1:length(subjects)]); xtickangle(66); xticklabels(strSubjs); %legend({'c1','c2','c3','c4'},'Location','northwest'); 
name=['Session',num2str(session),' ',group{i}]; title(name);
name=['All Sessions ',group{i}]; title(name);
for c=1:4; scatter(1,max(ylim)-25*c,30,turq4shades(c,:),'filled'); text(1.5,max(ylim)-25*c, ['C',num2str(c)],'FontSize',7); end
%}

% Calculate an Index for Behavioral Update by Condition 
C1 = sortedCRT(:,1); C2 = sortedCRT(:,2); C3 = sortedCRT(:,3); C4 = sortedCRT(:,4);
%BI = (C2-C1)+(C3-C2)+(C4-C3); %range= max(BI)-min(BI);
Bi1 = []; Bi2 = []; Bi3 = []; 
for s=1:length(subjects); 
    Bi1 = [Bi1; (C2(s)-C1(s))/min([C2(s) C1(s)]) +  (C3(s)-C2(s))/min([C3(s) C2(s)])  +  (C4(s)-C3(s))/min([C4(s) C3(s)])] ; 
    Bi2 = [Bi2; (C2(s)-C1(s))/mean([C2(s) C1(s)])+  (C3(s)-C2(s))/mean([C3(s) C2(s)]) +  (C4(s)-C3(s))/mean([C4(s) C3(s)])]; 
    Bi3 = [Bi3; C2(s)-C1(s)  +  C3(s)-C2(s)  +  C4(s)-C3(s) ] ; 
end
% figure; hold on; plot( normalize(Bi1,'range')*100 ); plot( normalize(Bi2,'range')*100 ); hold on; plot( normalize(Bi3,'range')*100); 
indUpdateByCond =  Bi1;

% Calculate an Index for Detecting Subtle Changes 
indDetectSubtleChange=[]; c23=abs(sortedCRT(:,2)-sortedCRT(:,3)) ;  c14=abs(sortedCRT(:,1)-sortedCRT(:,4)) ;
for s=1:length(sortedSubjs); indDetectSubtleChange = [indDetectSubtleChange; c23(s) / c14(s)*100];end
    
% Record Subject RT Values for this group
save(['X:\Analyses\RT',filesep,group{i},'SubjectsRT'], 'sortedCRT', 'indUpdateByCond','indDetectSubtleChange','sortedSubjs');

end

% PRINT FOR THIS SESSION
%print('-dtiff','-r500',['X:\Analyses\RT\','All Subj RT per cond per ses',name,'.jpeg']);
% PRINT FOR ALL SESSIONS: 
%print('-dtiff','-r500',['X:\Analyses\RT\','All Subj RT per cond all ses','.jpeg']);


% Later when you want to extract subjects values and write to excel
    %for i=1:2; load(['X:\Analyses\RT',filesep,group{i},'SubjectsRT'], 'sortedCRT', 'indDetectSubtleChange','sortedSubjs');
    %writematrix([sortedSubjs sortedCRT indDetectSubtleChange],['X:\Analyses\RT',filesep,group{i},'SubjectsRT'],'Sheet',i');
    %end
    

end




