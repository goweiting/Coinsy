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
[~, num_imgs] = size(IMGS_THRESH);
PROP ={}; % define an array to hold the structs for each images
DATA = struct(); % struct to hold all the subimages
num_instance = 1; % counter for number of instances

% iterate through all the images to extract the subimages and its properties
for i=1:num_imgs 
    
    fprintf('image %d ',i);
    
    % here, get the label from the threshold image, and extract information
    % about each region
    [L, ~]      = bwlabel(IMGS_THRESH{i}, 4); %% THIS IS A PARAMETER TO PLAY WITH
    imagery     = regionprops(L, 'BoundingBox','Image'); % this is the BW image!
    scalar      = regionprops(L, 'MajorAxisLength', 'MinorAxisLength', 'Area');
    
    % remove regions with small pixel area, which may be blobs:
    bad = [scalar.Area] <= 300;
    scalar(bad)     = []; % remove these instances 
    imagery(bad)    = [];
    disp('prune - Area<=300'); %% DEBUG
    
    [num_subimages , ~] = size(imagery); % update the number of instances left!
        
    % grab the colored subimages, and calculate the complex moments,..etc, 
    % for ease of classification:
    for n=1:num_subimages
        
        org_img     = IMGS{i}; % get the original image
        boundary    = imagery(n).BoundingBox; % find the boundary
        subImg      = imcrop(org_img, boundary); % crop the original image according to boundary
        
        % calculate the moments by calling classification/getProperties
        DATA(num_instance).Features         = getFeatures(imagery(n), scalar(n));
        DATA(num_instance).ColoredImage     = subImg;
        DATA(num_instance).BoundingBox      = imagery(n).BoundingBox;
        DATA(num_instance).Image            = imagery(n).Image;
        DATA(num_instance).MajorAxisLength  = scalar(n).MajorAxisLength;
        DATA(num_instance).MinorAxisLength  = scalar(n).MinorAxisLength;
        DATA(num_instance).ParentID         = i;
        DATA(num_instance).Class            = 0; % set to 0 = unclassified
        
        fprintf('%d  ',num_instance);
        num_instance = num_instance + 1;
    end
    
    % store in struct
    PROP{i} = struct('label', L, ...
                'num_of_obj', num_subimages, ... 
                  'ORIGINAL', IMGS{i},...
                    'THRESH', IMGS_THRESH{i},...
                 'SubImages', imagery,...
                'Properties', scalar);
    
    fprintf('\t\tDone\n');
end

% clear boundary;
% clear imagery;
% clear scalar;
%%