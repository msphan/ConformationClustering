function [ EDM ] = calEDMatrixPara(S)
%CALCLCCPARA calculate average common line cross correlation between two
%sinos

n = size(S,3);
EDM = zeros(n, n);
siz = size(EDM);

parfor k = 1 : n * n
    [i,j] = ind2sub(siz,k);
    if (i < j)
        EDM(k) = calED(S,k,siz);
    end
end

EDM = max(EDM, EDM');
  
end

