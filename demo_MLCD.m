clearvars;clc;
load('data_xrdFePdGa.mat');

% Set up dataStruct input to MLCD
dataStruct.c = c;
dataStruct.data = dataPCA;

% Perfom MLCD
[Results]=MLCD(dataStruct,'bestcompcut',4);