function dg=myGaussDistance(g,Data,sigma)
dgNodes=g.Nodes;
nmat= table2array(g.Edges);

% adds eps to avoid zero-distances (no edge)

for i=1:length(nmat)    
    d(i)=exp(-(norm((Data(:,nmat(i,1))-Data(:,nmat(i,2))))^2)/(2*sigma^2))+eps;
end

dgEdges=sparse(nmat(:,1),nmat(:,2),d',size(g.Edges,1),size(g.Edges,2));
dg = graph(dgEdges,dgNodes);
% identify class
