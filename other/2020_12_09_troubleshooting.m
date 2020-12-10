eeglab; close; pop_editoptions( 'option_storedisk', 0, 'option_savetwofiles', 0, 'option_saveversion6', 1, 'option_single', 1, 'option_memmapdata', 0, 'option_eegobject', 0, 'option_computeica', 1, 'option_scaleicarms', 1, 'option_rememberfolder', 1, 'option_donotusetoolboxes', 0, 'option_checkversion', 1, 'option_chat', 0);

load_path = '/Volumes/Seagate Backup Plus Drive/forSeyda';
files = dir([load_path,filesep,'*.set']);
n_subj = length(files) ;
allSubj=zeros(n_subj,64,282);

for k=1:length(files)  

        EEG = pop_loadset(files(k).name, load_path);      
        data=EEG.data; 
        data=mean(data,3);
        allSubj(k,:,:)=data;
        fprintf('___File: %s\n',files(k).name);  
end

meanAllSubj = squeeze(mean(allSubj,1));

% com = pop_topoplot( EEG, typeplot, arg2, topotitle, rowcols, varargin);



maplim=[-5 5];
intervals={[25:50] [75:100]  [125:150] [175:200] [200:250] [250:300] [375:400]  [475:500] [500:600]}; 
nrow=1; ncol=length(intervals); 
fullfig('Border',[5 30]); hold on; 
%for in=1:ncol; col=in; for i=1:2; row=i; subplot(nrow,ncol,(row-1)*ncol+col ); try
for in=1:ncol; col=in; 
    data=meanAllSubj(:,ms2time(intervals{in},EEG.times),:);    data=squeeze(mean(data,2));
 	subplot(nrow,ncol,(1-1)*ncol+col ); 
    topoplot(data,EEG.chanlocs,'maplimits', maplim); cbar('vert',0,maplim); 
    %topoplot(data,EEG.chanlocs);cbar('vert');
end;  

for in=1:ncol; col=in; row=nrow; subplot(nrow,ncol,(row-1)*ncol+col ); text(-0.2,-0.7,[num2str(min(intervals{in})),'-',num2str(max(intervals{in})),'ms ']); end; 
savePath='/Users/Albert/Dropbox (EinsteinMed)/Writing/Seyda - SPLT Paper (Sophie)/plots/';
print('-dtiff','-r500',[savePath,'Topoplot_troubleshoot_Schiz.jpeg']); %close;


chans={20};
nrow=length(chans); ncol=1;
fullfig('Border',[5 5]); hold on; 
for ch=1:nrow; row=ch; 
    data=meanAllSubj(chans{ch},:);    data=squeeze(mean(data,1));
 	subplot(nrow,ncol,(1-1)*nrow+row ); 
    plot(EEG.times,data);
end
