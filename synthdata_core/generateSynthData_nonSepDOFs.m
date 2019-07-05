function [data,phaseVal]=generateSynthData_nonSepDOFs(c,dataClass,n)

%% Generates synthetic data for a given ternary and parabolic phase profiles
% Generate data such that the ternary has three phase defined 
% by ParabCuts.m with certain variation in the DOFs of data in each phase
% refer the original paper for more information.
% This script generates phases which are nor-seperable in DOF space
% *inputs*: c:  Comosition data N-by-3
%             dataClass: Phase seperation N-by-1
%             n: dimension of a single CV curve
% *outputs*: data: CV data generated as a gaussian superimposition N-by-n
%            phaseVal: Values of DOFS being set for each CV curve in data

% (c) Copyright Kiran Vaddi 2019
%%
data=[];
for i=1:size(c,1)
    if dataClass(i)==1
        data(:,i)=superimpGauss(n,round(c(i,2)+c(i,3),1),0.1+round(c(i,3),1),2+round(5*c(i,2),1));
        phaseVal(i,:)=[round(c(i,2)+c(i,3),1) 0.1+round(c(i,3),1) 2+round(5*c(i,2),1)];
    elseif dataClass(i)==2
        data(:,i)=superimpGauss(n,round(c(i,2),1),0.1+round(c(i,2)+c(i,1),1),2+round(5*(c(i,1)),1));
        phaseVal(i,:)=[round(c(i,2),1) 0.1+round(c(i,2)+c(i,1),1) 2+round(5*(c(i,1)),1)];
        
    elseif dataClass(i)==3
        data(:,i)=superimpGauss(n,round(c(i,3),1),0.1+round(c(i,1),1),round(5*(c(i,1)+c(i,3)+c(i,2)),1));
        phaseVal(i,:)=[round(c(i,3),1) 0.1+round(c(i,1),1) round(5*(c(i,1)+c(i,3)+c(i,2)),1)];
        
    end
end

end
