function [ C ] = groupClusters( previousC, currentC )
%GROUPCLUSTERS groupe elements from previous cluster to the current cluster
%   input
%       previousC : previous cluster
%       currentC : current cluster
%   output
%       C : grouped cluster

C = cell(size(currentC));
current_k = length(currentC);

for k = 1 : current_k
    n = length(currentC{k});
    for i = 1 : n
        j = currentC{k}(i);
        C{k} = [C{k}, previousC{j}];
    end
end

end

