function [imgOut] = imnormalize(imgIn)
    imgOut = uint8(255*(imgIn -min(min(imgIn)))/(max(max(imgIn))-min(min(imgIn))));
end