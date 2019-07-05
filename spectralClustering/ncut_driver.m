function [labels,dvalues] = ncut_driver(data,k,n,t)
% This function calculates the Normalized cut partitioning algorithm.
%
% data is the matrix with the data, where each row of the matrix
% contains a data point
% 
% sigma is the standard deviation for the gaussian 
%
% k is the number of desired groups
% n is the maximum number of iterations you would like the kmeans
% algorithm to run on top of the eigenvectors
%
% t is the threshold at which you would like the kmeans algorithm
% to terminate
%
% this function assumes the availability of a function
% "your_own_distance"
%
% which will take two matrices A and B, with row vectors
% corresponding to datapoints and calculate the all pairs distance
% between them.
%
% an example is included in this directory, its called "pairdist"
% and used in this function
%
% labels is an array of cluster labels for each of the datapoints.


%[N,Ncol]=size(data);

%d=your_own_distance(data,data);
d = pairdist(data,data,'L2');
%% Auto scaling Sigma
sKnn = 3;
sigma=[];
for i=1:size(data,1)
    [arrayDsort,IndexDsort]=sort(d(1,:)); 
    sigma(i)=arrayDsort(IndexDsort(sKnn));
end

for i=1:size(data,1)
    for j=1:size(data,1)
        W(i,j)=exp(-(pairdist(data(i,:),data(j,:),'L2'))^2/(sigma(i)*sigma(j)));
    end
end

%d=genAffinity(data,weights,lambda);
%W=exp(-d.^2/(2*sigma^2)); % slightly sloppy here, it should be d.^2
                       % but oh well it does not really matter
                       
[V,D,dvalues]=ncut(W);
D(1:k,1:k)
V1=V(:,2:k+1); % choose the k eigenvectors
Vnormalized=V1./repmat(sqrt(sum(V1.^2,2)),1,k);
[centers,labels,error]=km(Vnormalized',k,n,t);

