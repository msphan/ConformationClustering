% astrocytes clustering using Hungarian method

n = length(H);

X = XClusterbarycenterpos;
Y = YClusterbarycenterpos;
Z = ZClusterbarycenterpos;

% display data
figure
for i = 1 : n
    colo = [Rconv(i),Gconv(i),Bconv(i)];
    plot3(X(i),Y(i),Z(i),'o','Color',colo,'LineWidth',2,'MarkerSize',10,'MarkerFaceColor',colo);  
    hold on
end
grid on


% display in H component
M = zeros(2,n);
M(1,:) = cos(2*pi*H);
M(2,:) = sin(2*pi*H);

figure
for i = 1 : n
    colo = [Rconv(i),Gconv(i),Bconv(i)];
    % color = 'blue';
    plot(M(1,i),M(2,i),'o','Color',colo,'LineWidth',2,'MarkerSize',5);
    hold on
end
axis square;
grid on

% Hungarian method
D = zeros(n,n);
for i = 1 : n-1
    for j = i+1 : n
        D(i,j) = sqrt(sum((M(:,i) - M(:,j)).^2));
    end
end
D = max(D,D');
thres = 1e100;
D(logical(eye(size(D)))) = thres;

inC = cell(size(D,1),1); % initialize cluster
for i = 1 : size(D,1), inC{i} = i; end
inD = D; % initialize distance matrix
T = 0.2; % NEED TO STUDY
[C, trackrecords] = iterativeClustering(inC, inD, D, T);

numstep = trackrecords.('num');

F(numstep) = struct('cdata',[],'colormap',[]);

figure('visible','off');

for i = 1 : n
    % colo = [Rconv(i),Gconv(i),Bconv(i)];
    color = 'blue';
    plot(M(1,i),M(2,i),'bo','LineWidth',2,'MarkerSize',5);
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
        plot(M(1,idcl), M(2,idcl),'o','color',cc(i,:),'LineWidth',2,'MarkerSize',5);
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

% save to avi
myVideo = VideoWriter('astrocyte.avi');
myVideo.FrameRate = 0.5;
open(myVideo);
writeVideo(myVideo, F);
close(myVideo);

% display cluster results on xyz space

F2(numstep) = struct('cdata',[],'colormap',[]);

figure('visible','off');

ncls = length(C);
for i = 1 : ncls
    clu = C{i};
    nelm = length(clu);
    for j = 1 : nelm
        colo = [Rconv(clu(j)),Gconv(clu(j)),Bconv(clu(j))];
        plot3(X(clu(j)),Y(clu(j)),Z(clu(j)),'o','Color',colo,'LineWidth',2,'MarkerSize',10,'MarkerFaceColor',colo);  
        hold on
    end
    grid on
    F2(i) = getframe();   
    clf;
end

% display video 
figure
movie(gcf,F2,1,1,[60,50,0,0]);

% save to avi
myVideo = VideoWriter('astrocyte2.avi');
myVideo.FrameRate = 0.5;
open(myVideo);
writeVideo(myVideo, F2);
close(myVideo);


% clid = 22;
% cvh = convhull(X(C{clid}),Y(C{clid}),Z(C{clid}));
% trisurf(cvh,X(C{clid}),Y(C{clid}),Z(C{clid}),'Facecolor','cyan')




