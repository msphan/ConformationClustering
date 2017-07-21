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

data = load('obj7DS1.mat','clstack');
clstack = data.clstack;
clear data;

data = load('obj7.mat','S1');
S1 = data.S1;
S1 = (S1 - min(S1(:))) / (max(S1(:)) - min(S1(:))); %normalize
clear data;

nbprj = 100;
idS1 = randperm(1000);
S1 = S1(:,:,idS1(1:nbprj));
clstack = clstack(idS1(1:nbprj),idS1(1:nbprj));

n_theta = 360;
S=cryo_syncmatrix_vote(clstack,n_theta);
rotations = cryo_syncrotations(S);
p = size(S1,1);

V = recon3d_firm(S1,rotations,[], 1e-6, 30, zeros(p,p,p));

% assert(norm(imag(V(:)))/norm(V(:))<1.0e-3);
V=real(V);

outpath = '/src/test6/res/objestS1.mat';
save(strcat(projectpath,outpath),'V','-v7.3');

outpath2 = '/src/test6/res/rotestS1.mat';
save(strcat(projectpath,outpath2),'rotations','-v7.3');

outpath3 = '/src/test6/res/objestS1.mrc';
WriteMRC(V,1,strcat(projectpath,outpath3));

po = gcp;
delete(po)

disp('OK....');
