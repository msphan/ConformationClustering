% Conformal clustering based on assignment problem with parallel approach
% Author : Son Phan

clear;
clc;

% path configuration
restoredefaultpath;
projectpath = '/home/miv/phan/Git/CmlConfClus'; % use this on natterer
% projectpath = '/Users/phan/Git/CmlConfClus'; % use this on mac
assipath = 'toolbox/AssignmentHungarian';
funcpath = 'function';
distpath = 'src/test0/cmldist';
srcpath = 'src/test0/sinos';
addpath(genpath(fullfile(projectpath,funcpath)));
addpath(genpath(fullfile(projectpath,assipath)));
addpath(genpath(fullfile(projectpath,distpath)));
addpath(genpath(fullfile(projectpath,srcpath)));

objname = 'obj7';
srndata = load(strcat(objname,'.mat'),'newid');
newid = srndata.newid;
clear srndata;

snrlst = 1 : 9;
divlst = [3,4,5,6,8,10,12,15,20];
tlst = 0.025 : 0.025 : 0.4;
numiter = 5; % nb of iterations
thres = 1e100;

outpath = 'clusters/clu7';

for isnr = 2 : length(snrlst)
    
    disp(strcat('isnr= ',num2str(isnr)));
    
    snrpath = strcat('snr',num2str(isnr));
    
    dname = strcat(strcat(strcat(objname,'D'),num2str(isnr)),'.mat');
    disdata = load(dname,'D');
    D = disdata.D;
    clear disdata;
    N = size(D,1);
    
    for idiv = 1 : length(divlst)
        
        disp(strcat('-idiv= ',num2str(divlst(idiv))));
        
        divpath = strcat('div',num2str(idiv));
        
        m = divlst(idiv);
        numperg = N/m;
        for it = 1 : length(tlst)
            
            disp(strcat('--iT= ',num2str(tlst(it))));
            
            tpath = strcat('T',num2str(it));
            
            T = tlst(it);
            cost = zeros(1, numiter);
            CBest = cell(1,1);
            trackrecordsBest = struct;
            trackrecordsParent = struct;
            costBest = Inf;

            for iter = 1 : numiter

                disp(strcat('---iter= ',num2str(iter)));
                % random permutate projection indices
                p = randperm(N);
                CParent = cell(1,m);
                trackParent = cell(1,m);
                % run Hungarian clustering on each group
                kNew = 0;
                parfor i = 1 : m
                    disp(strcat('----group= ',num2str(i)));
                    [CParent{i}, trackParent{i}] = iterativeClusteringParallel(p,i,numperg,D,T);
                    kNew = kNew + length(CParent{i});
                end
                % run Hungarian one more time
                CNew = cell(1,kNew);
                itc = 1;
                for i = 1 : m
                   for j = 1 : length(CParent{i})
                       CNew{itc} = CParent{i}{j};
                       itc = itc + 1;
                   end
                end

                DNew = ones(kNew, kNew) * thres; % initialize new distance matrix
                for i = 1 : kNew
                    for j = i + 1 : kNew

                        DNew(i,j) = Hausdorffdistset(CNew{i}, CNew{j}, D);
                        DNew(j,i) = DNew(i,j);      

                    end

                    if(sum(DNew(i,:) > T) == kNew)
                        DNew(i,i) = -thres; % REVIEW !!!!!!!!!!!!!
                    end
                end
                [outC, trackrecords] = iterativeClustering( CNew, DNew, D, T );
                kEst = length(outC);
                for i = 1 : kEst
                    cost(iter) = cost(iter) + sum(sum(triu(D(outC{i},outC{i}),1)));
                end
                if(cost(iter) < costBest)
                    costBest = cost(iter);
                    CBest = outC;
                    trackrecordsBest = trackrecords;
                    trackrecordsParent = trackParent;
                end

            end
            
            n = 1000;
            truelbl = newid;
            truelbl(truelbl <= n & truelbl >=1) = 1;
            truelbl(truelbl <= 2*n & truelbl >=n+1) = 2;
            truelbl(truelbl <= 3*n & truelbl >=2*n+1) = 3;

            estlbl = zeros(1,N);
            for i = 1 : length(CBest)
                estlbl(CBest{i}) = i;
            end

            [truelbl, sid] = sort(truelbl);
            estlbl = estlbl(sid);

            clusterlabels = [truelbl; estlbl];

            finalpath = strcat(strcat(strcat(strcat(outpath,snrpath),divpath),tpath),'.mat');
            
            save(finalpath,'clusterlabels','-v7.3');
            save(finalpath,'trackrecordsParent','-append');
            save(finalpath,'trackrecordsBest','-append');
            save(finalpath,'CBest','-append');
            save(finalpath,'costBest','-append');
            save(finalpath,'cost','-append');
            save(finalpath,'snrlst','-append');
            save(finalpath,'divlst','-append');
            save(finalpath,'tlst','-append');
            save(finalpath,'numiter','-append');
            
        end
    end
end

% shutdow parallel pools
po = gcp;
delete(po)

disp('END.....');

% fig1 = figure('Visible','Off');
% subplot(2,1,1), imagesc(clusterlabels(1,:));
% subplot(2,1,2), imagesc(clusterlabels(2,:));
% print(fig1,'clusters','-dpng')

% fig2 = figure('Visible','Off');
% plot(1:numiter,cost,'-o');
% grid on
% print(fig2,'errors','-dpng');

