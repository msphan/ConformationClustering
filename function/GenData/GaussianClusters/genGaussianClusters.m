function [ clusters, D, CCF, raw ] = genGaussianClusters( k, n, par )
%GEN Summary of this function goes here
%   Detailed explanation goes here

clusters = cell(k,1);

thres = 1e100;

for i = 1 : k
    
    m1 = par(i,1); m2 = par(i,2); s = par(i,3);
    mu = [m1,m2];
    sigma = [s,0;0,s];
    rng default  % For reproducibility
    r = mvnrnd(mu,sigma,n(i)); 
    clusters{i} = r;
    
end

raw = cell2mat(clusters);
N = sum(n);
D = zeros(N, N);

for i = 1 : N
    for j = i + 1 : N
        
        D(i,j) = sqrt(sum((raw(i,:) - raw(j,:)).^2));
        D(j,i) = D(i,j);
        
    end
end

D = D / max(D(:));

CCF = 1 - D.^2;

D(logical(eye(size(D)))) = thres;


end

