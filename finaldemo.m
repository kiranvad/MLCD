%% Loading the required data
% This is a demo on the synthetic data described in the MTML paper with two
% distance metrics 1) Euclidean distance 2) Mahalanobis distance 
%%
setPaths;
dataNum = 4; % select data you would want to find phases for

% SET A1: sampleData_3
% SET A2: sampleData_4
% SET B1: sampleData_14
% SET B2: sampleData_15

load(['data/sampleData_' num2str(dataNum) '.mat']);

if isfield(dataStruct,'xTr')
    data = dataStruct(1).xTr;
else
    data = dataStruct(1).x;
end

dataClass= dataStruct.orgClass;
c=dataStruct.Comp;

%% Euclidean distance as similarity measure
figure(1);
% Find Phases using Spectral Clustering, Euclidean distance Metric,
% Delaunay tesselation to generate graph
idx=findphasesSC(c,data',3,'distfunc','euclidean','adjType','del');
%title('Euclidean as similarity');
[error]=findFmeasure(idx,dataClass);
fprintf('F-measure Euclidean :<strong> %0.2f</strong>\n ',error);

%% Mahalanobis distance as similarity measure
tempGraphD = dataStruct(1).Comp;

% Get Decomposed Mahalanobis distance Metric
if isfield(results,'L0')
    tempGraphW = (results.L0)*data; % transform data by L*x
else
    tempGraphW = results.xNew;
end

figure(2);

% Find phases using spectral clustering, Mahalanbosi distance measure from
% the MTML framework, Delaunay tesselation to generate graph
idx=findphasesSC(tempGraphD,tempGraphW',3,'sKNN',3,'distfunc','euclidean','adjType','del'); 
[error]=findFmeasure(idx,dataClass); % Compute accuracy
fprintf('F-measure MT LMNN :<strong> %0.2f</strong>\n ',error);

%% A sample demo to replicate the experiments from the paper:

fprintf('%%%%%%%%%%%%%%%%%%%%%% \n')

[~,indx_std] = runThroughClusters(c,data',dataClass,'k',[2 3]);

[~,indx_mtlmnn] = runThroughClusters(tempGraphD,tempGraphW',dataClass,...
    'k',[2 3],'singledist',1);
[~,indx_dtw] = runThroughClusters(c,data',dataClass,'k',[2 3],'singledist',1,...
    'singledistfunc','dtw');
indxcell = [indx_std indx_mtlmnn indx_dtw];

% A python file is also provided to compute various perfomance 
% measures used in the original Paper on MLCD
% One first needs to create a CSV file with different perormance measures
% This can be done using the following pieces of codes in Python:
% 	from helperfunctions.cluster_perfomance import *
% 	report_for_givenfolder  ('indxcell_saved_as_mat_file','dataClass_saved_as_mat_file','your_directory_name')
% Once the CSV files are created in a directory, you can then perform a one-sample one sided paired
% t-test using the file provided in MATLAB:
% 	perform_ttest(your_directory_name)












