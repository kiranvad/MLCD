function[y]=superimpGauss(n,PeakH,PeakT,CutOf)
%% Generate Gaussian Super imposed data
% *INPUTS:*
% n- Number of data points in y
% PeakH- Intesnity of peak (0 0.5)
% PeakT- Position of peak (0 0.7)
% CutOf- Maximum current at 1 (>2);
% *OUTPUTS:*
% y- A gaussian superimposed data (in 0,1);
%%
x=linspace(0,1,n);

for i=1:length(x)
    y(i)=PeakH/7.98*normal(x(i),PeakT,0.05) + CutOf/0.54*normal(x(i),1.2,0.1);
end
function [out]=normal(x,mu,sigma)
invsqrt2pi = 0.398942280401433;
out=invsqrt2pi/sigma*exp(-0.5*((x-mu)/sigma)^2);