%% Script for classification of subimages
%   USER CLASSIFY THE SUBIMAGES

%% Param

%%
for i=1:num_imgs % for each images:
    
    num_subimg = PROP{i}.num_of_obj;
    
    for obj=1:num_subimg % user have to classify each image in this picture

        img_org = PROP{i}.Properties(obj).Image;
        img_BW  = PROP{i}.Properties(obj).BWImage;
        
        close all; figure; % Close all opened windows
        
        % Plot the images
        subplot(1,2,1); 
        imshow(img_org);
        subplot(1,2,2); 
        imshow(img_BW);
        
        [relevance, class] = user_classify(img_org,0);
        
        
        if relevance
            % Update the prop:
            PROP{i}.Properties(obj).Class = class;
            PROP{i}.FLAG(obj) = 0; % dont remove
        else 
            % FLAG for removal
            PROP{i}.FLAG(obj) = 1;
        end

    end
    
    % TRIM THE DATASET even further!
    PROP{i} % display some info for the picture...
    FLAG = PROP{i}.FLAG; % get matrix of flag
    PROP{i}.Properties([logical(FLAG)]) = []; % remove irrelevant data from properties
    classified = sum(~FLAG);
    removed = sum(FLAG);
    PROP{i}.num_of_obj = classified; % update number of training example left
    
    % SHOW STATS:
    total_images =+ num_subimg;
    total_classified =+ classified;
    total_removed =+ removed;

    fprintf('SUMMARY:\n# Sub Images : %d / %d\n# Classified : %d / %d\n# Removed : %d / %d\n',...
                num_subimg, total_images, classified, total_classified,...
                removed, total_removed)
    
end