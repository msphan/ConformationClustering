function [ dist ] = mindistset( ci, cj, D, T, thres )
%MINDISTSET Compute distance between two set ci and cj based on the minimal
%distance between two sets.
%   Input 
%       ci, cj : two arrays
%       D : distance matrix
%       T : parameter
%       thres = 1e100

nci = length(ci); ncj = length(cj);
dmin = Inf; rmin = 0; lmin = 0;
for r = 1 : nci
    for l = 1 : ncj
        d = D(ci(r),cj(l));
        if (d < dmin)
            dmin = d; rmin = r; lmin = l; % find minimal distance between two clusters
        end
    end
end
rci = [ci(1:rmin-1), ci(rmin+1 : end)]; % remove rmin from ci
rcj = [cj(1:lmin-1), cj(lmin+1 : end)]; % remove lmin from cj
rciD = D(ci(rmin),rci) - ones(1,nci-1) * dmin; % calculate intra distance
flagi = sum(rciD < 0);
rcjD = D(cj(lmin),rcj) - ones(1,ncj-1) * dmin; % calculate intra distance
flagj = sum(rcjD < 0);
if(flagi >= T || flagj >= T)
    dist = thres; 
else
    dist = dmin; 
end  


end

