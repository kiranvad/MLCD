function [c]=sampleTernary(n,varargin)
%% Generates a composition array
% [c]=sampleTernary(n,varargin)
% Inputs  :  n- #of data points in ternary of each direction
%            'plot'- 0 (No ternary plot,default) 1(plots a ternary)
% Outputs :  c- Ternary Sampling and a Ternanry plot

% (c) Copyright Kiran Vaddi 2019

%% Setting up the composition space
cMaster = linspace(0.02,1,n);
k=1;
pars.plot = 0;
pars.plot = extractpars(varargin,pars);
for i=1:length(cMaster)
    for j=1:length(cMaster)
        c(k,1)=cMaster(i);
        c(k,2)=cMaster(j);
        c(k,3)=1-cMaster(i)-cMaster(j);
        if c(k,3)>0
            k=k+1;
        end
    end
end
c(k,:)=[];

if isequal(pars.plot,1)
    c1 = c(:,1);c2 = c(:,2);c3 = c(:,3);
    figure;
    [h,hg,htick]=terplot; % for entire surface
    hter=ternaryc(c1,c2,c3);
end

end
