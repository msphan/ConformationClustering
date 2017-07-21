% Extract cluster labels from data file in test4/commonline/clusters

clear;
clc;

% path configuration
restoredefaultpath;
projectpath = '/home/miv/phan/Git/CmlConfClus/'; % use this on natterer
% projectpath = '/Users/phan/Git/CmlConfClus/'; % use this on mac
inpath = 'src/test4/commonline/clusters/';
outpath = 'src/test5/clusters/';
fobj = 'clu7';

for isnr = 1 : 8
    fsnr = strcat('snr',num2str(isnr));
    for idiv = 1 : 9
        fdiv = strcat('div',num2str(idiv));
        for it = 1 : 16
            ft = strcat('T',num2str(it));
            fi = strcat(projectpath,inpath,fobj,fsnr,fdiv,ft,'.mat');
            indata = load(fi,'clusterlabels');
            clusterlabels = indata.clusterlabels;
            fo = strcat(projectpath,outpath,fobj,fsnr,fdiv,ft,'.txt');
            save(fo,'clusterlabels','-ascii');
        end
    end
end
