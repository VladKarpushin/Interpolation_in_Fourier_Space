%2016-01-19
%interpolation by FFT

close all,clc,clear all;

k = 20;
strFolder = 'D:\home\programming\vc\new\6_My home projects\18_interpolation_in_freq_domain\';
imgA = imread(strcat(strFolder,'input\small.jpg'));
[h w c] = size(imgA);
if c == 3
    imgA = rgb2gray(imgA);
end
imgA = double(imgA);            % color->gray
imgA = imgA(1:h-1,1:w);         % it needs odd size

[h w] = size(imgA);

hh = k*h;
ww = k*w;
h2 = fix(h/2);  %can be replaced by ceil or floor
w2 = fix(w/2);

imgB_fft = zeros([hh ww]);
imgA_fft = fft2(imgA);
imgB_fft(1:h2,1:w2) = imgA_fft(1:h2,1:w2);
imgB_fft(1:h2,ww-w2:ww) = imgA_fft(1:h2,w2:w);
imgB_fft(hh-h2:hh,ww-w2:ww) = imgA_fft(h2:h,w2:w);
imgB_fft(hh-h2:hh,1:w2) = imgA_fft(h2:h,1:w2);

imgB = real(ifft2(imgB_fft));   %ifft
imgC = uint8(255*(imgB -min(min(imgB )))/(max(max(imgB))-min(min(imgB))));

imwrite(imgC,strcat(strFolder,'output\result.jpg'));

%*******************
%*****Output********
%*******************

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