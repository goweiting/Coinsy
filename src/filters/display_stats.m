function [] = display_stats(img_before, img_after)
%% DISPLAY_STATS
%   given the before and after image, display the difference in histogram
%   for each channel

%% Processing for RGB images:
if ndims(img_before) == 3
    
    list_channels = {'Red', 'Green', 'Blue'};

    subplot(2,4,1);
    imshow(img_before);
    title('Original Image');

    subplot(2,4,5);
    imshow(img_after);
    title('Filtered Image');
    
    % plot the histogram
    for i= 1:3
        subplot(2, 4, i+1);
        plot(dohist(img_before(:,:,i)));
        title([list_channels{i}, ' Channel']);

        subplot(2, 4, 5+i);
        plot(dohist(img_after(:,:,i)));
        title([list_channels{i}, ' Channel']);
    end

else
    % 2 Dim case:
    subplot(2,2,1);
    imshow(img_before);
    title('Original Image');

    subplot(2,2,3);
    imshow(img_after);
    title('Filtered Image');
    
    % plot the histogram
    subplot(2,2,2);
    plot(dohist(img_before));
    title('Histogram (Before filter)');
    
    subplot(2,2,4);
    plot(dohist(img_after));
    title('Histogram (After filter)');
    
end


end
