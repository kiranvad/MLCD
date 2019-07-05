%% Illyka demo
load('data/olgadatacollect_02072019.mat')
tableId = 1;
idx=findphasesSC(dataSuite(1).composition*0.01,dataSuite(tableId).current',2,...
'distfunc','euclidean','adjType','del');
title('Phase diagram from CV')
currentData = dataSuite(tableId).current;
colors = hsv(length(unique(idx)));
for i=1:length(unique(idx))
    figure;plot(currentData(:,idx==i),'Color',colors(i,:))
    ylim([min(min(currentData)) max(max(currentData))])
    
    title(sprintf('CV Cluster %i',i));
end

xrdComp = xrdData.data{1,3}';
xrdIntens = xrdData.data{1,2};
figure;
idxXRD=findphasesSC(xrdComp*0.01,xrdIntens',2,...
'distfunc','euclidean','adjType','del');
title('Phase diagram from XRD')
