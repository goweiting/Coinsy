function smoothed_1d = gaussian_filter_1d(hist, show, window_size, alpha)
%% Uses the gausswin function to produce a gaussian window,
% then apply a conv to the 1d - hist. If hist is not 1d, coerce it into 1d
% Note: 
% As alpha increase, width of window will decrease. Default = 2.5
% As window_size increase, the curve will be smoother.
% Use dohist to get the histogram!

% first check for the size of the image, if not 1d, coerce it
if ndims(hist) == 3 % a color image is input,
    % convert to grayscale first:
    hist = rgb2gray(hist);
end

% Use dohist to get the histogram of intensity
hist = dohist(hist,0);

% window_size and alpha not defined, use default
if nargin == 1 || nargin == 2
    gauss_filter = gausswin(50, 6);
else   
    gauss_filter = gausswin(window_size, alpha);
end

filter = gauss_filter/ sum(gauss_filter);
smoothed_1d = conv(filter, hist);

try 
    if show
        subplot(2,2,1); plot(hist); title('Original Image');
        subplot(2,2,3); plot(filter); title('Filter');
        subplot(2,2,2); plot(smoothed_1d); title('Smoothed Image');
    end
catch
    subplot(2,2,1); imshow(hist); title('Original Image');
    subplot(2,2,3); plot(filter); title('Filter');
    subplot(2,2,2); imshow(smoothed_1d); title('Smoothed Image');
end
