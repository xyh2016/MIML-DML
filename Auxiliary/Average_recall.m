function Average_Recall=Average_recall(Pre_Labels,test_target)
%Computing the average recall
%Pre_Labels: the predicted labels of the classifier, if the ith instance belong to the jth class, Pre_Labels(j,i)=1, otherwise Pre_Labels(j,i)=-1
%test_target: the actual labels of the test instances, if the ith instance belong to the jth class, test_target(j,i)=1, otherwise test_target(j,i)=-1

    [num_class,num_instance]=size(Pre_Labels);
    
    counter=0;
    N=num_instance;
    
    for i=1:num_instance
        P_index=find(Pre_Labels(:,i)==1);
        T_index=find(test_target(:,i)==1);
        if(isempty(T_index))
            N=N-1;
        else
            C_index=intersect(P_index,T_index);
            incre=length(C_index)/length(T_index);
            counter=counter+incre;
        end
    end
    
    Average_Recall=counter/N;