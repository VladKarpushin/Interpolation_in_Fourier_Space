%2016-01-19
%interpolation by FFT

close all,clc,clear all;

k = 5;
strFolder = 'D:\home\programming\vc\new\6_My home projects\18_interpolation_in_freq_domain\';
imgA = imread(strcat(strFolder,'input\small.jpg'));
[h w c] = size(imgA);
if c == 3
    imgA = rgb2gray(imgA);
end
imgA = double(imgA);            % color->gray
imgA = imgA(1:h-1,1:w);         % it needs to process even image only
[h w] = size(imgA);

hh = k*h;
ww = k*w;
imgC = imnormalize(imresizeInFreq(imgA, hh, ww));
imgD = imnormalize(imresize(imgA,[hh ww], 'nearest'));
imgE = imnormalize(imresize(imgA,[hh ww], 'bilinear'));
imgF = imnormalize(imresize(imgA,[hh ww], 'bicubic'));

%*******************
%*****Output********
%*******************
imwrite(imgC,strcat(strFolder,'output\resultC_fft.jpg'));
imwrite(imgD,strcat(strFolder,'output\resultD_nearest.jpg'));
imwrite(imgE,strcat(strFolder,'output\resultE_bilinear.jpg'));
imwrite(imgF,strcat(strFolder,'output\resultE_bicubic.jpg'));

% figure; imshow(imgA,[]);
% title('input image');
% 
% figure; imshow(imgC,[]);
% title('output image');
%figure, imshowpair(imgA, imgC, 'montage')

figure,
subplot(2,1,1)
imshow(imgA,[]);
title('input')
subplot(2,1,2)
imshow(imgC,[]);
title('out')

figure,
subplot(1,2,1)
imshow(imgA,[]);
title('input')
subplot(1,2,2)
imshow(imgC,[]);
title('out')