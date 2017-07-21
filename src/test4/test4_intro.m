% This test aims at clustering the conformations using Hierarchical
% clustering based on Hungarian algorithm

% Paper
% Hierarchical clustering based on Hungarian method - Jacob Golberger, 2008

% Pipeline
% Input: N projections with K conformations (K is unknown)
% 1. Preprocessing step (optional)
% 2. Apply circular mask on projections
% 3. Calculate distance matrix of projections in Fourier domain with
%    gaussian filter to denoise commone lines
% 4. Apply Hungarian method (need quantify T parameter a.f.o noise)
% 5. Save cluster information and estimate errors using CER estimator


% test runtime of Hungarian algorithm
clear; clc;
tic
Test = magic(10);
Test = (Test - min(Test(:))) ./ (max(Test(:)) - min(Test(:)));
[assignment, cost] = munkres(Test);
toc

% script to create test matrix
D = magic(100);
D(logical(eye(size(D)))) = Inf;
D = min(D,D');
C = clusterHungarian(D);






