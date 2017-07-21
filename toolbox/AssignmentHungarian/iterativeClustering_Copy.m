function [ outC, trackrecords ] = iterativeClustering_Copy( inC, inD, D, T )
%ITERATIVECLUSTERING intiratively use Hungarian alogirhtm to cluster
%   Input
%       D: distance matrix
%       T: parameter used to decide when a cluster is completed
%   Output
%       C: clusters

thres = 1e100;

trackrecords = struct;
step = 1;

currentD = inD; % initialize the current D
previous_k = size(inD,1); % save number of previous cluster
% outC = cell(previous_k,1); % initialize cluster
% for i = 1 : previous_k, outC{i} = i; end

outC = inC;

str = strcat('Step',num2str(step));
trackrecords.(str) = outC; % keep track when clustering

while(1) 
    currentC = clusterHungarian(currentD); % get current cluster
    current_k = length(currentC); 
    disp(['pr = ',num2str(previous_k), ' and curr = ', num2str(current_k)]);
    if(current_k < previous_k) % if number of current clusters < number of previous cluster
        outC = groupClusters(outC, currentC); % C is a new cluster grouped from previous one
        
        step = step + 1;
        str = strcat('Step',num2str(step));
        trackrecords.(str) = outC; % keep track when clustering
      
        previous_k = current_k; % update previous k for the next loop
        nextD = ones(current_k, current_k) * thres; % initialize new distance matrix
        
        StdMatrix = zeros(current_k, current_k);
        for i = 1 : current_k
            for j = i + 1 : current_k
                
%                 nextD(i,j) = mindistset(outC{i}, outC{j}, D, T, thres);
                [nextD(i,j), stddist] = Hausdorffdistset(outC{i}, outC{j}, D);
                nextD(j,i) = nextD(i,j);      
                
                StdMatrix(i,j) = stddist;
                StdMatrix(j,i) = stddist;
                
            end

%             if(sum(nextD(i,:) == thres) == current_k)
%                 nextD(i,i) = -thres; % REVIEW !!!!!!!!!!!!!
%             end
            if(sum(nextD(i,:) > T) == current_k)
                nextD(i,i) = -thres; % REVIEW !!!!!!!!!!!!!
            end
        end
        
        ClsD = strcat('ClusterDistance',num2str(step)); % save distances
        trackrecords.(ClsD) = nextD;
        ClsStd = strcat('ClusterStd',num2str(step)); % save std distances
        trackrecords.(ClsStd) = StdMatrix;
        
        currentD = nextD; % update current distance matrix for the next loop
    else
        break;
    end
end 

trackrecords.('num') = step;

end

