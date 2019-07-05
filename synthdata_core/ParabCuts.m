function [dataClass]=ParabCuts(c,varargin)
%% Produces parabolic cuts in the tenrary space defined by C and throws the
% phase labels for the cuts in data class.
% [dataClass]=ParabCuts(c,varargin)
% *inputs*: c:  Comosition data N-by-3
%           'plotPhases' 0(default,does not plot the ternary phases) 1 (to plot)
% *outputs*: data: CV data generated as a gaussian superimposition N-by-n
%              phaseVal: Values of DOFS being set for each CV curve in data
%% Making Parabolic cuts in ternary space
syms x
class1(x)=(x-0.2)^2+0.4;
class2(x)=sqrt(0.2*x);
setPaths;

c1=c(:,1);c2=c(:,2);c3=c(:,3);

pars.plotPhases = 0;
pars = extractpars(varargin,pars);


for i=1:size(c,1)
    if c2(i)>class1(c1(i))
        dataClass(i)=1;
    elseif c2(i)<class2(c1(i))
        dataClass(i)=2;
    else
        dataClass(i)=3;
    end
end

if isequal(pars.plotPhases,1)
    figure;
    [h,hg,htick]=terplot; % for entire surface
    hter=ternaryc(c(dataClass==1,1),c(dataClass==1,2),c(dataClass==1,3));
    set(hter,'marker','.','markerfacecolor','none','markersize',20,'Color','b')
    hold on;
    hter=ternaryc(c(dataClass==2,1),c(dataClass==2,2),c(dataClass==2,3));
    set(hter,'marker','.','markerfacecolor','none','markersize',20,'Color','r')
    
    hter=ternaryc(c(dataClass==3,1),c(dataClass==3,2),c(dataClass==3,3));
    set(hter,'marker','.','markerfacecolor','none','markersize',20,'Color','g')
end
end