function [ C ] = clusterHungarian( currentD )
%clusterHungarian cluster the distance matrix using Hungarian
%algorithm.
%   Input : distance matrix D
%   Output : clusters
%   Author : Son Phan

n = size(currentD,1);
assignment = munkres(currentD); % solve assignment problem
ind = 1 : n; 
C = cell(n,1); idc = 1; % initialize clusters
num = 1;
check = zeros(1,n); % array to check passed elements
while(num <= n)
    candidat = ind(~ismember(ind,check)); % find the not checked elements
    temp = zeros(1,n);  % initialize cluster
    temp(1) = candidat(1); idt = 2; % assign the first not checked elements
    j = temp(1);
    while assignment(j) ~= temp(1) % check belonging elements
        temp(idt) = assignment(j); idt = idt + 1; % assign to cluster
        j = assignment(j);
    end
    temp(idt : end) = []; % resize cluster
    check(num:num+length(temp)-1) = temp; % add checked elements
    num = num + length(temp); 
    C{idc} = temp; % add cluster
    idc = idc + 1;    
end
C(idc : end, :) = []; % resize clusters

end

