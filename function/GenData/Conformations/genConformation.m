% Generate conformal data

%% Get k conformal states

k = 3; % number of conformal states
p = 129; % object size
voxs = 10; % voxels size
c1 = 0.0; c2 = 0.4; c3 = 0.8;

I1 = Genere3D_pdb('movie5_ZipA.txt', p, p/voxs, 1, c1, 0);
I2 = Genere3D_pdb('movie5_ZipA.txt', p, p/voxs, 1, c2, 0);
I3 = Genere3D_pdb('movie5_ZipA.txt', p, p/voxs, 1, c3, 0);

figure
thres = 0.03;
smooth = 3;
subplot(1,3,1), plotSurf3D(I1,thres,'magenta',smooth); set(gca,'FontSize',20); grid on
subplot(1,3,2), plotSurf3D(I2,thres,'magenta',smooth); set(gca,'FontSize',20); grid on
subplot(1,3,3), plotSurf3D(I3,thres,'magenta',smooth); set(gca,'FontSize',20); grid on

%% Generate n prjs per state

n1 = 150; % number of projections each state
n2 = 200;
n3 = 250;

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

%% Random permutate sinogram matrix

% newid = randperm(N);
% rS = S(:,:,newid);

%% Add noise

% SNR = 0;
% nS = (rS - min(rS(:))) / (max(rS(:)) - min(rS(:)));
% [nS, sigma] = addNoise3D(nS, SNR);

%% Apply circular mask

masked_nS = mask_fuzzy(S,(p+1)/2); 

% figure
% subplot(3,1,1), viewstack(rS,1,5);
% subplot(3,1,2), viewstack(nS,1,5);
% subplot(3,1,3), viewstack(masked_nS,1,5);

%% Fourier transform

n_theta=360;
n_r= round(p + 0.1 * p);
[npf,sampling_freqs]=cryo_pft(masked_nS,n_r,n_theta,'single');

%% Correlation matrix with gaussian filter

max_shift=0;
shift_step=1;
[clstack, corrstack] = commonlines_gaussian(npf,max_shift,shift_step);

CLM = max(corrstack, corrstack'); % correlation matrix
CLM(eye(N)==1)=1;
D = sqrt(1 - CLM); % convert to distance matrix

%% save data
save data_movie3_transp_3_150vs200vs250_noiseless.mat -v7.3

exit;
