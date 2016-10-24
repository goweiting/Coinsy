function [img_thresh, thresh_vals] = dothresh(IMGS, sizeparam)
%% DOTHRESH(IMGS)
%   Function that find the threshold for an image then apply thresholding
%   to get a binary image.
% 
%   INPUT:
%   - IMGS : a cell array of images or just an image of interest
%   - sizeparam : thte 
% 
%   OUTPUT:
%   - thresh_imgs : if IMGS is a cell array of images, so it thresh_imgs.
%       the images are thresholded with its corresponding threshold in
%       thresh_vals
%   - thresh_vals : if the imgage is RGB, then thresh_vals is a veector of
%       threshold for each RGB channel
% 
%   Dependencies:
%   - findthresh.m - from rbf's ivr repository; Standard filterlen = 50,
%       alpha = sizeparam.
%       N.B.    if filterlen is large, then curve is smoother!
%               if alpha is large, then width of the window is smaller!

%%

% % In case sizeparam is not passed
% try sizeparam
% catch
%     sizeparam = 16;
% end

if iscell(IMGS)
    [~, num_imgs] = size(IMGS); % find number of images
    thresh_vals = {}; % for storing all the threshold values

    for k = 1:num_imgs % iterate through all the images
        
        img             = IMGS{k}; % this image
        imgX            = zeros(size(img)); % the output image
        
        if ndims(img) == 3 % RGB Channel
            
            thresh_vals{k}  = zeros(1,3); % pre-allocation
            for i=1:ndims(img) % iterate through each dim to get the BW pic
                % call itself to get the threshold value (see `else` below)
                [imgX(:,:,i), thresh_vals{k}(i)] = ...
                    dothresh(img(:,:,i), sizeparam); 
            end
            
            % Now, `OR` the values together
            img_thresh{k} = imgX(:,:,1) | imgX(:,:,2) | imgX(:,:,3);
            
        end
        
    end
%% 2D image input:    
%   For 2D array, use findthresh to get the threshold for the image and
%   then get the bw representation of it! 

%   TODO: MAY need to toggle the bw = ~bw, depending if you want objects to be
%   white or black
else
    hist = dohist(IMGS); % get the histogram of 2D image
    thresh_vals = findthresh(hist, sizeparam, 0); % find the threshold of the iamge
    [n,m] = size(IMGS);
    
    % now, get the binary representation
    for i=1:n
        for j=1:m
            if IMGS(i,j) > thresh_vals % this is the objects! we want it!
                img_thresh(i,j) = 1;
            else
                img_thresh(i,j) = 0; % set background to 0
            end
        end
    end
    
end
            
end


