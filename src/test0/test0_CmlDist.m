% Calculate common line distance matrix
% Next of test0_Conf.m

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
objlst = [7,6,3,1];
SNRlst = [10,7,3,0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10];
p = 129; % projection size
N = 3000;
thres = 1e100;
inpath = 'sinos/';
outpath = 'cmldist/';

for iobj = 1 : 1
    objpath = strcat(inpath,strcat('obj',num2str(objlst(iobj))));
    objpath2 = strcat(outpath,strcat('obj',num2str(objlst(iobj))));
    for iSNR = 2 : 9
        % load sino file
        snrpath = strcat('iSNR',num2str(iSNR));
        sinopath = strcat(strcat(objpath,snrpath),'.mat');
        sinodata = load(sinopath);
        S = sinodata.nSi;
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
        distname = strcat('D',num2str(iSNR));
        distpath = strcat(strcat(objpath2,distname),'.mat');
        save(distpath,'D','-v7.3');
        save(distpath,'mS','-append');
        save(distpath,'clstack','-append');
        save(distpath,'corrstack','-append');
        save(distpath,'npf','-append');
        save(distpath,'sampling_freqs','-append');
    end
end

