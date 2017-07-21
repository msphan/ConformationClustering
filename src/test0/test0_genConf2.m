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

% path configuration
restoredefaultpath;
% projectpath = '/home/miv/phan/Git/CmlConfClus/'; % use this on natterer
projectpath = '/Users/phan/Git/CmlConfClus/'; % use this on mac
fncpath = strcat(projectpath,'function/');
addpath(genpath(fncpath));
tbpath = strcat(projectpath,'toolbox/ConformationGen/');
addpath(genpath(tbpath));

k = 3; % number of conformal states
p = 129; % object size
voxs = 10; % voxels size
c1 = 0.1; c2 = 0.5; c3 = 1.0; % conformation rates
objlst = [7,6,3,1]; % list of objects that show clearly the conformation
SNRlst = [10,7,3,0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10];
dirpath = 'sinos/';

for idobj = 1 : length(objlst)
    
    filename = strcat(strcat('obj',num2str(objlst(idobj))),'.mat');
    objpath = strcat(dirpath,filename);
    
    save(objpath,'SNRlst','-v7.3');
    
    % generate k conformal states from object
    objname = strcat(strcat('movie',num2str(objlst(idobj))),'.txt');
    I1 = Genere3D_pdb(objname, p, p/voxs, 1, c1, 0);
    I2 = Genere3D_pdb(objname, p, p/voxs, 1, c2, 0);
    I3 = Genere3D_pdb(objname, p, p/voxs, 1, c3, 0);
     
    save(objpath,'I1','-append');
    save(objpath,'I2','-append');
    save(objpath,'I3','-append');
    
    % generate projections
    n1 = 1000; % number of projections each state
    n2 = 1000;
    n3 = 1000;

    D1 = genUniformDir(n1);
    S1 = getSinoPara(I1,D1,1);
    
    save(objpath,'D1','-append');
    save(objpath,'S1','-append');

    D2 = genUniformDir(n2);
    S2 = getSinoPara(I2,D2,1);
    
    save(objpath,'D2','-append');
    save(objpath,'S2','-append');

    D3 = genUniformDir(n3);
    S3 = getSinoPara(I3,D3,1);
    
    save(objpath,'D3','-append');
    save(objpath,'S3','-append');

    % mix projections into a same set
    S12 = cat(3,S1,S2);
    S = cat(3,S12,S3);
    N = size(S,3); % total number of projections
    
    save(objpath,'N','-append');
    save(objpath,'S','-append');

    % random permutate sinogram matrix
    newid = randperm(N);
    rS = S(:,:,newid);
    
    save(objpath,'newid','-append');
    save(objpath,'rS','-append');

    % add noise to sinogram
    for iSNR = 1 : length(SNRlst)
        filename = strcat(strcat(strcat('obj',num2str(objlst(idobj))),'iSNR'),num2str(iSNR));
        objpath = strcat(strcat(dirpath,filename),'.mat');
        nSi = (rS - min(rS(:))) / (max(rS(:)) - min(rS(:))); %normalize
        SNR = SNRlst(iSNR);
        [nSi, sigma] = addNoise3D(nSi, SNR);
        save(objpath,'nSi');
    end
    
end


