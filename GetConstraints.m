function param = GetConstraints(data, param)
% C = GetConstraints(y, num_constraints, l, u)
%
% Get ITML constraint matrix from true labels.  See ItmlAlg.m for
% description of the constraint matrix format
m = param.Bags;
n = param.num_constraints;
C = zeros(param.num_constraints, 4);


for k=1:n
    i=1;j=1;
    while i==j
        i = int32(ceil(rand * m));
        j = int32(ceil(rand * m));
%         i = ceil(rand * m);
%         j = ceil(rand * m);
    end
    yi = data.train_target(:,i);
    yj = data.train_target(:,j);
    param.C(k,:) = [i j];
    param.loss(k) = exp(10*Hamming_loss(yi,yj));
end
end

