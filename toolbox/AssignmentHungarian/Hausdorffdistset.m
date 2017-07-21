function [ dist, stddist ] = Hausdorffdistset( ci, cj, D )
%HAUSDORFFDISTSET get Hausdorff distance between two sets
%   Input 
%       ci, cj : two arrays
%       D : distance matrix

% val1 = mean(min(D(ci,cj)));
% std1 = std(min(D(ci,cj)));
% 
% val2 = mean(min(D(cj,ci)));
% std2 = std(min(D(cj,ci)));

val1 = median(median(D(ci,cj)));
std1 = std(median(D(ci,cj)));

val2 = median(median(D(cj,ci)));
std2 = std(median(D(cj,ci)));

dist = max(val1, val2);
stddist = max(std1, std2);


end

