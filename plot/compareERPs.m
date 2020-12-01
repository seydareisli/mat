savePath='X:\Analyses\PaperPosterFigures\';
loadERPs; % takes 35 seconds

clear all
splt_turq4shades = [1 66 66; 32 107 107; 103 167 167 ; 167 204 204]/255;
cases={'item1','item2','target','invalidThird','correct','catch','easyFiller','ctrlFiller'};
grps = {'Neurotypical','Autism'};rejType='RejectedNoise50BrainSafety5';load('timePts_122');lenT=122; nbchan=160;
subIDs={}; subGrps={}; for i = 1:length(grps); IDs = dir(['X:\Analyses\4DmatFiles\',rejType,filesep,'noBaseline\',grps{i},'\1*']); for j = 1:size(IDs,1)
ID=IDs(j).name; subIDs = [subIDs; ID]; subGrps = [subGrps; grps{i}]; end; end %.. and ..\.. is same. be safe
b=3;baselineNames={'baseline50','baseline100','noBaseline'};baselineName=baselineNames{b};
loadPath =['X:\Analyses\4DmatFiles\',rejType,'\',baselineName,filesep];
allERPs= zeros(4,length(t),length(cases),160,length(subIDs));
for k=1:length(subIDs)
load([loadPath,subGrps{k},filesep,subIDs{k},'/avgERPs.mat']);
allERPs(:,:,:,:,k) = avgERPs;
end % allERPs(1,2,1,8,44)
outlierSubInds=[35 2 9] % 38 wa rejected earlier. to reproduce. 45
subIDs(outlierSubInds)=[]; subGrps(outlierSubInds)=[]; allERPs(:,:,:,:,outlierSubInds)=[];
% find indNT and indASD
for k=1:length(subGrps); if strcmp(subGrps{k},'Autism'); ind=k; break; end; end
indASD = [ind:length(subGrps)]; indNT = [1:ind-1]; indAll=[1:length(subGrps)];
grpInds={indNT,indASD,indAll}; grpIndNames= {'NT','ASD','All'};
PlotName = 'GFPs';
fullfig('Border',[25 0]); hold on; for cs=1:7;  mx=[];
for i=1:2;subplot(7,2,cs*2+i-2); hold on; k=grpInds{i}; for co=1:4
    g=squeeze(allERPs(co,:,cs,:,k)); gfp=[];for kk=1:length(k); gfp=[gfp; std(g(:,:,kk)')]; end; gfp=mean(gfp,1);
    plot(time2ms(1:122),gfp,'Color',splt_turq4shades(co,:),'lineWidth',1); mx=[mx max(abs(gfp))];
end; title([cases{cs},'-',grpIndNames{i}]);
end; subplot(7,2,cs*2-1);ylim([0 1]*(max(mx)+0.1));subplot(7,2,cs*2);ylim([0 1]*(max(mx)+0.1));
end; sgtitle('GFPs');

print('-dtiff','-r500',[savePath,filesep,PlotName,'.jpeg']); close;

%% Pre-calculating grpGFPs
grpGFPs=zeros(4,122,8,2);
for i=1:2; k=grpInds{i}; for cs=1:8; for co=1:4; g=squeeze(allERPs(co,:,cs,:,k)); 
gfp=[]; for kk=1:length(k); gfp=[gfp; std(g(:,:,kk)')]; end; grpGFPs(co,:,cs,i)=mean(gfp,1);
end; end; end


%take avg of ERPs for each grp
grpERPs=zeros(4,122,length(cases),160,2);
grpERPs(:,:,:,:,1) = mean(allERPs(:,:,:,:,indNT),5);
grpERPs(:,:,:,:,2) = mean(allERPs(:,:,:,:,indASD),5);


%% 
PlotName = 'Group grand mean ERPs';
ch=19;
for cs=3:3; figure; hold on; mx=[];
for i=1:2;subplot(2,1,i); hold on; k=grpInds{i};
for co=1:3
    data=squeeze(allERPs(co,:,cs,ch,k)); if size(data,2)>1; data=squeeze(mean(data,2)); end 
    plot(time2ms(1:122),data,'Color',splt_turq4shades(co,:),'lineWidth',1); mx=[mx max(abs(data))];
end; title(grpIndNames{i});
end; sgtitle(['ERP for ',cases{cs},' at chan',num2str(ch)]);
subplot(2,1,1);ylim([-1 1]*(max(mx)+0.1));subplot(2,1,2);ylim([-1 1]*(max(mx)+0.1));
end
print('-dtiff','-r500',[savePath,filesep,PlotName,'.jpeg']); close;



%% P1 calculate the peak voltage and latency for P1
intervals={[70:195] [250:500] [500:600] [600:700] [700:850] [850:949]};
in=1;
Pvolt = zeros(4,7,2); Plat = zeros(4,7,2);
for cs=1:7;for i=1:2;k=grpInds{i};for co=1:4
    g=squeeze(allERPs(co,:,cs,:,k)); gfp=[];for kk=1:length(k); gfp=[gfp; std(g(:,:,kk)')]; end; gfp=mean(gfp,1);
    peakProCutOff=150; 
    gfpP1= gfp(ms2time(intervals{in}));
    [peakValues,peakInd,peakWidths,peakProminences]=findpeaks(gfpP1); 
    peaks = [peakValues; peakInd;peakWidths;peakProminences];
    peakProCutOff = max(peakProminences)/2;
    peaks(:,find(peaks(4,:)<peakProCutOff))=[]; numPeaks=size(peaks,2);
    if numPeaks==1; Pvolt(co,cs,i)=peaks(1); Plat(co,cs,i)=time2ms(peaks(2)); else; P1V(co,cs,i)=missing; Plat(co,cs,i)=missing; fprintf('numPeaks is not 1 for cond%d grp%d case%d, Seyda \n',co,i,cs);  end;
end; end; end
P1V=Pvolt; P1lat=Plat;

%% Second Positive Peak / SPC - calculate the peak voltage and latency 
% 70 133 195 
Pvolt = zeros(4,8,2); Plat = zeros(4,8,2);
t=ms2time(200:320);
for cs=1:8;for i=1:2; k=grpInds{i};for co=1:4
    gfp=grpGFPs(co,t,cs,i);
    [peakValues,peakInd,peakWidths,peakProminences]=findpeaks(gfp); 
    peaks = [peakValues; peakInd;peakWidths;peakProminences];
    peakProCutOff = max(peakProminences)/2;
    peaks(:,find(peaks(4,:)<peakProCutOff))=[]; numPeaks=size(peaks,2);
    peaks(2,:) = peaks(2,:)+t(1) -1;
    if numPeaks==1; Pvolt(co,cs,i)=peaks(1); Plat(co,cs,i)=time2ms(peaks(2)); else; Pvolt(co,cs,i)=missing; Plat(co,cs,i)=missing; fprintf('numPeaks is not 1 for cond%d grp%d case%d, Seyda \n',co,i,cs);  end;
end; end; end
P3V=Pvolt; P3lat=Plat;


%% 
PlotName = 'P1 peak voltages -Version1';
fullfig('Border',[5 20]); hold on; 
for cs=1:7; for i=1:2; for co=1:4; scatter(cs*2+i/2+0.01*co,squeeze(P1V(co,cs,i)),'MarkerEdgeColor',splt_turq4shades(co,:), 'LineWidth',1); end; end; end
ylim([1.4 4]); xlim( [2*(0+1)-0.22-0.02 2*(7+1)-0.22+0.02 ]); sgtitle('P1 peak voltages');ylabel('microvolt');
for cs=1:7; xline(2*(cs+1)-0.22); text(2*(cs+1)-2.15,max(ylim)-0.04,cases{cs}); end
lab=[]; for cs=1:7; for i=1:2; lab=[lab cs*2+i/2+0.025]; end; end; labs= grpIndNames(1:2);  labs=[labs labs labs labs labs labs labs]; xticks(lab);xtickangle(15); xticklabels(labs); 
print('-dtiff','-r500',[savePath,filesep,PlotName,'.jpeg']); close;

%% 
PlotName = 'P1 peak voltages -Version2';
fullfig('Border',[15 20]); hold on; 
for cs=1:7; for i=1:2; for co=1:4; scatter(cs/3+i*4+0.01*co,squeeze(P1V(co,cs,i)),'MarkerEdgeColor',splt_turq4shades(co,:), 'LineWidth',1); end; end; end
ylim([1.4 3.8]);  xlim( [3.5 11]); sgtitle('P1 peak voltages');ylabel('microvolt');
text(5.3,max(ylim)-0.1,'NT');text(9.3,max(ylim)-0.1,'ASD'); 
lab=[]; for i=1:2; for cs=1:7; lab=[lab cs/3+i*4+0.025]; end; end; xticks(lab); labs= [ cases(1:7)  cases(1:7)]; xticklabels(labs); xtickangle(65)
print('-dtiff','-r500',[savePath,filesep,PlotName,'.jpeg']); close;

%calculate normalized version acc to C1 of each case
P1Vnorm=P1V; for cs=1:7; normAdd = P1Vnorm(1,cs,2)-P1Vnorm(1,cs,1);  P1Vnorm(:,cs,2)=P1Vnorm(:,cs,2)-normAdd;  end
minV = min(P1Vnorm(1,:,1)); for cs=1:7; normAdd=P1Vnorm(1,cs,2)-minV; P1Vnorm(:,cs,:)=P1Vnorm(:,cs,:)-normAdd;  end; P1Vnorm=P1Vnorm-minV;

%% 
PlotName = 'Normalized P1 peak voltages';
fullfig('Border',[5 20]); hold on; 
for cs=1:7; for i=1:2; for co=1:4; scatter(cs*2+i/2+0.01*co,squeeze(P1Vnorm(co,cs,i)),'MarkerEdgeColor',splt_turq4shades(co,:), 'LineWidth',1); end; end; end
xlim( [2*(0+1)-0.22-0.02 2*(7+1)-0.22+0.02 ]); sgtitle('Normalized P1 peak voltages'); ylabel('microvolt');
for cs=1:7; xline(2*(cs+1)-0.22); text(2*(cs+1)-2.15,max(ylim)-0.04,cases{cs}); end
lab=[]; for cs=1:7; for i=1:2; lab=[lab cs*2+i/2+0.025]; end; end; labs= grpIndNames(1:2);  labs=[labs labs labs labs labs labs labs]; xticks(lab);xtickangle(15); xticklabels(labs); 
print('-dtiff','-r500',[savePath,filesep,PlotName,'.jpeg']); close;

%% 
PlotName = 'P1 peak latencies';
fullfig('Border',[5 20]); hold on; 
for cs=1:7; for i=1:2; for co=1:4; scatter(cs*2+i/2+0.01*co,squeeze(P1lat(co,cs,i)),'MarkerEdgeColor',splt_turq4shades(co,:), 'LineWidth',1); end; end; end
xlim( [2*(0+1)-0.22-0.02 2*(7+1)-0.22+0.02 ]); sgtitle('P1 peak latencies'); ylabel('ms');
for cs=1:7; xline(2*(cs+1)-0.22); text(2*(cs+1)-2.15,max(ylim)-1,cases{cs}); end
lab=[]; for cs=1:7; for i=1:2; lab=[lab cs*2+i/2+0.025]; end; end; labs= grpIndNames(1:2);  labs=[labs labs labs labs labs labs labs]; xticks(lab);xtickangle(15); xticklabels(labs); 
print('-dtiff','-r500',[savePath,filesep,PlotName,'.jpeg']); close;



%% Scalp Maps Comparing Conditions and Groups for a time interval
%eeglab; load('chanlocs.mat'); 
intervals={[70:195] [250:500] [500:600] [600:700] [700:850] [850:949]};
cs=3;maplim=[-5 5]; in=2;
%cs=2;maplim=[-2 2]; in=6;
%cs=2;maplim=[-2 2]; in=2;
%cs=1;maplim=[-2 2]; in=1;

maplim=[-4 2]; in=3;
cs=3;
nrow=2; ncol=4; fullfig('Border',[15 27]); hold on; 
for co=1:4; col=co; for i=1:2; row=i; subplot(nrow,ncol,(row-1)*ncol+col ); try
    data=squeeze(allERPs(co,ms2time(intervals{in}),cs,:,grpInds{i})); data=mean(data,1); data=mean(data,3);
% topoplot(data,chanlocs);cbar('vert') 
 topoplot(data,chanlocs,'maplimits', maplim); cbar('vert',0,maplim); 
end; end; end; 
%Add labels on scalp maps
PlotName=['Scalp Maps for ', cases{cs}, ' at ', num2str(min(intervals{in})),'-',num2str(max(intervals{in})),'ms ' ];
for co=1:4; col=co; row=2; subplot(nrow,ncol,(row-1)*ncol+col ); text(-0.2,-0.7,['C',num2str(co)]); end; 
for i=1:2; row=i; col=1;  subplot(nrow,ncol,(row-1)*ncol+col ); text(-1,0,grpIndNames{i});end;
sgtitle(PlotName); 

print('-dtiff','-r500',[savePath,filesep,PlotName,'maplim',num2str(maplim),'.jpeg']); close;
figure; cbar('horiz',0,maplim); 
print('-dtiff','-r500',[savePath,filesep,'colorbar', num2str(maplim),'.jpeg']); close;
% topoplot(data,chanlocs);cbar('vert') 

%% Scalp Maps Comparing Time Intervals
%eeglab; load('chanlocs.mat'); 
intervals={[70:195] [250:300] [300:500] [500:600] [600:700] [700:850] [850:949]};
CdifVec=[1 2; 2 3; 3 4; 1 3; 2 4; 1 4]; CdifLabels={'C1-C2', 'C2-C3','C3-C4','C1-C3','C2-C4','C1-C4'};   % 'C1-C2-C3=C1-C3      C2-C3-C4=C2-C4     'C1-C2-C3-C4'= C1-C4
%cs=3;maplim=[-5 5]; in=2;
cs=6;maplim=[-4 4]; in=6;
%cs=1;maplim=[-2 2]; in=1;
nrow=2; ncol=5; fullfig('Border',[15 27]); hold on; 
for in=1:5; col=in; for i=1:2; row=i; subplot(nrow,ncol,(row-1)*ncol+col ); try
    data=squeeze(allERPs(co,ms2time(intervals{in}),cs,:,grpInds{i})); data=mean(data,1); data=mean(data,3);
  topoplot(data,chanlocs);cbar('vert') 
 %topoplot(data,chanlocs,'maplimits', maplim); cbar('vert',0,maplim); 
end; end; end; 
%Add labels on scalp maps
PlotName=['Scalp Maps for ', cases{cs}];
for in=1:5; col=in; row=2; subplot(nrow,ncol,(row-1)*ncol+col ); text(-0.2,-0.7,[num2str(mean(intervals{in})),'ms']); end; 
for i=1:2; row=i; col=1;  subplot(nrow,ncol,(row-1)*ncol+col ); text(-1,0,grpIndNames{i});end; 

sgtitle(PlotName); print('-dtiff','-r500',[savePath,filesep,PlotName,'maplim',num2str(maplim),'.jpeg']); 



close;

figure; cbar('horiz',0,maplim); 
print('-dtiff','-r500',[savePath,filesep,'colorbar', num2str(maplim),'.jpeg']); close;


%% Scalp Maps for cond diffr
%eeglab; load('chanlocs.mat'); 
intervals={[70:195] [250:500] [500:600] [600:700] [700:850] [850:949]};
CdifVec=[1 2; 2 3; 3 4; 1 3; 2 4; 1 4]; CdifLabels={'C1-C2', 'C2-C3','C3-C4','C1-C3','C2-C4','C1-C4'};   % 'C1-C2-C3=C1-C3      C2-C3-C4=C2-C4     'C1-C2-C3-C4'= C1-C4
%cs=3;maplim=[-2 2]; in=2;
cs=2;maplim=[-2 2]; in=6;
nrow=2; ncol=6; fullfig('Border',[15 27]); hold on; 
for cd=1:6; col=cd; for i=1:2; row=i; subplot(nrow,ncol,(row-1)*ncol+col ); try
    data1=squeeze(allERPs(CdifVec(cd,2),ms2time(intervals{in}),cs,:,grpInds{i})); data1=mean(data1,1); data1=mean(data1,3);
    data2=squeeze(allERPs(CdifVec(cd,1),ms2time(intervals{in}),cs,:,grpInds{i})); data2=mean(data2,1); data2=mean(data2,3);
    data=data1-data2;
%topoplot(data,chanlocs);cbar('vert') 
 topoplot(data,chanlocs,'maplimits', maplim); %cbar('vert',0,maplim); 
end; end; end; 
%Add labels on scalp maps
PlotName=['Scalp Difference Maps for ', cases{cs}, ' at ', num2str(min(intervals{in})),'-',num2str(max(intervals{in})),'ms ' ];
for cd=1:6; col=cd; row=2; subplot(nrow,ncol,(row-1)*ncol+col ); text(-0.2,-0.7,CdifLabels{cd});end; 
for i=1:2; row=i; col=1;  subplot(nrow,ncol,(row-1)*ncol+col ); text(-1,0,grpIndNames{i});end; 
%subplot(nrow,ncol,ncol);  text(0.3,-0.6,['red:   ', num2str(maplim(2)),' uV']); text(0.3,-0.75,['green:0 uV']); text(0.3,-0.9,['blue: ', num2str(maplim(1)),' uV']);
sgtitle(PlotName); print('-dtiff','-r500',[savePath,filesep,PlotName,'maplim',num2str(maplim),'.jpeg']); close;
figure; cbar('horiz',0,maplim); print('-dtiff','-r500',[savePath,filesep,'colorbar', num2str(maplim),'.jpeg']); close;


%% Scalp Maps for CASE differences  (item3-item2)
%eeglab; load('chanlocs.mat'); 
intervals={[70:195] [250:500] [500:600] [600:700] [750:949] [700:850] [850:949] [1:949]};
maplim=[-5 2];
cs1= 6;  cs2= 3; in=2; 
nrow=2; ncol=4; fullfig('Border',[15 27]); hold on; 
for co=1:4; col=co; for i=1:2; row=i; subplot(nrow,ncol,(row-1)*ncol+col ); try
    data1=squeeze(allERPs(co,ms2time(intervals{in}),cs1,:,grpInds{i})); 
    data2=squeeze(allERPs(co,ms2time(intervals{in}),cs2,:,grpInds{i})); 
    data4map=mean(mean(data1,1),3)-mean(mean(data2,1),3);
    data4erp=mean(data1(:,ch,:),3)-mean(data2(:,ch,:),3);
topoplot(data4map,chanlocs);cbar('vert') 
%topoplot(data4map,chanlocs,'maplimits', maplim); cbar('vert',0,maplim); 
 %plot(time2ms(1:122),data4erp,'Color',splt_turq4shades(co,:),'lineWidth',1); mx=[mx max(abs(data))];

end; end; end; 
%Add labels on scalp maps
PlotName=['Scalp Difference Maps for ', cases{cs1},'-',cases{cs2}, ' at ', num2str(min(intervals{in})),'-',num2str(max(intervals{in})),'ms ' ];
for co=1:4; col=co; row=2; subplot(nrow,ncol,(row-1)*ncol+col ); text(-0.2,-0.7,['C',num2str(co)]);end; 
for i=1:2; row=i; col=1;  subplot(nrow,ncol,(row-1)*ncol+col ); text(-1,0,grpIndNames{i});end; 
sgtitle(PlotName);


%subplot(nrow,ncol,ncol);  text(0.3,-0.6,['red:   ', num2str(maplim(2)),' uV']); text(0.3,-0.75,['green:0 uV']); text(0.3,-0.9,['blue: ', num2str(maplim(1)),' uV']);

print('-dtiff','-r500',[savePath,filesep,PlotName,'maplim',num2str(maplim),'.jpeg']); close;
figure; cbar('horiz',0,maplim); print('-dtiff','-r500',[savePath,filesep,'colorbar', num2str(maplim),'.jpeg']); close;



%% 
PlotName = 'Scalp Maps at P1 peak';
maplim=[-2 2]; numcs=3; fullfig('Border',[15 18]); hold on; 
for i=1:2; for cs=1:numcs; for co=1:4; subplot(numcs,9,(cs-1)*9+(i-1)*5+co);
peakTime=ms2time(P1lat(co,cs,i)); interval = [peakTime-3 : peakTime+3];
try; data=squeeze(allERPs(co,interval,cs,:,grpInds{i})); data=mean(data,1); data=mean(data,3);
 topoplot(data,chanlocs,'maplimits', maplim); %cbar('vert',0,maplim); 
end; end; end; end
%Add labels on scalp maps
sgtitle(['Scalp Maps at P1 peak'])
for co=1:4; for i=1:2; subplot(numcs,9,(numcs-1)*9+co+(i-1)*5); hold on; text(-0.15,-0.8,['C',num2str(co)]);end; end
for cs=1:numcs; subplot(numcs,9,(cs-1)*9+1); hold on; text(-1,0.6,cases{cs});end
subplot(numcs,9,2); text(0.5,0.7,'NT'); subplot(numcs,9,7); text(0.5,0.7,'ASD');
print('-dtiff','-r500',[savePath,filesep,PlotName,'.jpeg']); close;
figure; cbar('horiz',0,maplim); print('-dtiff','-r500',[savePath,filesep,'colorbar', num2str(maplim),'.jpeg']); close;


%% 

%NT does not hvae invalid third C one condition, and catch one condition
%numPeaks is not 1 for cond4 grp1 case4, Seyda 
%numPeaks is not 1 for cond3 grp2 case5, Seyda 
%numPeaks is not 1 for cond1 grp1 case6, Seyda 


%% GFP asd vs nt
fullfig('Border',[25 0]); hold on; cs =3;  mx=[];
for i=1:2; subplot(2,1,i); hold on; for co=1:4; gfp=grpGFPs(co,:,cs,i); 
    plot(time2ms(1:122),gfp,'Color',splt_turq4shades(co,:),'lineWidth',1); mx=[mx max(abs(gfp))];
end; title([cases{cs},'-',grpIndNames{i}]); end; 



% pre-calculate 'area' under curve for 1.all 2.P1 3.P3 4.P5 5.P7 6.P9 
intervals={[70:195] [250:500] [500:600] [600:700] [700:850] [850:949]};
area=zeros(4,8,2,length(intervals)); for cs=1:8; for i=1:2; for co=1:4; for in=1:length(intervals)
gfp= grpGFPs(co,ms2time(intervals{in}),cs,i);
area(co,cs,i,in) = sum(gfp); end; end; end; end

% pre-calculate condition index 'ci' 
CdifVec=[1 2; 2 3; 3 4; 1 3; 2 4; 1 4];
CdifLabels={'C1-C2', 'C2-C3','C3-C4','C1-C3','C2-C4','C1-C4'};   % 'C1-C2-C3=C1-C3      C2-C3-C4=C2-C4     'C1-C2-C3-C4'= C1-C4
ci=zeros(length(CdifVec),8,2,122);
for cd=1:length(CdifVec); for cs=1:8; for i=1:2; ci(cd,cs,i,:)= grpGFPs(CdifVec(cd,2),:,cs,i)-grpGFPs(CdifVec(cd,1),:,cs,i);end;end;end


% are under curve
sum_ci=sum(ci(:,:,:,:),4);  sum_ci_nt_asd=squeeze(sum_ci(:,:,1))-squeeze(sum_ci(:,:,2));
%plot are under curve and condition indexes
cs=3; fullfig('border',[25,5]); hold on; 
for cd=1:3; for i=1:2
subplot(3,1,cd); hold on; plot(time2ms(1:122),squeeze(ci(cd,cs,i,:))); 
end; title(CdifLabels{cd}); text(20,max(ylim),['NT-ASD= ',num2str(round(sum_ci_nt_asd(cd,cs)))],'fontsize',8); end; sgtitle('Condition Indexes');


% 1plot GFPs all cases compare groups 
figure; hold on;  mx=[]; p=0; for cs=1:8;  col={'k','r'};
p=p+1; subplot(4,2,p); hold on; for i=1:2;
    gfp=grpGFPs(co,:,cs,i); plot(time2ms(1:122),gfp,'Color',col{i},'lineWidth',1); mx=[mx max(abs(gfp))];
end; title([cases{cs},'-','GFP']);
end

% 1 plot GFPs item 1 vs 2 vs 3
figure; hold on; mx=[]; for i=1:2; k=grpInds{i}; subplot(2,1,i); hold on;  col={'k','r'};
for cs=1:3; gfp=grpGFPs(co,:,cs,i);
    plot(time2ms(1:122),gfp,'Color','k','lineWidth',cs/2); mx=[mx max(abs(gfp))];
end; title([grpIndNames{i}]);
end; sgtitle(['item 1 vs 2 vs 3']);

% 1 plot GFPs target vs inv 3rd
figure; hold on; mx=[]; for i=1:2; k=grpInds{i}; subplot(2,1,i); hold on;  col={'k','r'};
for cs=3:4; gfp=grpGFPs(co,:,cs,i);
    plot(time2ms(1:122),gfp,'Color','k','lineWidth',cs/2); mx=[mx max(abs(gfp))];
end; title([grpIndNames{i}]);
end; sgtitle(['target vs inv 3rd']);

% 1 plot GFPs catch vs filler
figure; hold on; mx=[]; for i=1:2; k=grpInds{i}; subplot(2,1,i); hold on;  col={'k','r'};
for cs=6:7; gfp=grpGFPs(co,:,cs,i);
    plot(time2ms(1:122),gfp,'Color','k','lineWidth',cs/3); mx=[mx max(abs(gfp))];
end; title([grpIndNames{i}]);
end; sgtitle(['GFPs catch vs filler']);
subplot(2,1,1);ylim([0 1]*(max(mx)+0.1));subplot(2,1,2);ylim([0 1]*(max(mx)+0.1));

% 1 plot GFPs correct vs filler
figure; hold on; mx=[]; for i=1:2; k=grpInds{i}; subplot(2,1,i); hold on;  col={'k','r'};
for cs=[5 7]; gfp=grpGFPs(co,:,cs,i);
    plot(time2ms(1:122),gfp,'Color','k','lineWidth',cs/3); mx=[mx max(abs(gfp))];
end; title([grpIndNames{i}]);
end; sgtitle(['GFPs catch vs filler']);
subplot(2,1,1);ylim([0 1]*(max(mx)+0.1));subplot(2,1,2);ylim([0 1]*(max(mx)+0.1));


% 1 plot GFPs item1 vs target 
figure; hold on; mx=[]; for i=1:2; k=grpInds{i}; subplot(2,1,i); hold on;  col={'k','r'};
for cs=[1 3]; gfp=grpGFPs(co,:,cs,i);
    plot(time2ms(1:122),gfp,'Color','k','lineWidth',cs/3); mx=[mx max(abs(gfp))];
end; title([grpIndNames{i}]);
end; sgtitle(['GFPs item1 vs target']);
subplot(2,1,1);ylim([0 1]*(max(mx)+0.1));subplot(2,1,2);ylim([0 1]*(max(mx)+0.1));



subplot(length(sbjcts),19,m+(k-sbjcts(1))*19); topoplot(vector,chanlocs,'maplimits',maplim); 
if k==sbjcts(1); title([num2str(times(m)),' ms']);end %cbar('vert',0,maplim); 


ch=19;
for k=1:14
figure; hold on; 
for co=1:4
    data=squeeze(allERPs(co,:,cs,ch,k)); %grpInds{i}
    %vector=squeeze(mean(data,1)); 
    plot(1:122,data,'Color',splt_turq4shades(co,:),'lineWidth',1); 
end;pause(3); close
end