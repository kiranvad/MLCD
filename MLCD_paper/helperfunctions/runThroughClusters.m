function [error,idxcell] = runThroughClusters(dataC,dataX,orig_labels,varargin)
%[error] = runThroughClusters(dataC,dataX,orig_labels,varargin)
% Computes F-measure using a sweep of HCA and Spectral Clustering with a graph built using 
% kNN algorithm 
% Inputs  :   
%             dataC           :   composition data as n-by-3 matrix
%             dataX           :   High dimensional data as n-by-d matrix
%             orig_labels     :   Original labels to compute F-measure
%             'k'             :   Number of clusterers to be varied as a two dimensional
%                                 row vector (defualt, [2 10])
%             'quiet'         :   Surpress output using 1, (defualt, produces 0)
%             'singledist'    :   Activate run though only using a one distance
%                                 Particulary useful to MT-LMNN,DTW runthrough
%	     'singledistfunc' :   Distance measure to be used along 
%				  with 'singledist' option above
%             
% Outputs  :
%             error           :   F-measure with each column as a distance metric
%                                 in the order of distance function otption listed below
%                                     1. Euclidean
%                                     2. Cosine
%                                     3. Correlation
%                                     4. Standardised Euclidean
%                                     5. Cuty block
%                                     6. Minkowski
%                                     7. ChebyChev
%                                     8. Hamming
%                                     9. Jacard
%             idxcell 	     : Also outputs an indices for each setting
%                     
% See also, clusterdata,findphasesSC,findFmeasure
% 
% For questions send an email to: kiranvad@buffalo.edu

%% Intitalizing inputs
pars.k = [2 10];
pars.quiet = 0;
pars.singledist = 0;
pars.singledistfunc = 'euclidean';

pars = extractpars(varargin,pars);


%% Intitializing some variables
error ={};
idxcell = {};
%% Start Parllel Pool
p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    parpool;
end

%% Run though HCA

% You may add more distance functions
if ~pars.singledist
    distanceFuncs={'euclidean','cosine','correlation','seuclidean',...
        'cityblock','minkowski','chebychev','hamming',...
        'jaccard'};
else
    distanceFuncs{1} = pars.singledistfunc;
end

linkageFuncs = {'average','single','complete'};
adjType = {'kNN','del'};

% clabel = {'Fe','Fe$_{40}$Ga$_{60}$','Fe$_{40}$Pd$_{60}$'};
parfor i=1:length(distanceFuncs)
    temperror = [];
    tempidxs = [];
    for j=1:length(linkageFuncs)
        if strcmp(distanceFuncs{i},'dtw')
            distanceFuncs{i}=@distdtw;
        end
        for k=pars.k(1):pars.k(2)
            
            idx = clusterdata(dataX,'Maxclust',k,'distance',...
                distanceFuncs{i},'Linkage',linkageFuncs{j});
            temperror = [temperror;findFmeasure(idx,orig_labels)];
            tempidxs = [tempidxs idx];
        end
    end
    
    if strcmp(pars.singledistfunc,'dtw')
        distanceFuncs{i}='dtw';
    end
    
    for k=pars.k(1):pars.k(2)
        for sKNN = 2:6
            for adjtype = 1:2
                try
                    idx=findphasesSC(dataC,dataX,k,'sKNN',sKNN,...
                        'distfunc',distanceFuncs{i},'plot',0,'adjType',adjType{adjtype});
                    temperror = [temperror;findFmeasure(idx,orig_labels)];
                    tempidxs = [tempidxs idx];
                catch
                    fprintf('skipped Spectral Clustering: %s\t%i\t%s\t%i\n',distanceFuncs{i},...
                        k,adjType{adjtype},sKNN)
                end
            end
        end
    end
    
    error{i}=temperror;
    idxcell{i} = tempidxs;
    
    if ~pars.quiet
        fprintf('Computed %s\n',distanceFuncs{i});
    end
end

