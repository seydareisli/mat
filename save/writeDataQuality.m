% Author: Seydanur Tikir (seydanurtikir@gmail.com)
% January 30 2019

function writeDataQuality(save_path,currentFile,EEG,note)
fileID = [save_path,filesep,datestr(now, 'yymmdd'),'_DataQuality_',currentFile,'.txt'];
dlmwrite(fileID,'___________________________', 'delimiter','','newline','pc','-append');
dlmwrite(fileID,['* Date and Time:',datestr(now, 'dd/mm/yy HH:MM'),' *'], 'delimiter','','roffset', 1,'newline','pc','-append');
dlmwrite(fileID,['_____File: ',currentFile], 'delimiter','','roffset', 1,'newline','pc','-append');
dlmwrite(fileID,['_____Note:',note], 'delimiter','','roffset', 1,'newline','pc','-append');

%  'roffset', 1,'newline','pc',
%EEG.chanlocs = pop_chanedit(EEG.chanlocs, 'load',{ path_sfp_167, 'filetype', 'autodetect'});

[EEG2, chan2exclude_kurt5 ]  = pop_rejchan(EEG, 'elec',[1: EEG.nbchan] ,'threshold',5,'norm','on','measure','kurt');
[EEG2, chan2exclude_kurt10]  = pop_rejchan(EEG, 'elec',[1: EEG.nbchan] ,'threshold',10,'norm','on','measure','kurt');
[EEG2, chan2exclude_kurt30]  = pop_rejchan(EEG, 'elec',[1: EEG.nbchan] ,'threshold',20,'norm','on','measure','kurt');
[EEG2, chan2exclude_prob5]   = pop_rejchan(EEG, 'elec',[1: EEG.nbchan] ,'threshold',5,'norm','on','measure','prob');
[EEG2, chan2exclude_prob10]  = pop_rejchan(EEG, 'elec',[1: EEG.nbchan] ,'threshold',10,'norm','on','measure','prob');
[EEG2, chan2exclude_prob30]  = pop_rejchan(EEG, 'elec',[1: EEG.nbchan] ,'threshold',20,'norm','on','measure','prob');

%[EEG2, externals_kurtosis999]  = pop_rejchan(EEG, 'elec',[163: 166] ,'threshold',999,'norm','on','measure','kurt');
%ear1=EEG.data(163,:); ear2=EEG.data(164,:); ear3=EEG.data(165,:); ear4=EEG.data(166,:);
%kurt(ear1); std(ear1);

dlmwrite(fileID,'Channels with kurtosis thresholds higher than 5;10;30, respectively:', 'delimiter','','roffset', 1,'newline','pc','-append');
dlmwrite(fileID,[0 chan2exclude_kurt5], 'delimiter',' ','precision','%.0f','newline','pc','-append');
dlmwrite(fileID,[0 chan2exclude_kurt10], 'delimiter',' ','precision','%.0f','newline','pc','-append');
dlmwrite(fileID,[0 chan2exclude_kurt30], 'delimiter',' ','precision','%.0f','newline','pc','-append');

dlmwrite(fileID,'Channels with probability thresholds higher than 5;10;30, respectively:', 'delimiter','','roffset', 1,'newline','pc','-append');
dlmwrite(fileID,[0 chan2exclude_prob5], 'delimiter',' ','precision','%.0f','newline','pc','-append');
dlmwrite(fileID,[0 chan2exclude_prob10], 'delimiter',' ','precision','%.0f','newline','pc','-append');
dlmwrite(fileID,[0 chan2exclude_prob30], 'delimiter',' ','precision','%.0f','newline','pc','-append');


[EEG2, segments2exclude, globthresh, nrej] = pop_rejcont(EEG, 'elecrange',[1: EEG.nbchan] ,'threshold',10,'epochlength',0.5,'contiguous',4,'addlength',0.15,'taper','hamming','eegplot','off' ); %Take notes about #of epochs generated and #of events removed. 
format long g 
totalNumberOfsegmentsToReject =length(segments2exclude);
if length(segments2exclude) ~= 0; totalDataPointsToReject = sum(segments2exclude(:,2)-segments2exclude(:,1));
else totalDataPointsToReject=0;end
totalDataPointsInEEG =length(EEG.data);
PercentageToReject = totalDataPointsToReject/totalDataPointsInEEG*100 ;
dlmwrite(fileID,'Number ofr segments to exclude according to rejcont epochlength-0.5 and contiguous-4:', 'delimiter','','roffset', 2,'newline','pc','-append');
dlmwrite(fileID,totalNumberOfsegmentsToReject, 'delimiter',' ','precision','%.0f','newline','pc','-append');
dlmwrite(fileID,'Total length:', 'delimiter','','roffset', 1,'newline','pc','-append');
dlmwrite(fileID,totalDataPointsToReject, 'delimiter',' ','precision','%.0f','newline','pc','-append');
dlmwrite(fileID,'Percentage:', 'delimiter','','roffset', 1,'newline','pc','-append');
dlmwrite(fileID,PercentageToReject, 'delimiter',' ','precision','%.0f','newline','pc','-append');

% YOU MAY ADD OUTLIER DETECTION LATER:
% a=EEG.data(ch,isoutlier(EEG.data(ch,:),'Grubbs'));

%dlmwrite(fileID,segments2exclude , 'delimiter',' ','precision','%.0f','-append');
%why is freq threshold 10 dB, and 'freqlimit',[20 40]?  
%if you want to be less strict, increase epochlength',0.5,or 'contiguous',4
%number of contiguous epochs necessary to label a segment as artifactual
% 'eegplot' ['on'|'off'] plot rejected portions 

% spectopo is not allowed at sampling freq of 128
% figure;  title([id(j).name,'-afterFilteringAndCleanLine']); 
% pop_spectopo(EEG, 1, [], 'EEG' , 'percent', 15, 'freq', [6 10 22], 'freqrange',[5 80],'electrodes','off');
% print('-djpeg',[sub_save_path,group{g},'_',id(j).name,'_afterCleanLine.jpeg']); close;     
end
        
  

