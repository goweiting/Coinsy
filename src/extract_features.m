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

%%
[~, num_imgs] = size(IMG_THRESH);
PROP ={}; % define an array to hold the structs for each images

for i=1:num_imgs % create the structs for each sample images
    
    % here, get the label from the threshold image, and extract information
    % about each label, store in Properties
    %!!! for manual adding, use PROP{i}.prop(OBJ_NUM).<label> = <value> %%
    [L, num]    = bwlabel(IMG_THRESH{i}, 8);
    imagery     = regionprops(L, 'BoundingBox', 'ConvexHull', 'ConvexImage',...
                    'FilledImage', 'Image','Centroid'); % this is the BW image!
    scalar      = regionprops(L, 'Area','ConvexArea','Eccentricity', ...
                    'EquivDiameter','EulerNumber', 'Extent', 'FilledArea', ...
                    'MajorAxisLength', 'MinorAxisLength', 'Perimeter', 'Solidity');
    
    % remove regions with small pixel area, which may be blobs:
    bad = [scalar.Area] <= 500;
    scalar(bad)     = [];
    imagery(bad)    = [];
    disp('prune - Area<=500'); %% DEBUG
    
    [num , ~] = size(imagery); % update the number of instances left!
        
    % grab the colored subimages, and calculate the complex moments,..etc, 
    % for ease of classification:
    vect = struct();
    for n=1:num
        org_img     = IMGS{i}; % get the original image
        boundary    = imagery(n).BoundingBox; % find the boundary
        subImg      = imcrop(org_img, boundary); % crop the original image according to boundary
        imagery(n).ColoredImage = subImg;  % assign into the struct
        
        % calculate the moments by calling classification/getProperties
        scalar(n).Features = getFeatures(imagery(n), scalar(n));
    end
    
    % store in struct
    PROP{i} = struct('label', L, ...
                'num_of_obj', num, ... 
                  'ORIGINAL', IMGS{i},...
                    'THRESH', IMG_THRESH{i},...
                 'SubImages', imagery,...
                'Properties', scalar);
                    
end

%% Clasify yeahh?
man_class = input('do you want to manually classify these images now? [0/1]');
if man_class
    manual_classification;
end
%%