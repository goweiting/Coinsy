function img_disk = morph_disk( img, mode, SIZE, show )
%% MORPH_DISK
%   Erode/Shrink (mode = 0) OR DILATE/expand (mode = 1) the image using 
%   a disk shaped struct element defined by `strel`.
%   SIZE determines the radius of the disk

%   N.B. From Wikipedia_(Structuring element):
%   structuring element is a shape, used to probe or interact with a given
%   image, with the purpose of drawing conclusions on how this shape
%   fits or misses the shapes in the image.

%  define the structural element with disk size:
SE = strel('disk', SIZE);

switch mode
    case 0 
        img_disk = imerode(img, SE);
    case 1
        img_disk = imdilate(img, SE);
end

if show
%     clf;
    imshow([img img_disk]);
%     subplot(1,2,1) = imshow(img); title('Original Image');
%     subplot(1,2,2) = imshow(img_disk); title('Eroded with disk');
%     subplot(1,3,3) = imshow(SE.Neighborhood); title('Structuring element');
end

end
