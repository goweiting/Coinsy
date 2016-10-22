function img_filtered = median_filter(img, show, SIZE )
%% MEDIAN_FILTER
%   Use median filter to reduce the impulse noise in the image base on the
%   local intensity distribution. The distribution being conisdered by the
%   filter is determined by SIZE. 
% 
%   If there are more than 2 dim in img (such as a HSV or RGB) image,
%   median filter is passed through each dimension independently. The
%   resulting image is then put together as img_filtered.

% INPUT:
%   SIZE - either a scalar or a vector representing the row and col. If not
%   defined, the default value of 3x3 is used.
%   img - image to be filtered
%   show - 0/1 to imshow the images

%% Do Median Filtering for each channel (can be HSV/RGB)
if ndims(img) == 3
    RGB = img;    
%     [r, c, channel] = size(img);
    red_org     = RGB(:, :, 1);
    green_org   = RGB(:, :, 2);
    blue_org    = RGB(:, :, 3);
    
    if nargin == 3
        red_medfilt     = medfilt2(red_org, SIZE, 'symmetric');
        green_medfilt   = medfilt2(green_org, SIZE, 'symmetric');
        blue_medfilt    = medfilt2(blue_org, SIZE, 'symmetric');
    else
        red_medfilt     = medfilt2(red_org, 'symmetric');
        green_medfilt   = medfilt2(green_org, 'symmetric');
        blue_medfilt    = medfilt2(blue_org, 'symmetric');
    end
    
    img_filtered = cat(3, red_medfilt, green_medfilt, blue_medfilt);
    
else
    %% DO 2D Median Filtering
    if nargin == 3
        img_filtered = medfilt2(img, SIZE);
    else
        img_filtered = medfilt2(img);
    end
    
end

if show 
    display_stats(img, img_filtered);
%     figure; imshow([img, img_filtered]);
end

end