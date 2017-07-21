function [ R ] = getRotFromDir( I, D )
%GETROTFROMDIR Get rotation matrix from direction vector
%   inver: flag inver matrix 

n = size(D,1);
R = zeros(3,3,n);

c = calCentroid(I); % get centroid of I

% compute tensor matrix of 3D image
mmt200 = calImageMoment(I, c, 2, 0, 0);
mmt110 = calImageMoment(I, c, 1, 1, 0);
mmt101 = calImageMoment(I, c, 1, 0, 1);
mmt020 = calImageMoment(I, c, 0, 2, 0);
mmt011 = calImageMoment(I, c, 0, 1, 1);
mmt002 = calImageMoment(I, c, 0, 0, 2);

T = [ mmt200, mmt110, mmt101 ; mmt110, mmt020, mmt011 ; mmt101, mmt011, mmt002 ];

[eigvec, ~] = eig(T);

eigvec = eigvec'; % this is rotation matrix back to principal axe

for i = 1 : n
    
    phi = D(i,1);
    theta = D(i,2);
    psi = D(i,3);

    cPhi = cos(phi);
    sPhi = sin(phi);

    cTheta = cos(theta);
    sTheta = sin(theta);

    cPsi = cos(psi);
    sPsi = sin(psi);
    
    Rx = [1, 0, 0; 0, cPhi, -sPhi; 0, sPhi, cPhi];
    Ry = [cTheta, 0, sTheta; 0, 1, 0; -sTheta, 0, cTheta];
    Rz = [cPsi, -sPsi, 0; sPsi, cPsi, 0; 0, 0, 1];
    
%     temp = [cTheta * cPsi,  sPhi * sTheta * cPsi - cPhi * sPsi,  cPhi * sTheta * cPsi + sPhi * sPsi;
%      cTheta * sPsi,  sPhi * sTheta * sPsi + cPhi * cPsi,  cPhi * sTheta * sPsi - sPhi * cPsi;
%      -sTheta,        sPhi * cTheta,                       cPhi * cTheta];
 
    temp = Rz*Ry*Rx;    

    R(:,:,i) = temp * eigvec';
    
    
end

end

