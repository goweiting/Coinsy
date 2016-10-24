%% Script for feature extraction
% 
% This script follows naturally from the segmentation script where the 
% images are segmented and edges are found. The next step in the operation
% pipeline is then to find the obejects in the picture, then extract 
% the features from the objects
% 
% assume you have done called segmentation and the following are in 
% the workspace:
% 1) bg_model       : the background model we generated
% 2) IMGS           : the original images (in cell array)
% 3) IMG_BGREMOVE   : the original iamges bg removed
% 4) IMG_THRESH     : the BW images thresholded. The objects are in white/1


%%  FINDING CONNECTED COMPONENTS
%   Connected components == objects; using matlab's script
%   TODO: Check compatability with school's system
% 
%   The basic steps in finding the connected components are:
%     Search for the next unlabeled pixel, p.
%     Use a flood-fill algorithm to label all the pixels in the connected 
%       component containing p.
%     Repeat steps 1 and 2 until all the pixels are labelled.

[~, num_imgs] = size(IMG_THRESH);

for i=1:num_imgs % create the structs for each images
    % N.B. bwlabel / bwlabeln does the same thing, bwconncomp is more
    % efficient. Syntax might be different
    CC{i} = bwconncomp(IMG_THRESH{i});  % uses 8 connectivity
end


%% FEATURE EXTRACTION

% prop = ['Area', 'EulerNumber', 'Orientation', 'BoundingBox', 'Extent',...
%         'Perimeter', 'Centroid', 'Extrema', 'PixelIdxList', 'ConvexArea',...
%         'FilledArea', 'PixelList', 'ConvexHull', 'FilledImage', 'Solidity',...
%         'ConvexImage', 'Image', 'SubarrayIdx', 'Eccentricity',...
%         'MajorAxisLength', 'EquivDiameter', 'MinorAxisLength'];

for i=1:num_imgs
    % use regionprops function, the CC array defined above and the original
    % images to extract the properties and images:
    props{i} = regionprops(CC{i}, IMGS{i}, prop);
end

