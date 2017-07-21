% Conformal clustering based on assignment problem 
% Author : Son Phan

clear;
clc;

%% gen test data from gaussian clusters
k = 3;
n = [300, 500, 700]; 
par = [3 3 0.4; 5 5 0.4; 7 7 0.4];
[clusters, D, CCF, rawdata] = genGaussianClusters(k,n,par);

%% clustering using Hungarian based hierarchical method

inC = cell(size(D,1),1); % initialize cluster
for i = 1 : size(D,1), inC{i} = i; end
inD = D; % initialize distance matrix
T = 0.1; % NEED TO STUDY
[C, trackrecords] = iterativeClustering(inC, inD, D, T);

numstep = trackrecords.('num');

figure('visible','off');
for i = 1 : k
    plot(clusters{i}(:,1), clusters{i}(:,2),'+','MarkerSize',10,'LineWidth',2);
    hold on
end
grid on
M(1) = getframe;
clf;

for step = 2 : numstep
    str = strcat('Step',num2str(step));
    cls = trackrecords.(str);
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

figure(3)
movie(M,1,0.4)

myVideo = VideoWriter('hungerr.avi');
myVideo.FrameRate = 0.5;
open(myVideo);
writeVideo(myVideo, M);
close(myVideo);


%% clustering using spectral method

% [C_spec, ~, U] = SpectralClustering(CCF,3,3);
% FullC = full(C_spec);
% FullC(FullC(:,2)~=0,2) = 2;
% FullC(FullC(:,3)~=0,3) = 3;
% idx = sum(FullC,2);
% 
% figure
% plot(rawdata(idx==1,1),rawdata(idx==1,2),'+');
% hold on
% plot(rawdata(idx==2,1),rawdata(idx==2,2),'+');
% plot(rawdata(idx==3,1),rawdata(idx==3,2),'+');
% grid on



