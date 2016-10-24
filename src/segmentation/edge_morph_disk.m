function edges_morph = edge_morph_disk(img)
%% EDGE_MORPH
%   outputs the edges found from morphing the image
%   specifically, the disk strcture element will be used

% DEPENDENCIES:
%   filters/morph_disk.m

%% MORPHING
img_disk_big    = morph_disk(img, 1,  3, 0);  % DILATION
img_disk_small  = morph_disk(img, 0,  1 , 0); % EROSION

% Subtract for gradient edge detection
edges_morph = img_disk_big - img_disk_small; 

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
imshow(img_disk_big)
title('Dilation');

subplot(2,2,4)
imshow(img_disk_small)
title('Erosion');


end
