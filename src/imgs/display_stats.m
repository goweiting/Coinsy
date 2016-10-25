function [] = display_stats(img_before, img_after)
%% DISPLAY_STATS
%   given the before and after image, display the difference in histogram
%   for each channel

%% Processing for RGB images:
list_channels = {'Red', 'Green', 'Blue'};
% Toggle between display info of an image or comparing before/after image
switch nargin 
    case 2
        if ndims(img_before) == 3

            subplot(2,4,1);
            imshow(img_before);
            title('Original Image');

            subplot(2,4,5);
            imshow(img_after);
            title('Filtered Image');

            % plot the histogram
            for i= 1:3
                subplot(2, 4, i+1);
                x = dohist(img_before(:,:,i));
                plot(x);
                title([list_channels{i}, ' Channel']);

                subplot(2, 4, 5+i);
                y = dohist(img_after(:,:,i));
                plot(y);
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
%% Added support for just visualising a single image:
%   Usage: a single img (RGB or GRAY) as argument
    case 1
    
    %  MANUALLY tweak the pararm
    ITER = 4;
    SIZE_MF = 3;
    SIGMA_GAUSS = 1;
    SIZE_GAUSS = 5;
    set(gcf, 'Position', get(0,'Screensize')); % set fullscreen
   
    
    if ndims(img_before) == 3 % if RGB
        subplot(5,4,[1 2 5 6]);
        imshow(img_before);
        title('RGB image');

        % Use double for filtering:
        smoothed_surfc = median_filter_iter(double(img_before), ITER, 0, SIZE_MF);
        % should double smooth ??
        smoothed_surfc = gaussian_filter_2d(smoothed_surfc, 0, SIZE_GAUSS, SIGMA_GAUSS); 
        GRAY = rgb2gray(uint8(smoothed_surfc));
        
        subplot(5,4, [3 4 7 8]);
        meshc(GRAY);
        colormap(gray);
        colorbar;
        title('Smoothened surface contour');

        % Now, plot the respective channels
        % RED
        RED = img_before(:,:,1);
        
        subplot(5,4,9);
        imshow(RED);
        title('Red Channel');

        RED_hist = dohist(RED);
        subplot(5,4,10);
        plot(RED_hist);
        xlim([0,255])
        title('Red channel histogram');
        
        [x,y] = imgradientxy(double(RED));
        [RED_gmag, ~] = imgradient(x,y);
        RED_gmag = reshape(RED_gmag, [], 1); % reshape into a column vector
        RED_col = double(reshape(RED, [], 1)); % reshape into a column vector
        subplot(5,4,11);
        scatter(RED_col, RED_gmag, '.', 'r');
%         scatterhist(RED_col, RED_gmag);
        xlim([0,255])
        title('Gradient magnitude');

        % GREEN
        GREEN = img_before(:,:,2);
        
        subplot(5,4,13);
        imshow(GREEN);
        title('Green Channel');

        GREEN_hist = dohist(GREEN);
        subplot(5,4,14);
        plot(GREEN_hist);
        xlim([0,255])
        title('Green channel histogram');
        
        [x,y] = imgradientxy(double(GREEN));
        [Green_gmag, ~] = imgradient(x,y);
        Green_gmag = reshape(Green_gmag, [], 1); % reshape into a column vector
        Green_col = double(reshape(GREEN, [], 1)); % reshape into a column vector
        subplot(5,4,15);
        scatter(Green_col, Green_gmag, '.', 'g');
%         scatterhist(RED_col, RED_gmag);
        xlim([0,255])
        title('Gradient magnitude');
       
        % BLUE
        BLUE = img_before(:,:,3);
        
        subplot(5,4,17);
        imshow(img_before(:,:,3));
        title('Blue Channel');
        
        BLUE_hist = dohist(BLUE);
        subplot(5,4,18);
        plot(BLUE_hist);
        xlim([0,255])
        title('Blue channel histogram');
        
        [x,y] = imgradientxy(double(BLUE));
        [Blue_gmag, ~] = imgradient(x,y);
        Blue_gmag = reshape(Blue_gmag, [], 1); % reshape into a column vector
        Blue_col = double(reshape(BLUE, [], 1)); % reshape into a column vector
        subplot(5,4,19);
        scatter(Blue_col, Blue_gmag, '.', 'b');
%         scatterhist(Blue_col, Blue_gmag);
        xlim([0,255])
        title('Gradient magnitude');
        
    else ndims(img_before ) == 2 % if GRAY
        
        GRAY = img_before; % in uint8!
        subplot(2,2,1);
        imshow(GRAY);
        title('Gray Image');
        
        smoothed_surfc = median_filter_iter(double(GRAY), ITER, 0, SIZE_MF);
        smoothed_surfc = gaussian_filter_2d(smoothed_surfc, 0, SIZE_GAUSS, SIGMA_GAUSS);
        subplot(2,2,2);
        meshc(smoothed_surfc);
        colormap(gray);
        colorbar;
        title('Smoothened Surface Contour');

        % Histogram
        GRAY_hist = dohist(GRAY);
        subplot(2,2,3);
        plot(GRAY_hist);
        xlim([0,255])
        title('Histogram of pixel intensity');
        
        % gradient magnitude vs intensity
        [Gx, Gy] = imgradientxy(double(GRAY));
        [GRAY_gmag, ~] = imgradient(Gx, Gy);
        % column vector
        GRAY_gmag = reshape(GRAY_gmag, [], 1);
        GRAY = reshape(double(GRAY), [], 1);
        % plot
        subplot(2,2,4);
        scatter(GRAY, GRAY_gmag, '.', 'm');
        xlim([0,255])
        title('Gradient magnitude');
        
    end

end

end
