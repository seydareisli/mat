% Author: Seydanur Tikir (seydanurtikir@gmail.com)

load_path='X:\Analyses\AMICAafterICA\'


for i = 1:2
    mkdir(save_path,group{i}) 
    id = dir([load_path,group{i},filesep,'1*']); 
    
    for j = 1:size(id,1) 
        mkdir([save_path,group{i},filesep,id(j).name]);
        subject_load_path = [load_path,group{i}, filesep, id(j).name, filesep];
        %Autism\11051\        
        EEG = pop_loadset([subject_load_path, id(j).name,'.set']);
        modelOut = loadmodout15(subject_load_path);
       winLen = 5; walkLen = 1;    % sec
       plotAmicaProbability(EEG,modelOut,winLen,walkLen,id(j).name)

        
         
        
        
        % compute mean probability in each stage
        modProbXState = zeros(numMod,numStage);
        
        for segmentID = 1:numStage
            dataRange = [];
            startEvent = Stage(1,segmentID); endEvent = 'exit';
            
            startIdx = find(strcmp({EEG.event.type},startEvent));
            
            % sampling after press1
            %     press1 = find(strcmp({EEG.event.type},'press1'));  % sampling after press1
            %     startIdx = press1(find(find(strcmp({EEG.event.type},'press1'))>startIdx,1));
            
            exitIdx = find(strcmp({EEG.event.type},endEvent));
            endIdx = exitIdx(find(find(strcmp({EEG.event.type},endEvent))>startIdx,1));
            
            if length(startIdx) > 1
                startIdx = startIdx(end);
            end
            if segmentID == 10 && isempty(endIdx)
                dataRange = ceil(EEG.event(startIdx).latency) : EEG.pnts;
            end
            
            if isempty(dataRange)
                dataRange = ceil(EEG.event(startIdx).latency) : floor(EEG.event(endIdx).latency);
            end
            keepIndex = find(sum(modelOut.v(:,dataRange),1) ~= 0);
            modProbXState(:,segmentID) = mean(10.^modelOut.v(:,dataRange(keepIndex)),2);
        end
        
        % compute mean probability in pre-task stage
        PretaskModProb = zeros(numMod,size(PreTask,2));
        
        for segmentID = 1:size(PreTask,2)
            dataRange = [];
            startEvent = PreTask(1,segmentID);
            if segmentID==size(PreTask,2)
                endEvent = Stage(1,1);
            else
                endEvent = PreTask(1,segmentID+1);
                exitIdx = find(strcmp({EEG.event.type},endEvent));
                endIdx = exitIdx(find(find(strcmp({EEG.event.type},endEvent))>startIdx,1));
            end
            
            startIdx = find(strcmp({EEG.event.type},startEvent));
            endIdx = find(strcmp({EEG.event.type},endEvent));
            
            if length(startIdx) > 1
                startIdx = startIdx(end);
            end
            
            if isempty(dataRange)
                dataRange = ceil(EEG.event(startIdx).latency) : floor(EEG.event(endIdx).latency);
            end
            keepIndex = find(sum(modelOut.v(:,dataRange),1) ~= 0);
            PretaskModProb(:,segmentID) = mean(10.^modelOut.v(:,dataRange(keepIndex)),2);
        end
        
        % plot sorted model plot
        m = zeros(numMod,numStage + size(PreTask,2));
        m(:,size(PreTask,2)+1:end) = modProbXState;
        m(:,1:size(PreTask,2)) = PretaskModProb;
        [~,I] = max(m,[],1);
        I = unique(I,'stable');
        SortMod = zeros(size(v));
        for i=1:size(I,2)
            SortMod(:,i) = v(:,I(i));
        end
        
        diff = setdiff((1:numMod),I);
        for j=1:(numMod-size(I,2))
            SortMod(:,(size(I,2)+j)) = v(:,diff(j));
        end
        
        
        figure, imagesc(SortMod'); colorbar
        xlabel('Time (sec)'); ylabel('Model ID');
        set(gca,'fontsize',12);
        set(gcf,'position',[50,150,1900,600]);
        
        
        hold on,
        % add event markers
        for it = 1:length(EEG.event)
            if ~strcmp(EEG.event(it).type,'press') 
                if strcmp(EEG.event(it).type,'press1')
                    h = plot([x x],[0.5 numMod+0.5],'w--','LineWidth',1);
                    
                elseif strcmp(EEG.event(it).type,'awe') 
                    h = plot([x x],[0.5 numMod+0.5],'r-','LineWidth',1);
                    
                else
                    h = plot([x x],[0.5 numMod+0.5],'w-','LineWidth',1);
                end
                
                if ~strcmp(EEG.event(it).type,'exit') && ~strcmp(EEG.event(it).type,'press1')
                    text(x,0.5,EEG.event(it).type,'Rotation',30,'fontsize',12);
                end
            end
        end
        
        for i=1:numMod
            Models{i,:} = sprintf('Model %d',i);
        end
        
        figname = sprintf('figures\\modelprob_sorted_S%dM%d_64ch.png',subj_id,numMod);
        saveas(gcf,figname)
        close
        
    end
end


%% figure 2: temporal dynamics for each emotion



%% figure 3-1: probability-based model clustering and resulting prob distribution
SubjNo = [1:2, 4:17, 19:21, 23:29, 31, 35]; % 4 5 6 8 9 10 13 16 17 20 21 24 26 27 28 31 35];
filepath = '/data/projects/Shawn/2019_Emogery/';
Emotions = {'relax','awe','joy','happy','love','compassion','content','relief','excite',...
            'frustration','anger','sad','grief','jealousy','fear','disgust'};
numStage = length(Emotions);
numMod = 20;

eventLabelIdx = zeros(numStage,3,length(SubjNo));
modelOutstack = [];
modProbXStateXSubj = [];
modProbXStateXSubj_press = [];
errorReport = {};

for subj_id = 1:length(SubjNo) 
    
    % load EEG
    filename = sprintf('EEG_Subj_%d_64ch_info.set',SubjNo(subj_id));
    EEG = pop_loadset('filename',filename,'filepath',filepath);
    
    % load AMICA output
    outdir = [filepath, sprintf('amicaout/emotion_S%d_M%d_64ch',SubjNo(subj_id),numMod)];
    modelOut = loadmodout15(outdir);
    

    % compute mean probability in each stage
    modProbXState = zeros(numMod,numStage);
    modProbXState_press = zeros(numMod,numStage);
    
    % find press1
    press1 = find(strcmp({EEG.event.type},'press1'));
    exitIdx = find(strcmp({EEG.event.type},'exit'));
        
    for segmentID = 1:size(Stage,2)
        dataRange = [];
        dataRange_press = [];
        startEvent = Stage(1,segmentID); 

        % find the start of each trial
        startIdx = find(strcmp({EEG.event.type},startEvent));
        eventLabelIdx(strcmp(Emotions,startEvent),1,subj_id) = EEG.event(startIdx).latency;
        
        % find press1
        pressIdx = press1(find(press1>startIdx,1));
        eventLabelIdx(strcmp(Emotions,startEvent),2,subj_id) = EEG.event(pressIdx).latency;

        % find the end of each trial
        endIdx = exitIdx(find(exitIdx>startIdx,1));
        eventLabelIdx(strcmp(Emotions,startEvent),3,subj_id) = EEG.event(endIdx).latency;

        % handle special case
        if length(startIdx) > 1
            startIdx = startIdx(end);
            errorReport{end+1} = sprintf('duplicate trial: %s, Subj %d\n',startEvent{1},SubjNo(subj_id));
        end
        if pressIdx > endIdx
            pressIdx = startIdx;
            errorReport{end+1} = sprintf('missing press event: %s, Subj %d\n',startEvent{1},SubjNo(subj_id));
        end
        if segmentID == 10 && isempty(endIdx)
            dataRange = ceil(EEG.event(startIdx).latency) : EEG.pnts;
            dataRange_press = ceil(EEG.event(pressIdx).latency) : EEG.pnts;
            errorReport{end+1} = sprintf('missing exit event: %s, Subj %d\n',startEvent{1},SubjNo(subj_id));
        end

        % specify data range
        if isempty(dataRange) 
            dataRange = ceil(EEG.event(startIdx).latency) : floor(EEG.event(endIdx).latency);
            dataRange_press = ceil(EEG.event(pressIdx).latency) : floor(EEG.event(endIdx).latency);
        end
        
        % compute mean model probability from start to end
        keepIndex = find(sum(modelOut.v(:,dataRange),1) ~= 0);
        modProbXState(:,strcmp(Stage(1,segmentID),Emotions)) = ...
            mean(10.^modelOut.v(:,dataRange(keepIndex)),2);             
        
        % compute mean model probability from press1 to end
        keepIndex_press = find(sum(modelOut.v(:,dataRange_press),1) ~= 0);
        modProbXState_press(:,strcmp(Stage(1,segmentID),Emotions)) = ...
            mean(10.^modelOut.v(:,dataRange_press(keepIndex_press)),2);

    end
    modProbXStateXSubj = [modProbXStateXSubj; modProbXState];
    modProbXStateXSubj_press = [modProbXStateXSubj_press; modProbXState_press];
end

save('modProbXStateXSubj.mat','modProbXStateXSubj');
save('modProbXStateXSubj_press.mat','modProbXStateXSubj_press');


%% figure 3-2: plot dendrogram of subject models

modProb = modProbXStateXSubj_press;

% compute distance metric: 1 - correlation of model prob. features
[rho] = corr(modProb');
distMat = 1-rho;
% figure, imagesc(distMat);

% prepare distance vector: a vector representation of a distance matrix
% (consistent with pdist () output format)
distVec = [];
for it = 1:size(distMat,1)-1
    distVec = [distVec, distMat(it,it+1:end)];
end

% Agglomerative hierarchical cluster tree
clusterLink = linkage(distVec,'average');
leafOrder = optimalleaforder(clusterLink,distVec,'Criteria','group');

% find clusters
num_cluster = 20;
cutoff_th = median([clusterLink(end-num_cluster+1,3), clusterLink(end-num_cluster+2,3)]);

figure('Position', [50 50 1400 500]),
[H,~,outperm] = dendrogram(clusterLink,0,'ColorThreshold',cutoff_th,'Reorder',leafOrder);
set(H,'LineWidth',1.5)
axis off;
% saveas(gcf,'HCtree_modprob_28subj','png');

figure('Position', [50 50 1400 1400]),
rho_sorted = corr(modProb(outperm,:)');
imagesc(rho_sorted);
colorbar; xlabel('AMICA Models'); ylabel('AMICA Models')
set(gca,'fontsize',14)
% saveas(gcf,'HC_modprob_28subj','png');


%% figure 3-3: plot mean model probability of model clusters
figure;
[~,T] = dendrogram(clusterLink,num_cluster,'Reorder',leafOrder);

modelIdx = cell(1,num_cluster);
modProb_cluster = zeros(num_cluster,numStage);
std_modProb_cluster = zeros(num_cluster,numStage);
for cluster_id = 1:num_cluster
    modelIdx{cluster_id} = find(T == cluster_id);
    modProb_cluster(cluster_id,:) = mean(modProb(modelIdx{cluster_id},:));
    std_modProb_cluster(cluster_id,:) = std(modProb(modelIdx{cluster_id},:));
end

% clusterOrder = [1,4,8,2,9,14,11,3,16,13,19,15,12,10,6,7,17,5,20,18];  % start 
clusterOrder = [9,1,12,15,3,16,11,8,2,5,13,10,19,20,6,7,18,4,17,14];    % press

figure, imagesc(modProb_cluster(clusterOrder,:)');
set(gca,'YTick',1:numStage,'YTickLabel',Emotions);
set(gca,'XTick',1:num_cluster,'XTickLabel',clusterOrder);
set(gca,'fontsize',12,'fontweight','bold'); colorbar
set(gcf,'position',[50,50,750,550]);
xlabel('Cluster ID');
% saveas(gcf,'AvgModProc_cluster_press','png');

figure, imagesc(std_modProb_cluster(clusterOrder,:)');
set(gca,'YTick',1:numStage,'YTickLabel',Emotions);
set(gca,'XTick',1:num_cluster,'XTickLabel',clusterOrder);
set(gca,'fontsize',12,'fontweight','bold'); colorbar
set(gcf,'position',[50,50,750,550]);
xlabel('Cluster ID');
% saveas(gcf,'StdModProc_cluster_press','png');




%% figure 4: IC clustering of each model cluster


%% figure 5: Dipole density plots of each model cluster





%% figure S1: directed graph to explore structure of clusters - show similarity between runs with diff # of models
subj_id = 2;
filename = sprintf('EEG_Subj_%d.set',subj_id);
EEG = pop_loadset('filename',filename,'filepath','C:\Users\shawn\Desktop\Emotion\');

% model probabilities for all ICAMM
numMod_list = [3:20];
modProb = cell(1,length(numMod_list));
for numMod = 3:20
    
    amicaout_dir = sprintf('Subj%d_M%d',subj_id,numMod);
    ourdir = ['C:\Users\shawn\Desktop\Emotion\' amicaout_dir];
    modelOut = loadmodout15(ourdir);
    
    % non-overlapping sliding window average of model probabilities
    winLen = 1;     % sec
    walkLen = 1;    % sec
    v = zeros(ceil(EEG.xmax/walkLen),numMod);
    
    for it = 1:ceil(EEG.xmax/walkLen)
        dataRange = (it-1)*walkLen*EEG.srate+1 : min(EEG.pnts, (it-1)*walkLen*EEG.srate+winLen*EEG.srate);
        keepIndex = find(sum(modelOut.v(:,dataRange),1)~=0);
        v(it,:) = mean(10.^modelOut.v(:,dataRange(keepIndex)),2);
    end
    
    modProb{numMod-2} = v;
    
end

%% model matching directed graph
one_to_one_map = 0;
corrThres = 0.30;
weights = [];
source = [];
target = [];
nodeCount = 0;
nodeLabel = [];
for it = 1:length(modProb)-1
    
    % handle NaN in model probability
    nan_index_1 = find(isnan(modProb{it}(:,1)));
    nan_index_2 = find(isnan(modProb{it+1}(:,1)));
    keepIndex = setdiff(1:size(modProb{it},1), unique([nan_index_1; nan_index_2]));
    
    % compute cross correlation
    [corr,indx,indy,corrs] = matcorr(modProb{it}(keepIndex,:)',modProb{it+1}(keepIndex,:)');
    
    % force 1-to-1 mapping (only takes max-corr match)
    if one_to_one_map
        [weightCorr,indexCorr] = max(corrs);
        weights = [weights, 1-weightCorr];
        source = [source, indexCorr + nodeCount];
        target = [target, (1:it+3) + nodeCount + it+2];
    else % report all edges with corr > corrThres
        edgeIndex = find(corrs > corrThres);
        edgeWeight = corrs(edgeIndex);
        sourceNode = mod(edgeIndex-1,it+2)+1;
        targetNode = floor((edgeIndex-1)/(it+2))+1;
        weights = [weights; 1-edgeWeight];
        source = [source; sourceNode + nodeCount];
        target = [target; targetNode + nodeCount + it+2];
    end
    
    nodeCount = nodeCount + it+2;
    nodeLabel = [nodeLabel, 1:(it+2)];
    
end
nodeLabel = [nodeLabel,1:(it+3)];

% G = digraph(source,target,weights);
G = graph(source,target,weights);
figure, h = plot(G,'EdgeLabel',fix((1-G.Edges.Weight)*10^3)/10^3, ...
    'LineWidth',20*((1-G.Edges.Weight)-min((1-G.Edges.Weight)))+0.5, ...
    'NodeLabel',[]); %nodeLabel);
set(gca,'XTickLabel',{},'YTick',1:11,'YTickLabel',num2cell(13:-1:3),'Fontsize',14)
set(gcf,'Position',[0,0,1000, 800])
for i=1:length(h.XData)
    text(h.XData(i)+0.1,h.YData(i),num2str(nodeLabel(i)),'fontsize',14);
end

% compute distances of the shortest path between all model pairs
d = distances(G);
max_numMode = numMod_list(end);
d_final = d((end-max_numMode+1):end, (end-max_numMode+1):end);
figure, imagesc(d);
figure, imagesc(d_final);
% target((end-numMod_list(end)+1):end)



%% Examine IC scalp maps
numMod = 20;
subj_id = 2;

amicaout_dir = sprintf('Subj%d_M%d',subj_id,numMod);
ourdir = ['C:\Users\shawn\Desktop\Emotion\' amicaout_dir];
modelOut = loadmodout15(ourdir);

model_id = 3;

EEG.icaweights = modelOut.W(:,:,model_id);
EEG.icasphere = modelOut.S;
EEG.icawinv = modelOut.A(:,:,model_id);
EEG = eeg_checkset(EEG);
pop_topoplot(EEG,0,[1:20]);


%% Figure S2. Parameter-based model clustering
subj_id = 2;
numMod = 20;

amicaout_dir = sprintf('Subj%d_M%d',subj_id,numMod);
ourdir = ['C:\Users\shawn\Desktop\Emotion\' amicaout_dir];
modelOut = loadmodout15(ourdir);

corrTh = 0.8;
sorted_corr = cell(numMod);
numIC_highcorr = nan(numMod);

for model_1 = 1:numMod-1
    for model_2 = model_1+1:numMod
        A1 = modelOut.A(:,:,model_1);
        A2 = modelOut.A(:,:,model_2);
        
        [corr_tmp,indx,indy,corrs] = matcorr(A1',A2',0,2);
        sorted_corr{model_1,model_2} = abs(corr_tmp);
        numIC_highcorr(model_1,model_2) = find(abs(corr_tmp)<corrTh,1)-1;
    end
end

figure, plot(sorted_corr{1,2},'linewidth',2); xlabel('Component Numbering'); ylabel('Coorelation of matched ICs'); set(gca,'fontsize',12);
hold on, plot([0 250],[corrTh corrTh],'--r');

figure, imagesc(numIC_highcorr);

% nomarlize distance measure
distMat = (numIC_highcorr - max(numIC_highcorr(:))) / (min(numIC_highcorr(:)) - max(numIC_highcorr(:)));
distVec = [];
linkMethod = 'average';
for it1 = 1:size(distMat,1)-1
    distVec = [distVec, distMat(it1, it1+1:end)];
end

% hierarchical clustering
clusterLink = linkage(distVec,linkMethod);

figure,
[H,T,outperm] = dendrogram(clusterLink, 0);
ylabel('Norm num of 0.8 correlated ICs')
set(gca,'fontsize',12);


%% Examine LL(t) for different numbers of AMICA models
numMod = 3:20;
subj_id = 2;
LL_all = cell(1,length(numMod));
BIC = zeros(1,length(numMod));
AIC = zeros(1,length(numMod));
CAIC = zeros(1,length(numMod));
LL_sum = zeros(1,length(numMod));
for it = 1:length(numMod)
    
    amicaout_dir = sprintf('Subj%d_M%d',subj_id,numMod(it));
    ourdir = ['C:\Users\shawn\Desktop\Emotion\' amicaout_dir];
    modelOut = loadmodout15(ourdir);
    
    % log likelihood
    LL_all{it} = modelOut.LL;
    
    % number of parameters
    numPara = length(modelOut.W(:)) + length(modelOut.c(:)) + length(modelOut.alpha(:)) + ...
        length(modelOut.mu(:)) + length(modelOut.sbeta(:)) + length(modelOut.rho(:));
    
    % Bayesian Information Criteria (BIC)
    num_rej_data = sum(modelOut.Lt == 0);
    BIC(it) = log(length(modelOut.Lt)-num_rej_data) * numPara - 2*sum(modelOut.Lt);
    
    % Akaike Information Criteria (AIC)
    AIC(it) = 2*numPara - 2*sum(modelOut.Lt);
    
    % Corrected AIC
    CAIC(it) = 2*numPara - 2*sum(modelOut.Lt) + 2*numPara*(numPara+1) / (length(modelOut.Lt)-num_rej_data-numPara-1);
    
    LL_sum(it) = sum(modelOut.Lt);
end


figure, hold on,
for it = 1:length(numMod)
    plot(LL_all{it});
    mark_pos = 1200 - it*50;
    text(mark_pos,LL_all{it}(mark_pos),num2str(numMod(it)),'fontsize',12);
end
ylim([-2.353 -2.328])
set(gca,'fontsize',12);
xlabel('Learning Steps'); ylabel('Log Likelihood');


figure,
subplot(3,1,1); plot(numMod,BIC,'linewidth',2); ylabel('BIC');
subplot(3,1,2); plot(numMod,AIC,'linewidth',2);ylabel('AIC');
subplot(3,1,3); plot(numMod,CAIC,'linewidth',2);ylabel('CAIC');
xlabel('Number of AMICA models')

figure,
plot(numMod,LL_sum)



%%
LLt = tmp;
norm_LLt = bsxfun(@rdivide,LLt,sum(LLt));

numMod = modelOut.num_models;
v = zeros(ceil(EEG.xmax/walkLen),numMod);

for it = 1:ceil(EEG.xmax/walkLen)
    dataRange = (it-1)*walkLen*EEG.srate+1 : min(EEG.pnts, (it-1)*walkLen*EEG.srate+winLen*EEG.srate);
    v(it,:) = mean(norm_LLt(:,dataRange(keepIndex)),2);
end

figure, imagesc(v'); colorbar
xlabel('Time (sec)'); ylabel('Model ID');
set(gca,'fontsize',12);
set(gcf,'position',[50,150,1450,450]);


%% microstate analysis
% EEG = pop_loadset('filename','EEG_Subj_2.set','filepath','C:\\Users\\shawn\\Desktop\\Emotion\\');
% EEG = eeg_checkset( EEG );
% [EEG,com] = pop_FindMSTemplates(EEG, struct('MinClasses', 4, 'MaxClasses', 10, 'GFPPeaks', 1, 'IgnorePolarity', 1, 'MaxMaps', 1000, 'Restarts', 5, 'UseAAHC', 0), 0, 0);
% EEG = eeg_checkset( EEG );
% [ALLEEG,EEG,com] = pop_ShowIndMSMaps(EEG, 6, 0, ALLEEG);
% com = pop_ShowIndMSDyn(ALLEEG, EEG, 0, struct('b',0,'lambda',3.000000e-01,'PeakFit',1,'nClasses',6,'BControl',1));
% EEG = eeg_checkset( EEG );
%
% tmp = load('MSClass_6.mat');
% MSClass = tmp.MSClass;


