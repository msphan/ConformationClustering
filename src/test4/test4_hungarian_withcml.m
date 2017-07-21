% Conformal clustering based on assignment problem 
% Author : Son Phan

clear;
clc;

load data_movie3_transp_3_150vs200vs250_noiseless.mat;

thres = 1e100;
D(logical(eye(size(D)))) = thres;

%% clustering using Hungarian based hierarchical method
T = 7; % ERROR at T (may by problem of papers)
[C, trackrecords] = iterativeClustering(D,T);

%% evaluate
truelbl = 1 : N;
truelbl(truelbl <= n1 & truelbl >=1) = 1;
truelbl(truelbl <= n1+n2 & truelbl >=n1+1) = 2;
truelbl(truelbl <= n1+n2+n3 & truelbl >=n1+n2+1) = 3;

sid = 1 : N;
sid(C{1}) = 1; sid(C{2}) = 2; sid(C{3}) = 3;

clusterlabels = [truelbl; sid];

figure
subplot(2,1,1), imagesc(clusterlabels(1,:));
subplot(2,1,2), imagesc(clusterlabels(2,:));

