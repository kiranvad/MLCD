function [dataStruct]=createTasks(c,data,SRval,varargin)
%% Genrates tasks with Uniform data points in each class
% [dataStruct]=createTasks(c,data,SRval,varargin)
% *Inputs*:
%         c: Compsition data(each row is a composotion array, in fractions only)
%         data: Data to be trained on(each column is a response)
%         SRval: Train/val ratio
%         Parameters: 'orgClass' original classes
%                     'PhaseVal' original DOFs
%                     'labelNums' number of classes in each task (default 3)
%                     'TxtMsg' Message to be printed in the diary file 
%                         created with few details about the data structure
%                     'TaskType' 1(Uniform, default) 2(NonUniform)
%                      'pcaProjection' (def 1)use a PCA projection 0-actual data
%                      'quiet' (def 1) does not print status 0-print status
%                         
% *Output*: dataStruct: data is stored as a structure for MT LMNN  
%  .mat file of dataStruct is saved with the time stamp shown in the
%  command line after run. A dairy file with the same name will have few
%  details about the dataStruct 
%  in the command line

%% Creates training data as a structure for MT LMNN
dataStruct.Comp = c;
pars.orgClass = [];
pars.PhaseVal = [];
pars.labelNums = 3;
pars.TaskType = 1;
pars.TxtMsg = 'No comments about the data structure';
pars.quiet = 1;
pars.pcaProjection = 0;

pars = extractpars(varargin,pars);

labelNums = pars.labelNums;
dataStruct.orgClass = pars.orgClass;
dataStruct.PhaseVal = pars.PhaseVal;

if ~pars.quiet
    clc;
    fprintf('%s...\n',pars.TxtMsg);
end

if pars.pcaProjection
    % creating dataStruct with PCA projection instead
    [~,evals,Xpca] = pcaKW(data);
    temp=cumsum(evals/sum(evals));
    if find(temp>=0.99,1)>100
        data=Xpca(1:find(temp>=0.99,1),:);
    else
        data=Xpca(1:100,:);
    end
    if ~pars.quiet
        fprintf('Using PCA Projected data\n')
    end
end

numClass=floor(size(c,1)/labelNums);
%% sets up directories and names
if ~pars.quiet
    t = datetime('now','Format','yyyy-MM-dd''T''HHmmss');
    S = char(t);
    
    myFolder = [pwd '/data/Diaries'];
    if ~exist(myFolder, 'dir')
        mkdir(myFolder)
    end
    
    diaryName = [myFolder '/my_diary_',S,'.out'];
    diary(diaryName);
end
%% Creating Tasksets
if isequal(pars.TaskType,1)
    % set original data as different train data
    for i=1:size(c,2)
        dataStruct(1,i).xTr = data;
        [~,sortIndex]=sort(c(:,i));
        tempLabels = zeros(1,size(c,1));
        k=0;
        for j=1:labelNums
            tempLabels(1,sortIndex(k+1:k+numClass))=j;
            k=j*numClass;
        end
        tempLabels(tempLabels==0)=labelNums;
        dataStruct(1,i).yTr = tempLabels;
        [C,~,ic] = unique(tempLabels);
        a_counts = accumarray(ic,1);
        value_counts = [C' a_counts];
        if ~pars.quiet
            fprintf('Labels for Task %i training: \n',i);
            disp(value_counts);
        end
    end
    % Create Validation set using splitratio SRval
    for i=1:size(c,2)
        [train,test]=makesplits(dataStruct(i).yTr,SRval,1,1);
        dataStruct(i).x = dataStruct(i).xTr(:,train);
        dataStruct(i).y = dataStruct(i).yTr(:,train);
        dataStruct(i).xv = dataStruct(i).xTr(:,test);
        dataStruct(i).yv = dataStruct(i).yTr(:,test);
        
        [C,~,ic] = unique(dataStruct(i).yv);
        a_counts = accumarray(ic,1);
        value_counts = [C' a_counts];
        if ~pars.quiet
            fprintf('Labels for Task %i Validation: \n',i);
            disp(value_counts);
        end
    end
else
    % set original data as different train data
    for i=1:size(c,2)
        dataStruct(1,i).xTr = data;
        tempOrg=1+round(c(:,i)*10);
        tempOrg(tempOrg==11)=10;
        dataStruct(1,i).yTr = tempOrg';
        [C,~,ic] = unique(tempOrg');
        a_counts = accumarray(ic,1);
        value_counts = [C' a_counts];
        if ~pars.quiet
            fprintf('Labels for Task %i training: \n',i);
            disp(value_counts);
        end
    end
    % Create Validation set using splitratio SRval
    for i=1:size(c,2)
        [train,test]=makesplits(dataStruct(i).yTr,SRval,1,1);
        dataStruct(i).x = dataStruct(i).xTr(:,train);
        dataStruct(i).y = dataStruct(i).yTr(:,train);
        dataStruct(i).xv = dataStruct(i).xTr(:,test);
        dataStruct(i).yv = dataStruct(i).yTr(:,test);
        
        [C,~,ic] = unique(dataStruct(i).yv);
        a_counts = accumarray(ic,1);
        value_counts = [C' a_counts];
        if ~pars.quiet
            fprintf('Labels for Task %i Validation: \n',i);
            disp(value_counts);
        end
    end
end   
%% save dataStruct as .mat file
if ~pars.quiet
    filename = ['data/dataStruct_',S,'.mat'];
    save(filename,'dataStruct');
    fprintf('generated file with the name: <strong> %s </strong>\n',filename);
    diary off;
end