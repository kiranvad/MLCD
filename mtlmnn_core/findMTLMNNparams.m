function [Kg,reg,reg0,maxiter_mt,Knn,mv,T]=findMTLMNNparams(task,varargin)
%function [K,mu,outdim,maxiter]=findMTLMNNparams(xTr,yTr,knn,varargin)
% This function automatically finds the best hyper-parameters for MT-LMNN

setpaths;
rmpath(genpath([pwd '/bayesopt.m']));

startup;

%% Setting parameters for Bayesian Global Optimization
opt = defaultopt(); % Get some default values for non problem-specific options.
opt.dims = length(task)+4; % Number of parameters.
%%min/max for Kg  reg(vector)      reg0  MAXITER Knn
opt.mins =  [2,1*ones(1,length(task)+1),100,2]; % Minimum value for each of the parameters. Should be 1-by-opt.dims
opt.maxes = [10,1000*ones(1,length(task)+1),1000,4]; % Vector of maximum values for each parameter. 
opt.max_iters = 100; % How many parameter settings do you want to try?
opt.grid_size = 25000;
opt=extractpars(varargin,opt);
opt.lt_const = -20*ones(1, length(task)); %[0 -4];
opt.do_cbo = 1;

%%% Following are optional for higher dimensions
% opt.optimize_ei=1;
% opt.ei_burnin=2;
% parpool(4);
% opt.parallel_jobs=2;
%% Start the optimization
F = @(P) optimizeMTLMNN(task,P); % CBO needs a function handle whose sole parameter is a vector of the parameters to optimize over.
[bestP,mv,T] = bayesopt(F,opt);   % ms - Best parameter setting found
                               % mv - best function value for that setting L(ms)
                               % T  - Trace of all settings tried, their function values, and constraint values.
try
    Kg = round(bestP(1));
    reg = bestP(2:length(task)+1);
    reg0 = bestP(length(task)+2);
    maxiter_mt = ceil(bestP(length(task)+3));
    Knn = round(bestP(length(task)+4));
    fprintf('\nBest minimum validation error: %2.4f %... \n',mv);
catch
    fprintf('Could not find parameters satisfying the constraints....\n  Assigning values of min validation error...\n');
    [mv,IdxMin]=min(T.values);
    bestP=T.samples(IdxMin,:);
    Kg = round(bestP(1));
    reg = bestP(2:length(task)+1);
    reg0 = bestP(length(task)+2);
    maxiter_mt = ceil(bestP(length(task)+3));
    Knn = round(bestP(length(task)+4));
    fprintf('\nBest minimum validation error: %2.4f %... \n',mv);  
end


function [valerr,C]=optimizeMTLMNN(task,P)
% function valerr=optimizeLMNN(xTr,yTr,xVa,yVa,P);
% mu=P(2);
% outdim=ceil(P(3));
% K=round(P(1));
% maxiter=ceil(P(4));
Kg = round(P(1));
reg = P(2:length(task)+1);
reg0 = P(length(task)+2);
maxiter_mt = ceil(P(length(task)+3));
Knn = round(P(length(task)+4));

% C1=nnz((abs(reg-reg0)/abs(reg0))*100>40);
% C2=-nnz((abs(reg/reg0))<0.5);
% C = [C1 C2];
for i=1:length(task)
    C(i) = reg(i)-reg0;
end
fprintf('\nTrying Kg=%i reg0=%2.4f maxiter=%i with C1=%i C2=%i... \n',Kg,reg0,maxiter_mt,C(1),C(2));
% [L,~] = lmnn2(xTr, yTr,K,'maxiter',maxiter,'quiet',1,'outdim',outdim,'mu',mu,'subsample',1.0);    
beta=MTlmnn_sp(task,Kg,[],'regweight',reg,'regweight0',reg0,'weight1',0.5,'maxiter',maxiter_mt,'quiet',1,'thesho',1e-05,'thesha',1e-09);
%valerr=knncl(L,xTr,yTr,xVa,yVa,knn,'train',0);
for st=1:length(task)
    % Validation set: general M0 + Mi
    tempEval(st,:)=knncl(decompose(beta.M0+beta.M{st}),task(st).x,task(st).y,task(st).xv,task(st).yv,Knn,'train',0);
end
% Validation set Errors
valerr=mean(tempEval,1);
fprintf('validation error=%2.4f\n',valerr);
