function [dvalues,error,idx] = ncut_WeightedGraph(W,k,varargin)
%% Finds partitions of the graph given a weighted matrix W into k clusters
% Outputs : dvalues (sorted eigen values)
%             error (mean sum error of k-means)
%             idx (indexes from spectral clustering)
%%
pars.useparallel = 0;

pars = extractpars(varargin, pars);


[V,D,dvalues]=ncut(W);
D(1:k,1:k);
V1=V(:,2:k+1); % choose the k eigenvectors
Vnormalized=V1./repmat(sqrt(sum(V1.^2,2)),1,k);
%[~,labels,error]=km(Vnormalized',k,n,t);

stream = RandStream('mlfg6331_64');  % Random number stream
options = statset('UseParallel',pars.useparallel,'UseSubstreams',1,...
    'Streams',stream);
[idx,~,sumd] = kmeans(Vnormalized,k,'Options',options,'MaxIter',10000,...
    'Display','off','Replicates',50);
error=mean(sumd);
%fprintf('k-means error is: <strong> %0.2f </strong>\n',error);
