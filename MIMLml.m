function [HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Average_Recall,Average_F1,Outputs,Pre_Labels,time]=...
    MIMLml(train_bags,train_target,test_bags,test_target,ratio,svm,svm_cost)
addpath('Auxiliary');
warning('off');
data.train_bags = train_bags; data.train_target = train_target;
data.test_bags = test_bags; data.test_target = test_target;
tic;
param = initParam(data,ratio,svm,svm_cost);
data = PCA_reduce(data,param);
param = distanceExtremes(data,param);
param = GetConstraints(data, param);
result = optimization(param,data);
% result.A = eye(param.Dim);

[HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Average_Recall,Average_F1,Outputs,Pre_Labels,time]=...
    MIMLSVM_Maha(data.train_bags,data.train_target,data.test_bags,data.test_target,param.svm_ratio,param.svm,param.svm_cost,result.A);
time=toc;
end

function param = initParam(data,ratio,svm,svm_cost)
param.a = 5; param.b = 95;
param.lamda=1;  param.beta = 0.1;
param.Bags = size(data.train_bags,1);   % number of bags / use all the training bags
param.num_constraints = 100;            % number of bag pairs / choose from the training bags
% param.Dim = size(data.train_bags{1,1},2);
param.Dim = 30;
param.nn_ratio = 0.4;
param.nn_lambda= 0.5;
param.svm_ratio=ratio;
param.svm_cost=svm_cost;% the value of "C"
param.svm=svm;
end

function param = distanceExtremes(data,param)
for i=1:param.Bags
    X = data.train_bags{i,1};   Xt = X;
    [n,m] = size(X);    nt = n;
    D2=repmat(sum((X.^2)')',1,nt)+repmat(sum((Xt.^2)'),n,1)-2*X*Xt';
    dists(i)=sum(sum(D2))/n/(n-1);
    param.bag_instance_num(i) = n;
end
[f, c] = hist(dists, 100);
param.u = c(floor(param.a));
param.l = c(floor(param.b));
end

function result = optimization(param,data)
d = param.Dim;  n_xi = param.Bags;  n_zeta = param.num_constraints;   
C = param.C;    loss = param.loss;
lamda = param.lamda;    beta = param.beta;  
X = data.train_bags;
bin = param.bag_instance_num;
%
for i=1:param.Bags
    if size(X{i,1},1)==1
        Xavg(i,:) = X{i,1};
    else
        Xavg(i,:) = mean(X{i,1});
    end
end

%
ntra=1;
for i=1:param.Bags
    Xi = data.train_bags{i,1};
    ni = size(Xi,1);
    Xall(ntra:ntra+ni-1,:) = Xi;    ntra = ntra+ni;
end


for i=1:n_zeta
    Xa1(i,:) = Xavg(C(i,1),:);
    Xa2(i,:) = Xavg(C(i,2),:);
end
%
cvx_begin
variables A(d,d) zetas(n_zeta) xi(ntra);
% minimize( trace(A)-det_rootn(A) + beta*sum(zetas) + lamda*sum(xi) )
minimize( trace(A)-det_rootn(A) + beta*sum(zetas) + lamda*sum(xi) )
% minimize( trace(A) + beta*sum(zetas) + lamda*sum(xi) )
subject to
for i=1:n_xi
    norm(Xall(i,:)*A)<=1+xi(i);
end
for i=1:n_zeta
    trace(A*(Xa1(i,:)-Xa2(i,:))'*(Xa1(i,:)-Xa2(i,:)))>=loss(i)-zetas(i);
end
zetas>0;
xi>0;
cvx_end
% A
% zetas
result.A = A;
end


