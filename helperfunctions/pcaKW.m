function [evects,evals,Xpca] = pcaKW(X)
% [evects,evals] = pca(X)
%
% finds principal components of 
%
% input: 
%  X  dxn matrix (each column is a dx1 input vector)
% 
% output: 
% evects  columns are principal components (leading from left->right)
% evals   corresponding eigenvalues
% Xpca    X after PCA transformation (optional)
%
%
% copyright by Kilian Q. Weinberger, 2006-2015

[d,N]  = size(X);

X=bsxfun(@minus,X,mean(X,2));
cc = cov(X',1); % compute covariance 
[cvv,cdd] = eig(cc); % compute eignvectors
[zz,ii] = sort(diag(-cdd)); % sort according to eigenvalues
evects = cvv(:,ii); % pick leading eigenvectors
cdd = diag(cdd); % extract eigenvalues
evals = cdd(ii); % sort eigenvalues
if nargout>2,
    Xpca=evects'*X;
else
    Xpca=[];
end;
%     [evects,evals,Xpca] = pcaKW(zscore(dataStruct(i).x));
%     temp=cumsum(evals/sum(evals));
%     task(i).xLpca=evects;
%     task(i).x=Xpca(1:find(temp>=0.99,1),:);
%     
%     task(i).xv=Xpca(1:find(temp>=0.99,1),:);
