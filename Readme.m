% This is a simple example on how to use the MIMLNN package 
%
% Please type 'help MIMLNN' under the Matlab prompt for detailed usage explanations
% clear all;
addpath('Auxiliary');
load('sample_data.mat'); % Load the MIML data

ratio=0.4;  % Set the 'ratio' parameter, default=0.4
lambda=0.5; % Set the 'lambda' parameter, default=1

[HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Average_Recall,Average_F1,Outputs,Pre_Labels]=...
    MIMLNN(train_bags,train_target,test_bags,test_target,ratio,lambda); % Call the main function