function [idx,dvalues]=findphasesSC(graphData,graphWeights,k,varargin)
%% Spectral Clustering to produce phases
%[idx,dvalues]=findphasesSC(graphData,graphWeights,k,varargin)
% Uses graph partitioning mentioned in the paper to produce a phase diagram
% *inputs*:   graphData:  Comosition data N-by-3 (in fractions)
%             graphWeights: Data used to compute similarity measure d-by-N
%             k: number of clusters to be found
%             'distfunc': distance measure to compute similarity measure
%             'sKnn': Nereast neighbour scaling default(4)
%             'adjType': 'kNN'(graph graphData using k-nearest neighbours,default)
%                         'del' (graph graphData using delaunay tesselation)
%      
% *outputs*: idx: phase indexes from spectral clustering
%            dvalues: Eigen decomposition of weighted graph 

%%
pars.distfunc = 'euclidean';
pars.sKnn = 4;
pars.adjType='kNN';
pars = extractpars(varargin,pars);
[W]=getWtGraph(graphData,graphWeights,'distfunc',pars.distfunc,'sKnn',...
    pars.sKnn,'adjType',pars.adjType);
[dvalues,~,idx] = ncut_WeightedGraph(W,k);
colors=hsv(k);               % plots points with appropriate colors
colormap(colors);

[h,hg,htick]=terplot(5); % for entire surface

for i=1:k
    hter=ternaryc(graphData(idx==i,1),graphData(idx==i,2),graphData(idx==i,3));
    set(hter,'marker','.','markerfacecolor','none','markersize',35,'Color',colors(i,:))
    hold on;
end

hold off;