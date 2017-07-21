function [ med, EDM ] = calED( S, k, siz )
%CALCLCC Calculate the common line cross correlation coefficient between
%two projections

[i, j] = ind2sub(siz,k);
P1 = S(:,:,i);
P2 = S(:,:,j);

theta1 = 0 : 179;
theta2 = 0 : 359;

rd1 = radon(P1, theta1);
rd2 = radon(P2, theta2);
% figure
% subplot(1,2,1), imagesc(rd1); axis square
% subplot(1,2,2), imagesc(rd2); axis square

EDM = zeros(length(theta1), length(theta2)); 
for i1 = 1 : length(theta1)
    for i2 = 1 : length(theta2)
        ed = sqrt(sum((rd1(:,i1) - rd2(:,i2)).^2));
        EDM(i1,i2) = ed;
    end
end

med = min(min(EDM));

end

