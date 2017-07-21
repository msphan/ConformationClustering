clear;
clc;

data = load('obj7.mat','S1','S2');
S1 = data.S1;
S2 = data.S2;

I11 = S1(:,:,1);
I12 = S1(:,:,2);

figure
imshow(I12,[]);
axis square;
axis off;

F11 = fftshift(fft2(I11));
F12 = fftshift(fft2(I12));

figure
imagesc(abs(F12));
set(gca,'FontSize',20);
axis square;
axis off;

