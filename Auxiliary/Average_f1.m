function Average_F1=Average_f1(Outputs,Pre_Labels,test_target)
%Computing the average recall
%Outputs: the predicted outputs of the classifier, the output of the ith instance for the jth class is stored in Outputs(j,i)
%Pre_Labels: the predicted labels of the classifier, if the ith instance belong to the jth class, Pre_Labels(j,i)=1, otherwise Pre_Labels(j,i)=-1
%test_target: the actual labels of the test instances, if the ith instance belong to the jth class, test_target(j,i)=1, otherwise test_target(j,i)=-1

    AP=Average_precision(Outputs,test_target);
    AR=Average_recall(Pre_Labels,test_target);
    Average_F1=2*AP*AR/(AP+AR);