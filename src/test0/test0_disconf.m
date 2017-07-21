% movie for conformation
clear;
clc;

objname = 'movie7.txt';
p = 129; % object size
voxs = 10; % voxels size
c = 0.0 : 0.2 : 1.0;
k = length(c);

I = cell(1,k);

for i = 1 : k
    I{i} = Genere3D_pdb(objname, p, p/voxs, 1, c(i), 0);
end

thres = 0.01;
smooth = 3;
col = [0.99,0.5,0.9];
figure('visible','off');

for i = 1 : k
    plotSurf3D(I{i},thres,col,smooth,35,17); 
    axis off;
    M(i) = getframe;
    clf;  
end

figure
movie(gcf,M,1,0.5,[45, 45 0 0])

myVideo = VideoWriter('confs.avi');
myVideo.FrameRate = 0.5;
open(myVideo);
writeVideo(myVideo, M);
close(myVideo);
