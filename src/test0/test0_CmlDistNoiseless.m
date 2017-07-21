% Calculate common line distance matrix
% Next of test0_Conf.m
% Only for the noiseless case

clear;
clc;

% path configuration
restoredefaultpath;
projectpath = '/home/miv/phan/Git/CmlConfClus'; % use this on natterer
% projectpath = '/Users/phan/Git/CmlConfClus'; % use this on mac
aspirepath = 'toolbox/Aspire';
addpath(genpath(fullfile(projectpath,aspirepath,'abinitio')));
addpath(genpath(fullfile(projectpath,aspirepath,'common')));
addpath(genpath(fullfile(projectpath,aspirepath,'examples')));
addpath(genpath(fullfile(projectpath,aspirepath,'fourier')));
addpath(genpath(fullfile(projectpath,aspirepath,'projections')))
addpath(genpath(fullfile(projectpath,aspirepath,'sinograms')))
addpath(genpath(fullfile(projectpath,aspirepath,'reconstruction')))
addpath(genpath(fullfile(projectpath,aspirepath,'refinement')))
addpath(fullfile(projectpath,aspirepath,'extern','SDPLR-1.03-beta'))
addpath(genpath(fullfile(projectpath,aspirepath,'extern','aLibs')))
run(fullfile(projectpath,aspirepath,'extern','irt','setup.m'))
run(fullfile(projectpath,aspirepath,'extern','cvx','cvx_startup.m'));
fncpath = 'function';
addpath(genpath(fullfile(projectpath,fncpath)));

% load sino file
inpath = 'sinos/obj7.mat';
data = load(inpath,'S1');
S = data.S1;
clear data;
S = (S - min(S(:))) / (max(S(:)) - min(S(:))); %normalize

p = 129; % projection size
N = 1000;
thres = 1e100;

% apply circular mask
mS = mask_fuzzy(S,(p+1)/2); 
% Fourier transform
n_theta=360;
n_r= round(p + 0.1 * p);
[npf,sampling_freqs]=cryo_pft(mS,n_r,n_theta,'single');
% correlation matrix
max_shift=0;
shift_step=1;
[clstack, corrstack] = commonlines_gaussian(npf,max_shift,shift_step);
CLM = max(corrstack, corrstack'); % correlation matrix
CLM(eye(N)==1)=1;
% distance matrix
D = sqrt(1 - CLM); % convert to distance matrix
D(logical(eye(size(D)))) = thres;
% save to file
outpath = 'cmldist/obj7DS1.mat';
save(outpath,'D','-v7.3');
save(outpath,'mS','-append');
save(outpath,'clstack','-append');
save(outpath,'corrstack','-append');
save(outpath,'npf','-append');
save(outpath,'sampling_freqs','-append');
