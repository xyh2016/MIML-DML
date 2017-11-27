function data=PCA_reduce(data,param)
retain_dimensions = param.Dim;
ntra=1;
for i=1:param.Bags
    Xi = data.train_bags{i,1};
    ni = size(Xi,1);
    X(ntra:ntra+ni-1,:) = Xi;    ntra = ntra+ni-1;
end

ntes=1;
for i=1:size(data.test_bags,1)
    Xi = data.test_bags{i,1};
    ni = size(Xi,1);
    Xtest(ntes:ntes+ni-1,:) = Xi;    ntes = ntes+ni-1;
end

Xr = [X;Xtest];
[U,S,V] = svd(cov(Xr));
reduced_X = Xr*U(:,1:retain_dimensions);

X = reduced_X(1:ntra,:);
Xtest = reduced_X(ntra+1:ntra+ntes,:);

[X,minp,maxp,Xtest,mint,maxt] = premnmx(X,Xtest);

ntra=1;
for i=1:param.Bags
    ni = size(data.train_bags{i,1},1);
    data.train_bags{i,1} = X(ntra:ntra+ni-1,:);
    ntra = ntra+ni-1;
end

ntes=1;
for i=1:size(data.test_bags,1)
    ni = size(data.test_bags{i,1},1);
    data.test_bags{i,1} = Xtest(ntes:ntes+ni-1,:);
    ntes = ntes+ni-1;
end

end