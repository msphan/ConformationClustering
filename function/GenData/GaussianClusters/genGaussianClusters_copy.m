% Script generates k clusters from gaussian models
% Using this script to test clustering algorithms by checking the 2d
% display

k = 3;
n = [100, 150, 200];
par = [1, 1 0.25; 1, 5, 0.25; 5, 3, 0.25];
clusters = cell(3,1);
m = 1;
s = 2;

figure

for i = 1 : 3
    
    m1 = par(i,1); m2 = par(i,2); s = par(i,3);
    mu = [m1,m2];
    sigma = [s,0;0,s];
    rng default  % For reproducibility
    r = mvnrnd(mu,sigma,n(i)); 
    clusters{i} = r;
    
    plot(r(:,1),r(:,2),'+');
    hold on
    
    
end

grid on

