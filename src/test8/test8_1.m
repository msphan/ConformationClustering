% Hungarian clustering of mean color points of axons

clear;
clc;

load('MeanColorPointAxons.mat');

M = reshape(Vh(:,1,:),[200,2]);
n = size(M,1);
figure
plot(M(:,1),M(:,2),'o');
axis square;
grid on

% Hungarian clustering
% Hungarian method
D = zeros(n,n);
for i = 1 : n-1
    for j = i+1 : n
        D(i,j) = sqrt(sum((M(i,:) - M(j,:)).^2));
    end
end
D = max(D,D');
thres = 1e100;
D(logical(eye(size(D)))) = thres;

inC = cell(size(D,1),1); % initialize cluster
for i = 1 : size(D,1), inC{i} = i; end
inD = D; % initialize distance matrix
T = 0.55; % NEED TO STUDY
[C, trackrecords] = iterativeClustering(inC, inD, D, T);

% plot results
numstep = trackrecords.('num');

F(numstep) = struct('cdata',[],'colormap',[]);

figure('visible','off');

for i = 1 : n
    % colo = [Rconv(i),Gconv(i),Bconv(i)];
    color = 'blue';
    plot(M(i,1),M(i,2),'bo','LineWidth',2,'MarkerSize',5);
    hold on
end
axis square;
set(gca,'FontSize',20);
xlim([-1.1, 1.1]);
ylim([-1.1, 1.1]);
grid on
F(1) = getframe();
clf;

for step = 2 : numstep
    str = strcat('Step',num2str(step));
    cls = trackrecords.(str);
    estk = length(cls);
    cc=hsv(estk);
    for i = 1 : estk
        idcl = cls{i};
        plot(M(idcl,1), M(idcl,2),'o','color',cc(i,:),'LineWidth',2,'MarkerSize',5);
        hold on
    end
    axis square;
    xlim([-1.1, 1.1]);
    ylim([-1.1, 1.1]);
    set(gca,'FontSize',20);
    grid on
    F(step) = getframe();   
    clf;
end

% display video 
figure
movie(gcf,F,1,0.5,[60,50,0,0]);
