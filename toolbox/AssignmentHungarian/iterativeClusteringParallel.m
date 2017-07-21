function [ C, trackrecords ] = iterativeClusteringParallel(p,i,numperg,D,T)
%ITERATIVEPARALLEL Summary of this function goes here
%   Detailed explanation goes here

G = p((i-1)*numperg+1:i*numperg);
inC = cell(numperg,1);
for j = 1 : numperg, inC{j} = G(j); end
inD = D(G,G);
[C, trackrecords] = iterativeClustering(inC, inD, D, T);

% CParent = struct;
% str = strcat('Groupe',num2str(i));
% CParent.(str) = C;
% str = strcat('TrackRecord',num2str(i));
% CParent.(str) = trackrecords;


end

