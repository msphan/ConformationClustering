% Conformal clustering using Convex optimization
% Author : Son Phan

clear;
clc;

% generate tested data
% gendata; 

% load gendata from gendata folder
load('data_movie3_transp_3_500.mat');

%% solve convex optimisation using CVX toolbox

cvx_begin

variable Y(N,N) symmetric

dum = triu(ones(N),1);

minimize(sum(sum(D .* Y)));

Y(eye(N)==1) == 1;
Y(dum==1) >= (-1/(k-1));
Y == semidefinite(N);

cvx_end


%% k means
idx = kmeans(Y,k,'Replicates',5);


%% Save idx and newid to compute CER index

truelbl = newid;
truelbl(truelbl <= n & truelbl >=1) = 1;
truelbl(truelbl <= 2*n & truelbl >=n+1) = 2;

[truelbl, sid] = sort(truelbl);
idx = idx(sid)';

clusterlabels = [truelbl; idx];

figure
subplot(2,1,1), imagesc(clusterlabels(1,:));
subplot(2,1,2), imagesc(clusterlabels(2,:));

save cluslbl.mat clusterlabels; % to evaluate CER index


