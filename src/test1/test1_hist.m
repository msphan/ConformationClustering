% Check ability of common line similarity for estimating the conformation

clear;
clc;

% load gendata from gendata folder
load('data_movie3_transp_3_150vs200vs250_noiseless.mat');

% evaluate histogram
H11 = D(1:n1,1:n1); % inter-distance of Obj1
H22 = D(n1+1:n1+n2, n1+1:n1+n2); % inter-distance of Obj2
H33 = D(n1+n2+1:n1+n2+n3, n1+n2+1:n1+n2+n3); % inter-distance of Obj3
H12 = D(1:n1,n1+1:n1+n2); % inter-distance of Obj1 and Obj2
H23 = D(n1+1:n1+n2,n1+n2+1:n1+n2+n3); % inter-distance of Obj1 and Obj2
H13 = D(1:n1,n1+n2+1:n1+n2+n3); % inter-distance of Obj1 and Obj2

HS1 = H33(triu(H33,1)>0)';
HS2 = H13(:)';
HS3 = H23(:)';
% HS = [H11(triu(H11,1)>0);H13(:)]';
figure
h1 = histogram(HS1);
hold on
h2 = histogram(HS2);
h3 = histogram(HS3);
h1.Normalization = 'probability';
h1.BinWidth = 0.01;
h2.Normalization = 'probability';
h2.BinWidth = 0.01;
h3.Normalization = 'probability';
h3.BinWidth = 0.01;

xlabel('Euclidean distance');
title('Euclidean distances between cml of obj3 with cml of obj1 and obj2');
legend('obj3','obj3 vs obj1', 'obj3 vs obj2');
set(gca,'FontSize',30);
grid on

