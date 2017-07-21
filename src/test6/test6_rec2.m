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

inpath = 'src/test0/sinos';
addpath(genpath(fullfile(projectpath,inpath)));

inpath2 = 'src/test0/cmldist';
addpath(genpath(fullfile(projectpath,inpath2)));

data = load('obj7D1.mat','clstack');
clstack = data.clstack;
clear data;

data = load('obj7.mat','newid');
newid = data.newid;
[sortid, idx] = sort(newid);
clstack1 = clstack(idx(1:1000),idx(1:1000));
clear data;

data = load('obj7iSNR1.mat','nSi');
nS = data.nSi;
clear data;
nS1 = nS(:,:,idx(1:1000));

n_theta = 360;
S=cryo_syncmatrix_vote(clstack1,n_theta);
rotations = cryo_syncrotations(S);
p = size(nS1,1);

V = recon3d_firm(nS1,rotations,[], 1e-6, 30, zeros(p,p,p));

assert(norm(imag(V(:)))/norm(V(:))<1.0e-3);
V=real(V);

outpath = '/src/test6/res/objest.mat';
save(strcat(projectpath,outpath),'V','-v7.3');

outpath2 = '/src/test6/res/rotest.mat';
save(strcat(projectpath,outpath2),'rotations','-v7.3');

po = gcp;
delete(po)

disp('OK....');
