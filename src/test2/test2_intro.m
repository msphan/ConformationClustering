% This test aims at clustering the conformations using convex optimization

% Optimization toolbox : cvx

% Pipeline
% Input: N projections with K conformations (K is unknown)
% 1. Preprocessing step (optional)
% 2. Apply circular mask on projections
% 3. Calculate distance matrix of projections in Fourier domain with
%    gaussian filter to denoise commone lines
% 4. Clustering using CVX toolbox
% 5. Save cluster information and estimate errors using CER estimator



