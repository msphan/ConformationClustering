% Generate conformation projections
% List of good objects
%   - movie7, (clear)
%   - movie6, (clear)
%   - movie5, (not clear)
%   - movie4, (not clear)
%   - movie3, (clear)
%   - movie2, (not clear)
%   - movie1, (clear)

clear;
clc;

%% generate k conformal states from object

k = 3; % number of conformal states
p = 129; % object size
voxs = 10; % voxels size
c1 = 0.1; c2 = 0.5; c3 = 1.0; % conformation rates
objname = 'movie6.txt';

I1 = Genere3D_pdb(objname, p, p/voxs, 1, c1, 0);
I2 = Genere3D_pdb(objname, p, p/voxs, 1, c2, 0);
I3 = Genere3D_pdb(objname, p, p/voxs, 1, c3, 0);

figure
thres = 0.03;
smooth = 3;
subplot(1,3,1), plotSurf3D(I1,thres,'magenta',smooth); set(gca,'FontSize',20); grid on
subplot(1,3,2), plotSurf3D(I2,thres,'magenta',smooth); set(gca,'FontSize',20); grid on
subplot(1,3,3), plotSurf3D(I3,thres,'magenta',smooth); set(gca,'FontSize',20); grid on

%% generate projections

n1 = 10; % number of projections each state
n2 = 10;
n3 = 10;

D1 = genUniformDir(n1);
S1 = getSinoPara(I1,D1,1);

D2 = genUniformDir(n2);
S2 = getSinoPara(I2,D2,1);

D3 = genUniformDir(n3);
S3 = getSinoPara(I3,D3,1);

% mix projections into a same set
S12 = cat(3,S1,S2);
S = cat(3,S12,S3);
N = size(S,3); % total number of projections

% random permutate sinogram matrix
newid = randperm(N);
rS = S(:,:,newid);

%% add noise to sinogram

SNR = 10;
nS = (rS - min(rS(:))) / (max(rS(:)) - min(rS(:))); %normalize
[nS, sigma] = addNoise3D(nS, SNR);
