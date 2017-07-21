
clear;
clc;

% path configuration
restoredefaultpath;
% projectpath = '/home/miv/phan/Git/CmlConfClus/'; % use this on natterer
projectpath = '/Users/phan/Git/CmlConfClus/'; % use this on mac
inpath = 'src/test5/cer/cer.mat';
outpath = 'src/test5/res/';
data = load(strcat(projectpath,inpath));
C = data.CER;

%% SNR vs T
C2 = reshape(C(1:8,1,:),[8, 16]);
SNRlbl = {'10','7','3','0','-1','-2','-3','-4'};
tlst = 0.025 : 0.025 : 0.4;
tlbl = cell(1,length(tlst));
for i = 1 : length(tlst)
    tlbl{i} = num2str(tlst(i));
end

fig1 = figure('visible','off');
imagesc(C2);
set(gca,'fontsize',20);
colorbar();
colormap(jet);
caxis([0 1]);
set(gca,'xtick',1:16);
set(gca,'xticklabel',tlbl);
set(gca,'XTickLabelRotation',45);
xlabel('T');
set(gca,'ytick',1:8);
set(gca,'yticklabel',SNRlbl);
ylabel('SNR (dB)');
grid on

fname = strcat(projectpath,outpath,'TvsSNR');
print(fig1,fname,'-dpng');


%% Div vs T
C2 = reshape(C(3,:,:),[9, 16]);
divlst = [3,4,5,6,8,10,12,15,20];
divlbl = cell(1,length(divlst));
for i = 1 : length(divlst)
    divlbl{i} = num2str(divlst(i));
end

fig2 = figure('visible','off');
imagesc(C2);
set(gca,'fontsize',20);
colorbar();
colormap(jet);
caxis([0 1]);
set(gca,'xtick',1:length(tlbl));
set(gca,'xticklabel',tlbl);
set(gca,'XTickLabelRotation',45);
xlabel('T');
set(gca,'ytick',1:length(divlbl));
set(gca,'yticklabel',divlbl);
ylabel('Division');
grid on

fname = strcat(projectpath,outpath,'TvsDiv');
print(fig2,fname,'-dpng');

%% Div vs SNR
C2 = reshape(C(1:8,:,4),[8, 9]);
fig3 = figure('visible','off');
imagesc(C2);
set(gca,'fontsize',20);
colorbar();
colormap(jet);
caxis([0 1]);
set(gca,'xtick',1:length(SNRlbl));
set(gca,'xticklabel',SNRlbl);
set(gca,'XTickLabelRotation',45);
xlabel('SNR (dB)');
set(gca,'ytick',1:length(divlbl));
set(gca,'yticklabel',divlbl);
ylabel('Division');
grid on

fname = strcat(projectpath,outpath,'SNRvsDiv');
print(fig3,fname,'-dpng');

