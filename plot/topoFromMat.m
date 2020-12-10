% Author: Seydanur Tikir (seydanurtikir@gmail.com)

addpath(genpath('/Users/Albert/Desktop/mat/'));addpath('/Users/Albert/Desktop/eeglab/');
%eeglab; close; clear; clc;
file_name = 'SPLT-allERPs.mat';
file_path = '/Users/Albert/Desktop/data/';
%load([file_path,file_name]); clear file_name file_path;
%load('/Users/Albert/Desktop/mat/data/chanlocs.mat'); 

%topoplot(data,chanlocs,'maplimits', maplim); %cbar('vert',0,maplim); 
%Add labels on scalp maps
%PlotName=['Scalp Difference Maps for ', cases{cs}, ' at ', num2str(min(intervals{in})),'-',num2str(max(intervals{in})),'ms ' ];
grps = {'Neurotypical','Autism'};
splt_turq4shades = [1 66 66; 32 107 107; 103 167 167 ; 167 204 204]/255;
cases={'item1','item2','target','invalidThird','correct','catch','easyFiller','ctrlFiller'};
% find indNT and indASD
for k=1:length(subGrps); if strcmp(subGrps{k},'Autism'); ind=k; break; end; end
indASD = [ind:length(subGrps)]; indNT = [1:ind-1]; indAll=[1:length(subGrps)];
grpInds={indNT,indASD,indAll}; grpIndNames= {'NT','ASD','All'};

%for cd=1:6; col=cd; row=2; subplot(nrow,ncol,(row-1)*ncol+col ); text(-0.2,-0.7,CdifLabels{cd});end; 
%for i=1:2; row=i; col=1;  subplot(nrow,ncol,(row-1)*ncol+col ); text(-1,0,grpIndNames{i});end; 
%subplot(nrow,ncol,ncol);  text(0.3,-0.6,['red:   ', num2str(maplim(2)),' uV']); text(0.3,-0.75,['green:0 uV']); text(0.3,-0.9,['blue: ', num2str(maplim(1)),' uV']);
%sgtitle(PlotName); print('-dtiff','-r500',[savePath,filesep,PlotName,'maplim',num2str(maplim),'.jpeg']); close;
%figure; cbar('horiz',0,maplim); print('-dtiff','-r500',[savePath,filesep,'colorbar', num2str(maplim),'.jpeg']); close;

intervals={[100:125] [125:150] [150:200] [200:250] [250:300] [300:350] [350:400] [400:500] [500:600] [600:700] [700:800]};
cs=3;maplim=[-5 5]; in=2;
%cs=2;maplim=[-2 2]; in=6;
%cs=2;maplim=[-2 2]; in=2;
%cs=1;maplim=[-2 2]; in=1;

maplim=[-2 4]; in=3;
cs=1; co=1:4; i=1;
nrow=3; ncol=11; 
fullfig('Border',[15 27]); hold on; 
%for in=1:ncol; col=in; for i=1:2; row=i; subplot(nrow,ncol,(row-1)*ncol+col ); try
for in=1:ncol; col=in; 
    try
    data=squeeze(allERPs(co,ms2time(intervals{in}),cs,:,grpInds{i})); %data=mean(data,1); data=mean(data,3);
    data=squeeze(mean(data,2));
    c1=data(1,:,:); c2=data(2,:,:); c3=data(3,:,:); c4=data(4,:,:); 
    %data=c2-c1 + c3-c2 + c4-c3;
    data=c3-c1;
    %data=c2;
    data=mean(data,3);
    % topoplot(data,chanlocs);cbar('vert') 
	subplot(nrow,ncol,(1-1)*ncol+col ); 
    %topoplot(c1,chanlocs,'maplimits', maplim); cbar('vert',0,maplim); 
    topoplot(c1,chanlocs);cbar('vert');
	subplot(nrow,ncol,(2-1)*ncol+col ); 
	%topoplot(c3,chanlocs,'maplimits', maplim); cbar('vert',0,maplim); 
    topoplot(c3,chanlocs);cbar('vert');
	subplot(nrow,ncol,(3-1)*ncol+col ); 
	topoplot(data,chanlocs,'maplimits', maplim); cbar('vert',0,maplim); 
end; end 
%end

for in=1:ncol; col=in; row=nrow; subplot(nrow,ncol,(row-1)*ncol+col ); text(-0.2,-0.7,[num2str(min(intervals{in})),'-',num2str(max(intervals{in})),'ms ']); end; 
%for i=1:2; row=i; col=1;  subplot(nrow,ncol,(row-1)*ncol+col ); text(-1,0,grpIndNames{i});end;
col=1; row=1; subplot(nrow,ncol,(row-1)*ncol+col ); text(-1,0,'C1');
col=1; row=2; subplot(nrow,ncol,(row-1)*ncol+col ); text(-1,0,'C3');
col=1; row=3; subplot(nrow,ncol,(row-1)*ncol+col ); text(-1,0,'C3-C1');
%sgtitle('50 ms window topomaps for target shape across conditions (c2-c1 + c3-c2 + c4-c3)'); 
savePath='/Users/Albert/Dropbox (EinsteinMed)/Writing/Seyda - SPLT Paper (Sophie)/plots/';
print('-dtiff','-r500',[savePath,'P3a_vs_P3b_target_NT_C1_C3_C31_.jpeg']); %close;
