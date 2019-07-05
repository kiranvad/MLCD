function [error] = plotHCA(graphData,graphWeights,k,dataClass,varargin)
%% Perfoms Hierarchial Clustering and Plots ternary phase diagram
% *inputs*: graphData:  Comosition data N-by-3
%             graphWeights: Data used to compute similarity measure
%             k: number of clusters to be found
%               dataClass: Origial indexes to compute F-measure
%             'distance': distance measure to compute similarity measure
%             'linkage': linkage method used for HCA
%              
% *outputs*: error: F-measure value
% A ternary phase diagram from HCA is plotted
pars.linkage = 'average';
pars.distance = 'euclidean';
pars = extractpars(varargin,pars);
idx = clusterdata(graphWeights,'Maxclust',k,'distance',...
    pars.distance,'Linkage',pars.linkage);
colors=hsv(k);               % plots points with appropriate colors
colormap(colors);
[h,hg,htick]=terplot(5); % for entire surface

for i=1:k
    hter=ternaryc(graphData(idx==i,1),graphData(idx==i,2),graphData(idx==i,3));
    set(hter,'marker','.','markerfacecolor','none','markersize',25,'Color',colors(i,:))
    hold on;
end

hold off;
[error]=findFmeasure(idx,dataClass);
fprintf('F-measure is: <strong> %0.2f </strong> \n',error);
