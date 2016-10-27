%% MORPHOLOGICAL GRADIENT EDGE DETECTION
% source : http://www.vlsi.uwindsor.ca/presentations/2007/13-Neil.pdf#15
%   do Edge finding by subtracting opened img with the closed image
%   following thresholding to detect edges
%%
clear all;
setup ; % load all the images
for i=1:9
    % performs edge detection using morphology with size of 3;
    edges_morph{i} = edge_morph_disk(IMGS{i});
    
    s = sprintf('./imgs/morph_thresh/edges_morph.%d.png',i);
    close all; 
    figure;
    imshow(edges_morph{i})
    export_fig(s);
    close all;
end

% use standard thresholding technique to threhsold images
[edges_morph_BW, ~ ] = dothresh(edges_morph, 16);


for i=1:9
    % store images
    s = sprintf('./imgs/morph_thresh/edges_morph_thresh.%d.png',i);
    close all; 
    figure;
    imshow(edges_morph_BW{i})
    export_fig(s);
    close all;
end

fprintf('Completed thresh holding edge morphed images');

%% Extract Features
% 
IMGS_THRESH = edges_morph_BW;
extract_features;
