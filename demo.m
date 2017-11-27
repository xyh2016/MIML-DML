% This function is a demo of disntance metric learning for multi-instance multi-label classification problem.
%   Thanks for initial version of this program to Dr. Yonghui Xu.
%   If you use this program in your results, please quote the paper:
%   "Multi-instance multi-label distance metric learning for genome-wide protein function prediction"

function demo
warning('off');
addpath('auxiliary'); addpath('libsvm2.86');
data=loadData(0.5);   result=testpercent(data,'0.5');
result
end

function result=testpercent(data,percent)
gmax = 1;
pmax = 1;
cf = 1;
w = [0.001,0.01,0.1,1,10,100];
tic
% resw = zeros(4,5,5);
for i=1:gmax
    for wi=1:pmax
        for j=1:cf
            dataij = data.MLprotein(i).test(j);
            train_bags = dataij.train_bags;
            train_target = dataij.train_target;
            test_bags = dataij.test_bags;
            test_target = dataij.test_target;
            result(i,5,j).a = runMIMLml(train_bags,train_target,test_bags,test_target,w(wi));
            fprintf('done i=%d/7,   j=%d/%d,    time=%fm\n',i,j,cf,toc/60);
            save(['result\result_MIML_protein_ml_',percent,'_',num2str(i),'_',num2str(j),'.mat'],'-mat','result');
            tmp(:,j) = result(i,5,j).a.sim(:);
        end
        for k=1:5
            resw(k).a(i,wi)=mean(tmp(k,:));
        end
        save(['result\result_MIML_protein_ml_resg',percent,'_',num2str(i),'_',num2str(j),'.mat'],'-mat','resw');
    end
end
end

function data=loadData(type)
if strcmp(type,'ori')
    data = load('data\MIMLprotein.mat');
else
    data = load(['data\MIMLprotein_',num2str(type),'.mat']);
end
end
%% %%%%%%%%%%%%%%%%%
%%
function result = runMIMLml(train_bags,train_target,test_bags,test_target,w)
addpath('MIMLml - svm');
ratio=0.2;
svm.type='RBF';
svm.para=0.2;
svm.weight=w;
cost=1;
%call MIMLml
[HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Average_Recall,Average_F1,Outputs,Pre_Labels,time]=...
    MIMLml(train_bags,train_target,test_bags,test_target,ratio,svm,cost);
result=combineResult...
    (HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Average_Recall,Average_F1,Outputs,Pre_Labels,time);
end

function result=combineResult...
    (HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Average_Recall,Average_F1,Outputs,Pre_Labels,time)
result.HammingLoss = HammingLoss;   result.RankingLoss = RankingLoss;
result.OneError = OneError; result.Coverage = Coverage;
result.Average_Precision = Average_Precision;   
% result.Outputs = Outputs;
% result.Pre_Labels = Pre_Labels;
result.Average_Recall = Average_Recall;
result.Average_F1 = Average_F1;
result.time = time;
result.sim(1)=RankingLoss;
result.sim(2)=Coverage;
result.sim(3)=Average_Precision;
result.sim(4)=Average_Recall;
result.sim(5)=Average_F1;
end