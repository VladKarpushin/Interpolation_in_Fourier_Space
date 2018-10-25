function [imgOut] = imresizeInFreq(imgIn, hh, ww)

[h w] = size(imgIn);
h2 = fix(h/2);  %can be replaced by ceil or floor
w2 = fix(w/2);

% h2 = round(h/2);  %can be replaced by ceil or floor
% w2 = round(w/2);

imgB_fft = zeros([hh ww]);
imgA_fft = fft2(imgIn);
imgB_fft(1:h2,1:w2) = imgA_fft(1:h2,1:w2);
imgB_fft(1:h2,ww-w2:ww) = imgA_fft(1:h2,w2:w);
imgB_fft(hh-h2:hh,ww-w2:ww) = imgA_fft(h2:h,w2:w);
imgB_fft(hh-h2:hh,1:w2) = imgA_fft(h2:h,1:w2);
imgOut = real(ifft2(imgB_fft));   %ifft

'imag'
max(max(real(ifft2(imgB_fft))))

'imag'
max(max(imag(ifft2(imgB_fft))))
end