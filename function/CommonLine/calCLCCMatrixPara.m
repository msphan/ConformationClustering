function [ CLCM ] = calCLCCMatrixPara(S)
%CALCLCCPARA calculate average common line cross correlation between two
%sinos

n = size(S,3);
CLCM = zeros(n, n);
siz = size(CLCM);

parfor k = 1 : n * n
    [i,j] = ind2sub(siz,k);
    if (i < j)
        CLCM(k) = 1 - calCLCC2(S,k,siz);
    end
end

CLCM = max(CLCM, CLCM');
  
end

