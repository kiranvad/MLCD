function [AdjMat]=adjDelunay(X)
%% Returns adjacency matrix from delaunay tesselation
% *INPUTS:* X each row is a data point in high dimensional space to be graphed
% *OUTPUTS:* AdjMat: adjacency matrix
%%
N=size(X,1);
tri = delaunay(X);
% Calculate adjacency matrix
AdjMat = zeros(N,N);
for i = 1:size(tri,1)
    temp = combnk(1:4,2);
    for j=1:size(temp,1)
        AdjMat(tri(i,temp(j,1)),tri(i,temp(j,2)))=1;
    end
end
AdjMat = 0.5*(AdjMat+AdjMat');
for i=1:size(AdjMat,1)
    AdjMat(AdjMat(:,i)==0.5,i)=1;
end

