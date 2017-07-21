function [ CLCM ] = calCLCCMatrix(S)
%CALCLCCPARA calculate average common line cross correlation between two
%sinos

n = size(S,3);
CLCM = zeros(n, n);
for i = 1 : (n - 1)
    for j = i + 1 : n      
        CLCM(i, j) = 1 - calCLCC(S(:,:,i), S(:,:,j));  
        CLCM(j, i) = CLCM(i, j);
    end
end
  
end

