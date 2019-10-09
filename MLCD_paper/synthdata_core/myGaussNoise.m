function [noisyD]=myGaussNoise(Data,varargin)
%% Adds gaussian noise to the Data
% *INPUTS:* Data: data matrix to which noise to be added (n-by-d)
% *OUTPUTS:* noisyD: noisy data matrix of Data (n-by-d)

% (c) Copyright Kiran Vaddi 2019
%%
if isempty(varargin)
    fprintf('Genrating noise with mean: %0.2f, stddev: %0.2f..\n ',0.0,1.0)
    meanVal=0;
    stddev = 1;
else
    if (length(varargin)<1)
        fprintf('Mean Value is set to: %0.2f..\n',0.0);
    else
        meanVal  = varargin{1};
        fprintf('Mean Value is set to: %0.2f..\n',meanVal);
    end
    if (length(varargin)<2)
        fprintf('Standard deviation is set to: %0.2f..\n',1.0);
    else
        stddev = varargin{2};
        fprintf('Standard deviation is set to: %0.2f..\n',stddev);
    end
end
noisyD = zeros(size(Data));
for i=1:size(Data,2)
    tempnoise= meanVal + stddev*randn(1,numel(Data(:,i)));
    noisyD(:,i)=Data(:,i)+tempnoise';  % for example
end
end
