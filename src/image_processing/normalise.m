function [img_out, gray_out] = normalise(RGB, SHOW)
%% NORMALISE_INPUT(RGB)
%   Normalise the RGB values for each pixel in the image RGB
%   Also, output the gray normalised output of RGB (i.e. normalised RGB +
%   rgb2gray();
%   The algorithm for normalisation is the root sum of channels squared.


RGB = double(RGB); % cast into double
RED_Channel     = RGB(:,:,1);
GREEN_channel   = RGB(:,:,2);
BLUE_channel    = RGB(:,:,3);

[row,col,chn] = size(RGB);
img_out = zeros(row,col,chn);

for i = 1:row
    for j = 1:col
        r = RED_Channel(i,j);
        g = GREEN_channel(i,j);
        b = BLUE_channel(i,j);
        
        sum_sq = sqrt(r^2 + g^2 + b^2);
%         sum_sq = r + g + b;
        
        img_out(i,j,1) = r/sum_sq;
        img_out(i,j,2) = g/sum_sq;
        img_out(i,j,3) = b/sum_sq;
        
    end
end

% CAST IT BACK TO INT!
RGB = uint8(RGB);
img_out = uint8(img_out*255); % IMPORTANT TO MULTIPLY BY 255!!!

%% GRAY OUT STRATEGY:
%   simple for now..!
gray_out = rgb2gray(img_out);


%% DISPLAY RESULT:
if SHOW
    display_stats(RGB, img_out);
end

end