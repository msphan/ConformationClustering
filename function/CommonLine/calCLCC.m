function [ clcc, CCM ] = calCLCC( P1, P2 )
%CALCLCC Calculate the common line cross correlation coefficient between
%two projections

theta1 = 0 : 179;
theta2 = 0 : 359;

rd1 = radon(P1, theta1);
rd2 = radon(P2, theta2);
% figure
% subplot(1,2,1), imagesc(rd1); axis square
% subplot(1,2,2), imagesc(rd2); axis square

CCM = zeros(length(theta1), length(theta2)); 
for i1 = 1 : length(theta1)
    for i2 = 1 : length(theta2)
        cf = corrcoef(rd1(:,i1),rd2(:,i2));
        CCM(i1,i2) = cf(2,1);
        
    end
end

clcc = max(max(CCM));

end

