function [ bg_model ] = bg_extract( IMGS, WINDOW_SIZE)
%% BACKGROUND_MODEL(IMG, WINDOW_SIZE
%   Given a series of image, we find the common background using median
%   filtering. For each pixel in the bg_model, we take the median of all
%   the pixels in the WINDOW_SIZE for all the images. If WINDOW_SIZE = 1,
%   it is equivalent to taking the median of pixel intensity in all the
%   images. 
%   If input image is RGB, then this is carried out for all channel.

%   INPUT:
%   - IMGS : A cell array of images. Images must be of the same size. IMGS
%   have size of (1,num_imgs)
%   - WINDOW_SIZE : the window of median_filter. If undefined, WINDOW_SIZE
%   = 1

%   OUTPUT:
%   - bg_model - an image of the same size as IMGS with the background
%   extracted.

%% Setting parameters
if nargin == 1
    WINDOW_SIZE = 1;
end

[~, num_imgs] = size(IMGS);
sample = IMGS{1};
bg_model = (sample); % preallocation of memory

% Given a WINDOW_SIZE, find the number of cell to compensate:
% Window_Size    1 3 5 7 9...
% offset     ==  1 2 3 4 5 
% ==>  offset = (WS + 1) / 2

% prevent even number WINDOW_SIZE
if mod(WINDOW_SIZE,2) ~= 1
    error('Window_size must be an odd number!');
end

offset = uint64((WINDOW_SIZE + 1)/2);

disp('Extracting background from images....');
fprintf('WINDOW_SIZE = %d\n', WINDOW_SIZE);
fprintf('Offset = %d\n', uint8(offset));


%% iterate through all the images and set the 
if ndims(sample) == 3
    
    [rows, cols, ~] = size(sample);
    
    % iterate each cell, neglecting offset cause of WINDOW_SIZE
    for i = offset:rows-offset
        for j = offset:cols-offset
%             disp([i,j]); %DEBUG

            % store all the values from each img in IMGS
            median_RED      = zeros(1, num_imgs);
            median_GREEN    = zeros(1, num_imgs);
            median_BLUE     = zeros(1, num_imgs);
            
            % find bounding box of pixels
            x_low   = i - offset + 1;
            x_high  = i + offset - 1;
            y_low   = j - offset + 1;
            y_high  = j + offset - 1;
%             disp([x_low,x_high,y_low,y_high]); % DEBUG
            
            % iterate through all the pixels for the image
            for k=1:num_imgs    
                % get the pixels belonging in the image:
                pixels_RED      = IMGS{k}(x_low:x_high, y_low:y_high, 1);
                pixels_RED      = reshape(pixels_RED, [], 1);
                median_RED(k)   = median(pixels_RED); % get the median of the nieghbood! 
                
                pixels_GREEN    = IMGS{k}(x_low:x_high, y_low:y_high, 2);
                pixels_GREEN    = reshape(pixels_GREEN, [], 1);
                median_GREEN(k) = median(pixels_GREEN); % get the median of the nieghbood! 
                
                pixels_BLUE     = IMGS{k}(x_low:x_high, y_low:y_high, 3);
                pixels_BLUE     = reshape(pixels_BLUE, [], 1);
                median_BLUE(k)  = median(pixels_BLUE); % get the median of the nieghbood! 
            end
            
            % Set the meidan for respecitve color channel to the bg_model
            bg_model(i,j,1) = median(median_RED);
            bg_model(i,j,2) = median(median_GREEN);
            bg_model(i,j,3) = median(median_BLUE);
        end
        fprintf('.');
    end
    
else
%% 2D images:
    [rows, cols] = size(sample);
    
    % iterate each cell 
    for i = offset : rows-offset
        for j = offset : cols-offset
            
            median_val = zeros(1,num_imgs);
            
            % finding bounding box:
            x_low   = i - offset + 1;
            x_high  = i + offset - 1;
            y_low   = j - offset + 1;
            y_high  = j + offset - 1;
            
            % iterate through all the pixels for the image
            for k=1:num_imgs    
            % find bounding box of pixels
                pixels  = IMGS{k}(x_low:x_high, y_low:y_high);
                pixels  = reshape(pixels, [], 1);
                median_val(k) = median(pixels); % get the median of the nieghbood! 
            end
            % Set the meidan for respecitve color channel to the bg_model
            bg_model(i,j) = median(median_val);
            
        end
        fprintf('.');
    end


end

bg_model = uint8(bg_model); % cast back to int

imshow(bg_model);
disp('done');

end