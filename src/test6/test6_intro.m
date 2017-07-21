% Volume reconstruction using Aspire
% For more information, see abinitio2.m in Aspire

figure
smooth = 3;
subplot(1,2,1);
plotSurf3D(I1,0.01,'magenta',smooth, 30, 10); set(gca,'FontSize',20); grid on
subplot(1,2,2);
plotSurf3D(V,0.001,'magenta',smooth, 40, -300); set(gca,'FontSize',20); grid on






