% Conformal clustering using Convex optimization
% Author : Son Phan

clear;
clc;

% generate tested data
% gendata; 

% load gendata from gendata folder
load('data_movie3_transp_3_500.mat');

% clustering using spectral clustering toolbox
[C, ~, U] = SpectralClustering(CLM,k,3);
FullC = full(C);
FullC(FullC(:,2)~=0,2) = 2;
FullC(FullC(:,3)~=0,3) = 3;
idx = sum(FullC,2);

figure
plot3(U(:,1),U(:,2),U(:,3),'o');
set(gca,'FontSize',30);
grid on

% evaluate

truelbl = newid;
truelbl(truelbl <= n & truelbl >=1) = 1;
truelbl(truelbl <= 2*n & truelbl >=n+1) = 2;
truelbl(truelbl <= 3*n & truelbl >=2*n+1) = 3;

[truelbl, sid] = sort(truelbl);
idx = idx(sid)';

clusterlabels = [truelbl; idx];

figure
subplot(2,1,1), imagesc(clusterlabels(1,:));
subplot(2,1,2), imagesc(clusterlabels(2,:));

save cluslbl.mat clusterlabels; % to evaluate CER index