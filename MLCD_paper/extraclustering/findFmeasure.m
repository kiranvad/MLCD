function [F]=findFmeasure(predlabels,origlabels)
%% Finds multi class F-measure to compute accuracy of clustering method
% *INPUTS*: predlabels:  Labels predicted by clustering algorithm
%             origlabels:  Labels as a reference
% *OUTPUTS*: F: Multi-class F-measure

%%
N = length(origlabels);
tempF=0;
term2=[];
for m=1:length(unique(origlabels))
    for n=1:length(unique(predlabels))
        Am = find(origlabels==m);
        Cn = find(predlabels==n);
        [Pmn]=findPrecision(Am,Cn);
        [Rmn]=findRecall(Am,Cn);
        term2(n)=(2*Pmn*Rmn)/(Pmn+Rmn);
    end
    tempF = tempF+(max(term2)*((numel(Am))/N));
end
F = tempF;

function [Pmn]=findPrecision(Am,Cn)
Pmn = numel(intersect(Am,Cn))/numel(Cn);

function [Rmn]=findRecall(Am,Cn)
Rmn = numel(intersect(Am,Cn))/numel(Am);
