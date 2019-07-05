function [c,data,phaseVal,dataClass]=getSynthData(Ncomp,Ndata,varargin)
%% Generates a composition array
% [c,data,phaseVal]=getSynthData(Ncomp,Ndata,varargin))
% Inputs  :  
% Ncomp- #of data points in ternary of each direction
% Ndata- #of data points for each sample response
%'compPlot'- 0 (No ternary plot,default) 1(plots a ternary)
%'phasePlot'- 0 (No ternaryphase plot,default) 1(plots a ternaryphase)
%'dofType'- 1 (seperable DOFs,default) 2(Nonseperable DOFs)
% Outputs : 
% c- Ternary Sampling (each row is one sample)
% data - Sample responses (each column is one response)
% phaseVal - DOFs of each sample (each row is one sample)
% dataClass - indicies of phase cut
%
pars.dofType = 1;
pars.compPlot = 0;
pars.phasePlot = 0;
pars = extractpars(varargin,pars);
[c]=sampleTernary(Ncomp,'plot',pars.compPlot);
[dataClass]=ParabCuts(c,'plotPhases',pars.phasePlot);

if isequal(pars.dofType,1)
    [data,phaseVal]=generateSynthData(c,dataClass,Ndata);
else
    [data,phaseVal]=generateSynthData_nonSepDOFs(c,dataClass,Ndata);
end