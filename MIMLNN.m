function [HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Average_Recall,Average_F1,Outputs,Pre_Labels,time]=...
    MIMLNN(train_bags,train_target,test_bags,test_target,ratio,lambda,A)
% This package implements the MIMLNN algorithm proposed in [1]
%
%    Syntax
%
%       [HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Average_Recall,Average_F1,Outputs,Pre_Labels]=MIMLNN(train_bags,train_target,test_bags,test_target,ratio)
%
%    Description
%
%       MIMLNN takes,
%           train_bags       - An M1x1 cell, the ith training bag is stored in train_bags{i,1}
%           train_target     - A QxM1 array, if the ith training bag belongs to the jth class, then train_target(j,i) equals +1, otherwise train_target(j,i) equals -1
%           test_bags        - An M2x1 cell, the ith test bag is stored in test_bags{i,1}
%           test_target      - A QxM2 array, if the ith test bag belongs to the jth class, test_target(j,i) equals +1, otherwise test_target(j,i) equals -1
%           ratio            - The number of clusters is set to ratio*M1, default=0.4
%           lambda           - The regularization parameter used to compute matrix inverse, default=1
%      and returns,
%           HammingLoss      - The hamming loss on testing data as described in [2]
%           RankingLoss      - The ranking loss on testing data as described in [2]
%           OneError         - The one-error on testing data as described in [2]
%           Coverage         - The coverage on testing data as described in [2]
%           Average_Precision- The average precision on testing data as described in [2]
%           Average_Recall   - The average precision on testing data as described in [2]
%           Average_F1       - The average precision on testing data as described in [2]
%           Outputs          - The output of the ith testing bag on the l-th class is stored in Outputs(l,i)
%           Pre_Labels       - If the ith testing bag belongs to the l-th class, then Pre_Labels(l,i) is +1, otherwise Pre_Labels(l,i) is -1
%
% [1] Zhou Z-H, Zhang M-L, Huang S-J, Li Y-F. Multi-instance multi-label learning. Artificial Intelligence, in press.
t0 = clock;
if(nargin<6)
    lambda=1;
end

if(nargin<5)
    ratio=0.4;
end

[num_class,num_train]=size(train_target);
num_cluster=floor(ratio*num_train);
num_test=size(test_target,2);
Outputs=zeros(num_class,num_test);
Pre_Labels=zeros(num_class,num_test);

distance_matrix=zeros(num_train,num_train);
for i=1:(num_train-1)
    if(mod(i,100)==0)
        disp(strcat('Computing distance for train bags:',num2str(i)));
    end
    B1=train_bags{i,1}; B1 = B1*A;
    n1=size(B1,1);
    for j=(i+1):num_train
        B2=train_bags{j,1}; B2 = B2*A;
        n2=size(B2,1);
        dist=sqrt(concur(sum(B1.*B1,2),n2)+concur(sum(B2.*B2,2),n1)'-2*B1*B2');
        distance_matrix(i,j)=max(max(min(dist)),max(min(dist')));
    end
end
distance_matrix=distance_matrix+distance_matrix';

[clustering,matrix_fai,num_iter]=MIML_cluster(num_cluster,distance_matrix);

dim=size(matrix_fai,2);
Weights=inv(matrix_fai'*matrix_fai+lambda*eye(dim))*matrix_fai'*train_target';

for i=1:num_test
    if(mod(i,100)==0)
        disp(strcat('Testing for test bags:',num2str(i)));
    end
    B1=test_bags{i,1};  B1 = B1*A;
    n1=size(B1,1);
    tempvec=zeros(1,num_cluster);
    for j=1:num_cluster
        index=clustering{j,1};
        B2=train_bags{index,1}; B2 = B2*A;
        n2=size(B2,1);
        dist=sqrt(concur(sum(B1.*B1,2),n2)+concur(sum(B2.*B2,2),n1)'-2*B1*B2');
        tempvec(1,j)=max(max(min(dist)),max(min(dist')));
    end
    Outputs(:,i)=(tempvec*Weights)';
end

for i=1:num_test
    for j=1:num_class
        if(Outputs(j,i)>=0)
            Pre_Labels(j,i)=1;
        else
            Pre_Labels(j,i)=-1;
        end
    end
end

HammingLoss=Hamming_loss(Pre_Labels,test_target);
RankingLoss=Ranking_loss(Outputs,test_target);
OneError=One_error(Outputs,test_target);
Coverage=coverage(Outputs,test_target);
Average_Precision=Average_precision(Outputs,test_target);
Average_Recall=Average_recall(Pre_Labels,test_target);
Average_F1=Average_f1(Outputs,Pre_Labels,test_target);
time = etime(clock, t0);
end