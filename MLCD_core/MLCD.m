function [Results]=MLCD(dataStruct,varargin)
%function [results]=MLCD(dataStruct,varargin)
% Metric Learning for Combinatorial Datasets
% Inputs: 
%         dataStruct  : should have the following fields
%                     c       :   Composition matrix n-by-compD
%                     data    :   High dimensional response matrix highD-by-n
%         Options     : Can be any of the following
%                     quiet       :   0 (does not print some updates, default) 1(otherwise)
%                     needtasks   :   1 (creates tasks, default) 0 (assumes that dataStruct has tasks defined)
%                     saveresults :   0 (does not save results into a .mat file, default) 1(otherwise)
%                     bestcompcut :   number of cuts in the composition space of task (default 3 cuts). 
%                                     Would need "needtasks" to be set to 1
%                     'LMNNinit'  :   1 (to activate initialization of each M_t with LMNN,default), 
%                                     0 (otherwise)
%                     parpool     :   1 (parallel computation on, default) 0 (does not use parallel computation)
%                     pcaproj     :   1 (to use a pca projected data) 0(default, otherwise)
%         Results     :   Has the following fields as output
%                         Kg              :   Number of neighbours to which the Kg-NN error is minimized
%                         reg             :   regulaireser parameters \gamma_t
%                         reg0            :   regulalriser parameter \gamma_0
%                         L0              :   L0*L0^T = M0 (Learned metric)
%                         DataStruct      :   Data Structure used to build L0
% See also, extractpars.m , createTasks.m, findLMNNParams.m, lmnnCG.m, knncl.m, findMTLMNNParams.m, MTlmnn_sp.m .
%
% For any questions, please send an email to: kiranvad@buffalo.edu
%
% (c) copyright Kiran Vaddi 06-2019

c= dataStruct.c;
data = dataStruct.data;

pars.quiet = 0;
pars.needtasks = 1;
pars.saveresults = 0;
pars.bestcompcut = 3;
pars.LMNNinit = 1;
pars.parpool = 0;
pars.pcaproj = 0;

pars = extractpars(varargin,pars);
%% Create task with default settings with with Tr/val 95/5 %
if pars.needtasks
    fprintf('Creating task with %i classes \n',pars.bestcompcut)
    [dataStruct]=createTasks(c,data,0.95,'labelNums',pars.bestcompcut,'pcaProjection',pars.pcaproj);
end

%% Setting up the data for MT LMNN parameter search
for i=1:length(dataStruct)
    task(i).x=dataStruct(i).x;
    task(i).xv=dataStruct(i).xv;
    task(i).yv=dataStruct(i).yv;
    task(i).y=dataStruct(i).y;
end
results.task = task;
results.dataStruct = dataStruct;

%% Setting up L_for_nn in each task using LMNN CG
if pars.LMNNinit
    p = gcp('nocreate'); % If no pool, do not create new one.
    if pars.parpool && isempty(p)
        parpool;
    end
    parfor i=1:length(task)
        [Klmnn,knn,~,maxiter]=findLMNNparams(task(i).x,task(i).y,task(i).xv,task(i).yv);
        [L,~] = lmnnCG(task(i).x, task(i).y,Klmnn,'maxiter',maxiter,'quiet',0);
        L_for_nn{i} = L;
        kLMNN{i} = knn;
    end
    for i=1:length(task)
        task(i).L_for_nn = L_for_nn{i};
        task(i).kLMNN = kLMNN{i};
    end
    clearvars L_for_nn kLMNN
    
    fprintf('****************************************************************\n')
    disp('LMNN intialization errors');
    for i=1:length(task)
        temperror=knncl(task(i).L_for_nn,task(i).x, task(i).y,task(i).xv,task(i).yv,task(i).kLMNN);
        fprintf('Task %i: \t Training Error: %0.2f%% \t Validation Error: %0.2f%% \n',i,temperror(1)*100,temperror(2)*100);
    end
    fprintf('****************************************************************\n')
end
%% MT LMNN 
[Kg,reg,reg0,maxiter_mt,Knn,mv,T]=findMTLMNNparams(task);

results.kg=Kg;
results.reg=reg;
results.reg0=reg0;
results.maxiter_mt=maxiter_mt;
results.mv=mv;
results.T=T;
results.Knn=Knn;

beta=MTlmnn_sp(task,Kg,[],'regweight',reg,'regweight0',reg0,'weight1',0.5,'maxiter',maxiter_mt,'quiet',1);
error = [];
fprintf('****************************************************************\n')
for i=1:length(task)
    temperror = knncl(decompose(beta.M0),task(i).x,task(i).y,task(i).xv,task(i).yv,Knn);
    fprintf('Task %i: \t Training Error: %0.2f%% \t Validation Error: %0.2f%% \n',i,temperror(1)*100,temperror(2)*100);
    error = [error;temperror];
end
results.trainError = error(1:2:2*length(task));
results.valError = error(2:2:2*length(task));
results.M0=beta.M0;
results.M=beta.M;
[L,dd]=decompose(beta.M0);
results.EigM0=dd;
xOld = task(1).x;
results.xOld = xOld;
results.xNew = L*xOld;
results.L0 = L;

[~,maxIdx]=max((abs(results.reg-results.reg0))/results.reg0*100);
[L,dd]=decompose(beta.M0+beta.M{maxIdx});
results.xNewMT = L*xOld;
results.L0T = L;
results.EigM0T = dd;

Results.Kg = results.kg;
Results.reg = results.reg;
Results.reg0 = results.reg0;
Results.L0 = results.L0;
Results.DataStruct = dataStruct;
if pars.saveresults
    t = datetime('now','Format','yyyy-MM-dd''T''HHmmss');
    S = char(t);
    yourFolder = [pwd '/results'];
    if ~exist(yourFolder, 'dir')
        mkdir(yourFolder)
    end
    filename = [yourFolder,'/results_','_',S,'.mat'];
    save(filename,'Results');
end





