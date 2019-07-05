function [W]=getWtGraph(Data,Weights,varargin)
%% Generates an adjacency matrix for the composition from the "Data" and  Weights
% Inputs:
%         Data: Compsition data each row is a composotion array
%         Weights: Data to be trained on each row is a response
%
%         Parameters: 'distfunc' distance function to be used (eg: 'euclidean')
%                     'sKNN' scaling parameter for Sigma in spectral
%                            clustering
%                     'adjType' adjacency type (eg: 'kNN')
%                     
% Output: 
%  W: a weighted Afiinity matrix W
%  (can be used as an affinity matrix input for spectral clustering)
%% Get required parameters
global pars

%% Generate adjacency matric for composition using k=10
% Data--> composition data with each row as one sample

if strcmp(pars.adjType,'kNN')
k=10;
dist = squareform(pdist(Data,'euclidean'));
[~,sortDistIndX]=sort(dist,2); % Sort each row 
 A=zeros(size(Data,1),size(Data,1));
 for i=1:size(Data,1)
     A(i,sortDistIndX(i,2:k))=1;
 end
else
    A = adjDelunay(Data);
end
 %% Autosclae data using Sigma
 
 if strcmp(pars.distfunc,'dtw')
     for i=1:size(Weights,1)
         for j=1:size(Weights,1)
             d(i,j)=dtw(Weights(i,:),Weights(j,:));
         end
     end
 else
    d = pdist2(Weights,Weights,pars.distfunc);
 end
 sigma=[];
 for i=1:size(Weights,1)
     [arrayDsort,IndexDsort]=sort(d(1,:));
     sigma(i)=arrayDsort(IndexDsort(pars.sKnn+1))+eps;
 end
 
 %% Task 2: Weight the Adjacency matrix using the distances between the samples
 % Weights--> Each row correspond to one sample response

for i=1:size(Weights,1)
    for j=1:size(Weights,1)
        wDist(i,j)=exp(-(d(i,j))^2/(sigma(i)*sigma(j)));
    end
end
 %wDist =exp( -1.*(squareform(pdist(Weights)).^2)./sigma);
 
W = wDist.*A;

 Wtemp=(W+W')/2;
 W=Wtemp;
end