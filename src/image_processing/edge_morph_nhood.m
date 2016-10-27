function edges_morph = edge_morph_nhood(img, NHOOD)
%% EDGE_MORPH_NHOOD
%   outputs the edges by morphing the image, followed by a threshold
%   segmentation.
%   Specifically, a user-defined nhood will be used

% INPUT:
%   If the user did not define the nhood, a default nhood will be used.

% DEPENDENCIES:
%   
%% MORPHING:

if nargin == 1 % no NHOOD defined:
    % Default nhood:
    nhood = [0 1 0; 1 1 1; 0 1 0];
    SE_nhood = strel(nhood);
end

% user defined a SE class ,instead of a matrix
if isa(NHOOD, 'strel')
   SE_nhood = strel(NHOOD); 
end


% Subtract for the edges:
big = imdilate(img, SE_nhood); 
small = imerode(img, SE_nhood);
edges_morph = big - small;

%% THRESHOLDING
%   Whats left is finding an appropriate threshold value for the image.
%   The output will be a BW binary matrix when 1 indicates the presence of
%   an edge

% TODO: DO THRESHOLDING HERE!


%% DISPLAY
figure;

subplot(2,2,1) ;
imshow(img); 
title('Original'); 

subplot(2,2,2); 
imshow(edges_morph); 
title('Edges');

subplot(2,2,3)
imshow(big)
title('Dilation');

subplot(2,2,4)
imshow(small)
title('Erosion');

end
