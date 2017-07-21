% Conformal clustering based on assignment problem with parallel approach
% Author : Son Phan

clear;
clc;

%% gen test data from gaussian clusters
k = 3;
n = [500, 700, 800]; % ERROR : when numbers n are not equal !!!!!!!!!!!
par = [3 3 0.3; 3 5 0.3; 5 5 0.3];
[clusters, D, CCF, rawdata] = genGaussianClusters(k,n,par);

figure
for i = 1 : k
    plot(clusters{i}(:,1), clusters{i}(:,2),'+');
    hold on
end
grid on

%% Hungarian clustering using parallel approach
numiter = 5;
N = size(D,1);
% separate into m groups
m = 2;
numperg = N / m; % number of points per group
T = 0.15;
cost = zeros(1, numiter);

CBest = cell(1,1);
trackrecordsBest = struct;
trackParentBest = struct;
costBest = Inf;
pBest = zeros(1,N);

for iter = 1 : numiter
    
    % permutate data
    p = randperm(N);
    CParent = cell(1,m);
    trackParent = cell(1,m);
    % run Hungarian clustering on each group
    parfor i = 1 : m

        display('group ',num2str(i));
        [CParent{i},trackParent{i}] = iterativeClusteringParallel(p,i,numperg,D,T);

    end
    % run Hungarian one more time
    thres = 1e100;
    CNew = [CParent{1};CParent{2}];
    kNew = length(CNew);
    DNew = ones(kNew, kNew) * thres; % initialize new distance matrix
    for i = 1 : kNew
        for j = i + 1 : kNew

            DNew(i,j) = Hausdorffdistset(CNew{i}, CNew{j}, D);
            DNew(j,i) = DNew(i,j);      

        end

        if(sum(DNew(i,:) > T) == kNew)
            DNew(i,i) = -thres; % REVIEW !!!!!!!!!!!!!
        end
    end
    [outC, trackrecords] = iterativeClustering( CNew, DNew, D, T );
    kEst = length(outC);
    for i = 1 : kEst
        cost(iter) = cost(iter) + sum(sum(triu(D(outC{i},outC{i}),1)));
    end
    if(cost(iter) < costBest)
        costBest = cost(iter);
        CBest = outC;
        trackrecordsBest = trackrecords;
        trackParentBest = trackParent;
        pBest = p;
    end
    
    
end

% n = 1000;
% truelbl = newid;
% truelbl(truelbl <= n & truelbl >=1) = 1;
% truelbl(truelbl <= 2*n & truelbl >=n+1) = 2;
% truelbl(truelbl <= 3*n & truelbl >=2*n+1) = 3;
% 
% estidx = trackrecordsBest.Step2;
% estlbl = zeros(1,N);
% estlbl(estidx{1}) = 1;
% estlbl(estidx{2}) = 2;
% estlbl(estidx{3}) = 3;
% 
% [truelbl, sid] = sort(truelbl);
% estlbl = estlbl(sid);
% 
% clusterlabels = [truelbl; estlbl];
% 
% figure
% subplot(2,1,1), imagesc(clusterlabels(1,:));
% subplot(2,1,2), imagesc(clusterlabels(2,:));

p = pBest;

figure
plot(rawdata(p(1:1000),1),rawdata(p(1:1000),2),'b+','MarkerSize',10,'LineWidth',2);
hold on
plot(rawdata(p(1001:2000),1),rawdata(p(1001:2000),2),'r+','MarkerSize',10,'LineWidth',2);
grid on

% track = trackParentBest{2};
track = trackrecordsBest;
numstep = track.('num');

figure('visible','off');

plot(rawdata(p(1001:2000),1),rawdata(p(1001:2000),2),'+','color','red','MarkerSize',10,'LineWidth',2);
grid on
M(1) = getframe;   
clf;
    
for step = 1 : numstep
    str = strcat('Step',num2str(step));
    cls = track.(str);
    estk = length(cls);
    for i = 1 : estk
        idcl = cls{i};
        plot(rawdata(idcl,1), rawdata(idcl,2),'+','MarkerSize',10,'LineWidth',2);
        hold on
    end
    grid on
    M(step) = getframe;   
    clf;
end

figure
movie(M,1,0.5)

myVideo = VideoWriter('hung_para_fus.avi');
myVideo.FrameRate = 0.5;
open(myVideo);
writeVideo(myVideo, M);
close(myVideo);



fig = figure('Visible','Off');
plot(1:numiter,cost,'-o');
grid on
print(fig,'res','-dpng');




