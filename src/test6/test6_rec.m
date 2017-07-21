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

data = load('obj7.mat','I3','D1','newid');
I1 = data.I3;
D1 = data.D1;
newid = data.newid;
[sortid, idx] = sort(newid);
clear data;

data = load('obj7iSNR1.mat','nSi');
nS = data.nSi;
p = size(nS,1);
S1 = nS(:,:,idx(1:1000));
clear data;

% [x,y,z] = calSphere(D1);
% figure
% plot3(x,y,z,'o');

R1 = getRotFromDir(I1,D1);

% S = (S - min(S(:)))/(max(S(:))-min(S(:)));

V = recon3d_firm(S1,R1,[], 1e-6, 30, zeros(p,p,p));

assert(norm(imag(V(:)))/norm(V(:))<1.0e-3);
V=real(V);

outpath = '/src/test6/res/objtrue.mat';
save(strcat(projectpath,outpath),'V','-v7.3');
