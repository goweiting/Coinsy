function img_filtered = median_filter_iter(img, ITER, show, SIZE)
%% MEDIAN_FILTER_ITER
%   Use median filtering for a definite number of times.
% INPUT:
%   img     : initial image
%   ITER    : Number of iteration 
%   show    : to display the images after
%   SIZE    : SIZE of the filter window (OPTIONAL)

%%

img_temp = img;

try
    for i = 1:ITER
        img_temp = median_filter(img_temp, 0, SIZE);
    end
catch
    for i = 1:ITER
        img_temp = median_filter(img_temp, 0);
    end
end

if show
    display_stats(img, img_temp);
end

img_filtered = img_temp;
end
