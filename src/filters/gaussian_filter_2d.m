function smoothed_2d = gaussian_filter_2d(img, show, HSIZE, SIGMA )
%% gaussian_filter_2d(img, show, HSIZE, SIGMA )
% Smooth an image using Gaussian lowpass filter and imfilter
% INPUT:
% - img : can be an RGB/HSV or GRAYSCALE image
% - HSIZE : corresponds to fspecial requirements, can be a vector
%   specifying the number of rows and columns or a scalar (infered to be a
%   squared matrix
% - SIGMA : the spreaed of the Gaussian
% N.B. Default HSIZE = [3,3], SIGMA = .5

if (nargin == 1 || nargin == 2)
    H = fspecial('gaussian');
else 
    H = fspecial('gaussian', HSIZE, SIGMA);
end


% ensure the output is the same size as img
% use conv instead of filter function
smoothed_2d = imfilter(img, H, 'conv', 'same'); 

try 
    if show
        subplot(2,2,1); imshow(img); title('Original Image');
        subplot(2,2,3); surfc(H); title('Filter');
        subplot(2,2,2); imshow(smoothed_2d); title('Smoothed Image');
    end
catch
    % if fail to input show, will just output the images!
    subplot(2,2,1); imshow(img); title('Original Image');
    subplot(2,2,3); surf(H); title('Filter');
    subplot(2,2,2); imshow(smoothed_2d); title('Smoothed Image');
end

    

        