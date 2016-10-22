function img_rect =  morph_rect(img, SIZE, show)
%% ERODE_RECT
%   erode/shrink the image using a rectangular shape struct element defined 
%   by strel
%   SIZE is a vector [m,n] indicating the size of the rectangle

SE = strel('rectangle', SIZE);
img_rect = imerode(img, SE);

if show
    subplot(2,2,1) = imshow(img); title('original image');
    subplot(2,2,2) = imshow(img_rect); title('eroded image');
%     subplot(2,2,3) = imshow(SE.Neighbourhood); title('structure');
end

end
