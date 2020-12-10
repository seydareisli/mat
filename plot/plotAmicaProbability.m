% Author: Seydanur Tikir (seydanurtikir@gmail.com)

function plotAmicaProbability(EEG,modelOut,winLen,walkLen,figName)
pnts = size(modelOut.v,2);
numMod = modelOut.num_models;
srate = EEG.srate; 
v = zeros(ceil(pnts/srate/walkLen),numMod);
        for it = 1:ceil(pnts/srate/walkLen)
            dataRange = (it-1)*walkLen*srate+1 : min(pnts, (it-1)*walkLen*srate+winLen*srate);
            keepIndex = find(sum(modelOut.v(:,dataRange),1)~=0);
            v(it,:) = mean(10.^modelOut.v(:,dataRange(keepIndex)),2);
        end
        % plot model probability time series
        figure, imagesc(v'); colorbar
        xlabel('End of condition blocks'); ylabel('Model ID');
        set(gca,'fontsize',12);   set(gcf,'position',[50,150,1500,300]);
        b=[]; c=[]; m=[]; for e = 1:length(EEG.event);  if ismember(EEG.event(e).type,{'101','102','103','104'});  ;
                b=[b e]; c=[c str2num(EEG.event(e).type)-100]; 
                m=[m round(EEG.event(e).latency/srate)];
            end;   end
        xticks(m); xticklabels(c);   yticks([1 2 3]);  title([figName, ' AMICA results']);
end