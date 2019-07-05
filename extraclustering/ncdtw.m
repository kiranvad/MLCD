function [d]=ncdtw(singObsrv,dataMat,varargin)
%% Calculates NC-DTW distance to be used in getWtGraph.m
% [d]=ncdtw(singObsrv,dataMat,varargin)
% *INPUTS:* 
% singObsrv: signal to which ND-DTW distance is t be calculated (n-by-1)
% dataMat: Complete data matrix (n-by-d)
% 'maximps': (default 50) number of data points used for DTW window


pars.maximps = 50;
pars = extractpars(varargin,pars);

normData = dataMat./max(dataMat,[],2);
normObsrv = singObsrv/max(singObsrv);
for j=1:size(dataMat,1)
    d(j)=dtw(normObsrv,normData(j,:),pars.maximps);
end
