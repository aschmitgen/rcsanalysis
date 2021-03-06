function compareStimLongTermRecordings()
addpath(genpath(fullfile(pwd,'toolboxes/'))); 
%% after stim 
close all; 
settings.rootdir = '/Users/roee/Starr_Lab_Folder/Data_Analysis/RCS_data/RCS02/v13_home_data_stim/rcs_data/RCS02L/'; 
settings.rootdir = '/Users/roee/Starr_Lab_Folder/Data_Analysis/RCS_data/RCS02/v08_all_home_data_before_stim/RCS02_all_home_data_processed/RCS02L';
settings.file    = 'psdResults.mat'; 
load(fullfile(settings.rootdir, settings.file))
betaIdxUse = 14:30;

% plot raw data - only beta0 
figure;
beta = mean(fftResultsTd.key0fftOut(14:30,:),1);
scatter(fftResultsTd.timeStart,beta)
tlower = datetime(2019,05,20,'TimeZone','America/Los_Angeles');
tupper = datetime(2019,05,24,'TimeZone','America/Los_Angeles');
idxBetween = isbetween(fftResultsTd.timeStart,tlower,tupper);
% trim data 
for c = 1:4 
    fn = sprintf('key%dfftOut',c-1); 
    fftResultsTd.(fn) = fftResultsTd.(fn)(:,idxBetween); 
end
fftResultsTd.timeStart = fftResultsTd.timeStart(idxBetween); 
fftResultsTd.timeEnd = fftResultsTd.timeEnd(idxBetween); 


% get raw data 
hfig = figure;
idxWhisker = []; 
for c = 1:4 
    fn = sprintf('key%dfftOut',c-1); 
    hsub = subplot(2,2,c); 
    meanVals = mean(fftResultsTd.(fn)(40:60,:));
    boxplot(meanVals);
    q75_test=quantile(meanVals,0.75);
    q25_test=quantile(meanVals,0.25);
    w=2.0;
    wUpper(c) = w*(q75_test-q25_test)+q75_test;
    idxWhisker(:,c) = meanVals' < wUpper(c);

end
idxkeep = idxWhisker(:,1) &  idxWhisker(:,2) & idxWhisker(:,3) & idxWhisker(:,4) ; 


% plot all data percentile 
figure;
ttls = {'STN 0-2','STN 1-3','M1 8-10','M1 9-11'}; 
for c = 1:4 
    hsub(c) = subplot(2,2,c); 
    hold on; 
    fn = sprintf('key%dfftOut',c-1); 
    C = fftResultsTd.(fn)(:,idxkeep);
    for i = 2:0.5:98
        y = prctile(C,i,2); 
        x = fftResultsTd(1).ff; 
        plot(hsub(c),x,y,'Color',[0 0 0.8 0.5],'LineWidth',0.2); 
    end
    set(gca,'YDir','normal') 
    ylabel('Power');
    xlabel('Frequency (Hz)');
    set(gca,'FontSize',20);
end
ttluse = sprintf('%s hours of data, %d 30 sec chunks',dataKeep,sum(idxkeep));
sgtitle(ttluse,'FontSize',30)
linkaxes(hsub,'x');




figure;
ttls = {'STN 0-2','STN 1-3','M1 8-10','M1 9-11'}; 

for c = 1:4 
    hsub(c) = subplot(4,1,c); 
    fn = sprintf('key%dfftOut',c-1); 
    C = fftResultsTd.(fn)(:,idxkeep);
    
    imagesc(C);
    title(ttls{c});
    set(gca,'YDir','normal') 
    ylabel('Frequency (Hz)');
    set(gca,'FontSize',20); 
end

%data after stim
rawDataAfterStim    = fftResultsTd.key1fftOut(:,idxkeep); 


totalDataOn = sum(fftResultsTd.timeEnd(idxkeep) - fftResultsTd.timeStart(idxkeep));
rawPowerBetaOnStim = mean(fftResultsTd.key1fftOut(betaIdxUse,idxkeep)); 
powerBetaOnStim = rawPowerBetaOnStim ./  median(median(fftResultsTd.key1fftOut(5:45,idxkeep))); 
close(hfig); 

settings.rootdir = '/Users/roee/Starr_Lab_Folder/Data_Analysis/RCS_data/RCS02/v08_all_home_data_before_stim/RCS02_all_home_data_processed/RCS02L/'; 
settings.file    = 'psdResults.mat'; 
load(fullfile(settings.rootdir, settings.file));


hfig = figure;
idxWhisker = []; 
for c = 1:4 
    fn = sprintf('key%dfftOut',c-1); 
    hsub = subplot(2,2,c); 
    meanVals = mean(fftResultsTd.(fn)(40:60,:));
    boxplot(meanVals);
    q75_test=quantile(meanVals,0.75);
    q25_test=quantile(meanVals,0.25);
    w=2.0;
    wUpper(c) = w*(q75_test-q25_test)+q75_test;
    idxWhisker(:,c) = meanVals' < wUpper(c);

end
idxkeep = idxWhisker(:,1) &  idxWhisker(:,2) & idxWhisker(:,3) & idxWhisker(:,4) ; 
close(hfig); 


rawPowerBetaOffStim = mean(fftResultsTd.key1fftOut(betaIdxUse,idxkeep)); 
powerBetaOffStim = rawPowerBetaOffStim ./ median(median(fftResultsTd.key1fftOut(5:45,idxkeep))); 
totalDataOff = sum(fftResultsTd.timeEnd(idxkeep) - fftResultsTd.timeStart(idxkeep));

figure;
ttls = {'STN 0-2','STN 1-3','M1 8-10','M1 9-11'}; 

for c = 1:4 
    hsub(c) = subplot(4,1,c); 
    fn = sprintf('key%dfftOut',c-1); 
    C = fftResultsTd.(fn)(:,idxkeep);
    
    imagesc(C);
    title(ttls{c});
    ylim([0 80]); 
    set(gca,'YDir','normal') 
    ylabel('Frequency (Hz)');
    set(gca,'FontSize',20); 
end
linkaxes(hsub,'x'); 

rawDataBeforeStim    = fftResultsTd.key1fftOut(:,idxkeep); 

close all;

groups = [ones(size(powerBetaOnStim,2),1) ; ones(size(powerBetaOffStim,2),1).*2 ];
x      = [powerBetaOnStim' ; powerBetaOffStim'];

figure;
hbox = boxplot(x,groups);
xticklabels({'on stim' , 'off stim'}); 
ylabel('normalized beta'); 
set(gca,'FontSize',20); 
set(gcf,'Color','w')
title('on stim (90 hours) vs off stim (154 hours) - beta STN'); 

figure;
hold on; 
histogram(rawPowerBetaOffStim,'Normalization','probability','BinWidth',0.1); 
histogram(rawPowerBetaOnStim,'Normalization','probability','BinWidth',0.1); 
legend({'off stim','on stim'}); 
ttluse = sprintf('Beta (%d-%dHz) on/off stim - STN',betaIdxUse(1),betaIdxUse(end));
title(ttluse); 
set(gcf,'Color','w')
set(gca,'FontSize',20)


figure; 
hold on; 
shadedErrorBar(fftResultsTd.ff,rawDataBeforeStim',{@median,@(x) std(x)*1.96},'lineprops',{'r','markerfacecolor','k','LineWidth',2});
shadedErrorBar(fftResultsTd.ff,rawDataAfterStim',{@median,@(x) std(x)*1.96},'lineprops',{'b','markerfacecolor','k','LineWidth',2});
legend({'before stim','after stim'}); 
ylabel('Probability'); 
title('on stim (90 hours) vs off stim (154 hours) - STN'); 
set(gcf,'Color','w')
set(gca,'FontSize',20)


return;
%% clustering 
chanNames = {'STN 0-2','STN 1-3','M1 8-10','M1 9-11'};
for i = 1:4
    cfnm = sprintf('key%dfftOut',i-1);
    freq = fftResultsTd.ff;
    
    fftD = fftResultsTd.(cfnm)';
    
    % XXX 
    freq = freq(1:100);
    fftD = fftD(idxkeep,1:100);
    % XXX
    
    % get distance matrix 
    D = pdist(fftD,'euclidean');
    distmat = squareform(D); 
    distMatrices = squareform(distmat,'tovector');
    % get row indices 
    rows = repmat(1:size(distmat,1),size(distmat,2),1)';
    idx = logical(eye(size(rows)));
    rows(idx) = 0; 
    rowsColmn = squareform(rows,'tovector');
    % get column idices 
    colmns = repmat(1:size(distmat,1),size(distmat,2),1);
    idx = logical(eye(size(colmns)));
    colmns(idx) = 0; 
    colsColmn = squareform(colmns,'tovector');
    % save data for rodriges 
    distanceMat = [];
    distanceMat(:,1) = rowsColmn; 
    distanceMat(:,2) = colsColmn;
    distanceMat(:,3) = distMatrices; 
    [cl,halo] =  cluster_dp(distanceMat,cfnm); 
    res(i).cl = cl; 
    res(i).halp = halo;
    res(i).freq = freq; 
    res(i).fftD = fftD; 
    res(i).D = D; 
    res(i).distmat = distmat; 
    res(i).idxkeep = idxkeep;
end
fnsaveclustring = fullfile(settings.rootdir,'psdResultsClustering_July1-3.mat')
save(fnsaveclustring,'res','-v7.3');

figure;
for i = 1:4
    subplot(2,2,i);
    hold on;
    unqclusters = unique(res(i).cl)
    for u = unqclusters
        shadedErrorBar(res(i).freq',res(i).fftD(res(i).cl==u,:),{@median,@(x) std(x)*1.96},'lineprops',{'r','markerfacecolor','k'});
    end
    title(chanNames{i});
    % legend({'cluster 1 ','cluster 2'});
    set(gca,'FontSize',20)
end
set(gcf,'Color','w');

% try clustering eveything together based on specific freuqnces - beta for
% stn and gamma for m1 
cfnm = sprintf('key%dfftOut',i-1);
freq = fftResultsTd.ff;

% stim data rcs02 
% beta - 20:22 (these are ff idxs) 
% gamma - 65:68
% non stim data rcs02 
% beta 25 gamma 77 

fffMin(:,1) = rescale(mean(fftResultsTd.key0fftOut(25,idxkeep),1),0,1);
fffMin(:,2) = rescale(mean(fftResultsTd.key1fftOut(25,idxkeep),1),0,1);
fffMin(:,3) = rescale(mean(fftResultsTd.key2fftOut(77,idxkeep),1),0,1);
fffMin(:,4) = rescale(mean(fftResultsTd.key3fftOut(77,idxkeep),1),0,1);
% plot raw dat 
figure;
hsubuse(1) = subplot(2,1,1); 
scatter(fftResultsTd.timeStart(idxkeep), fffMin(:,2),20,[0 0 0.8 ],'filled','MarkerFaceAlpha',0.5)
ylabel('Beta power (a.u.)');
xlabel('Time');
set(gca,'FontSize',20);
title('STN beta power'); 

hsubuse(2) = subplot(2,1,2); 
scatter(fftResultsTd.timeStart(idxkeep), fffMin(:,3),20,[0.8 0 0 ],'filled','MarkerFaceAlpha',0.5)
ylabel('Gamma power (a.u.)');
xlabel('Time');
set(gca,'FontSize',20);
title('Cortex gamma power'); 
set(gcf,'Color','w'); 
linkaxes(hsubuse,'x'); 

% get distance matrix 
D = pdist(fffMin,'euclidean');
distmat = squareform(D);
distMatrices = squareform(distmat,'tovector');
% get row indices
rows = repmat(1:size(distmat,1),size(distmat,2),1)';
idx = logical(eye(size(rows)));
rows(idx) = 0;
rowsColmn = squareform(rows,'tovector');
% get column idices
colmns = repmat(1:size(distmat,1),size(distmat,2),1);
idx = logical(eye(size(colmns)));
colmns(idx) = 0;
colsColmn = squareform(colmns,'tovector');
% save data for rodriges
distanceMat = [];
distanceMat(:,1) = rowsColmn;
distanceMat(:,2) = colsColmn;
distanceMat(:,3) = distMatrices;
[cl,halo] =  cluster_dp(distanceMat);
resAll(1).cl = cl;
resAll(1).halp = halo;
resAll(1).freq = freq;
resAll(1).fftD = fftD;
resAll(1).D = D;
resAll(1).distmat = distmat;
resAll(1).idxkeep = idxkeep;


figure;
for i = 1:4
    subplot(2,2,i);
    hold on;
    unqclusters = unique(resAll(1).cl)
    shadedErrorBar(res(i).freq',res(i).fftD(resAll(1).cl==1,:),{@median,@(x) std(x)*1.96},'lineprops',{'r','markerfacecolor','k'});
    shadedErrorBar(res(i).freq',res(i).fftD(resAll(1).cl==2,:),{@median,@(x) std(x)*1.96},'lineprops',{'b','markerfacecolor','k'});
    
    title(chanNames{i});
    % legend({'cluster 1 ','cluster 2'});
    set(gca,'FontSize',20)
end
set(gcf,'Color','w');

% XXX
freq = freq(1:100);
fftD = fftD(idxkeep,1:100);

end