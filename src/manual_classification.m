%% Script for classification of subimages
%   USER CLASSIFY THE SUBIMAGES

%% Param
cmap = {[1 .8 0];[1 0 .25],'y';'m';'b';'r';'c';'g';'w';'k'};
total_images = 0;
total_classified = 0;
total_removed = 0;
DATA = struct(); % FOR STORING ALL THE SAMPLES!


%%
for i=1:num_imgs % for each images:
    
    num_subimg = PROP{i}.num_of_obj;
    img_BIG = PROP{i}.ORIGINAL; % the big picture
    
    for obj=1:num_subimg % user have to classify each image in this picture

        img_org = PROP{i}.SubImages(obj).ColoredImage;
        img_BW  = PROP{i}.SubImages(obj).Image;
        
        fprintf('\n\n\n\nObject %d\n',obj);
        close all; figure; % Close all opened windows
        
        % Plot the images
        subplot(1,2,1); 
        imshow(img_org);
        subplot(1,2,2); 
        imshow(img_BW);
        
        % call function to for classification
        [relevance, class] = user_classify(img_org, 0);
        
        % if user need help:
       	while class == 0    
            fig = figure;
            imshow(img_BIG);
            hold on;
            rectangle('Position', PROP{i}.SubImages(obj).BoundingBox,... % draw rectangle around img
                'EdgeColor', 'r', 'LineWidth',3);
            [relevance, class] = user_classify(img_org, 0);
            close ;
        end
        
        PROP{i}.Properties(obj).Class = class; % irrelevant class is 404
%         DATA(i,num_subimg).Class        = class;
%         DATA(i,num_subimg).ColoredImage = img_org;
%         DATA(i,num_subimg).BWImage      = img_BW;
        
    end
    
    %% TRIM THE DATASET even further!
    % Irrelevant classes will be removed!
    irrel = [PROP{i}.Properties.Class] == 404; % get matrix of flag
    PROP{i}.SubImages(irrel)    = [];
    PROP{i}.Properties(irrel)   = [];
    
    classified          = sum(~irrel);
    removed             = sum(irrel);
    PROP{i}.num_of_obj  = classified; % update number of training example left
    disp('>>Prune - IRRELEVANT'); %% DEBUG
    PROP{i}
    
    total_images        =+ num_subimg;
    total_classified    =+ classified;
    total_removed       =+ removed;
    
    

    fprintf('SUMMARY:\n# Sub Images : %d / %d\n# Classified : %d / %d\n# Removed : %d / %d\n',...
                num_subimg, total_images, classified, total_classified,...
                removed, total_removed);
            
    %% DISPLAY
    close all; figure;
    imshow(img_BIG);
    t=datetime('now');
    titl = sprintf('Classification for picture %d (%s)',i,t);
    title(titl);
    hold on;
    
    for obj=1:PROP{i}.num_of_obj % draw the boundary box with differernt color
        boundary = PROP{i}.SubImages(obj).BoundingBox;
        class  = PROP{i}.Properties(obj).Class;
        disp(cmap{class});
        rectangle('Position', boundary, 'EdgeColor', cmap{class}, 'LineWidth', 2);
    end
    s = sprintf('./imgs/manual_classy/manual_clas_pic#%d.(%s).png',i,t);
    export_fig(s);
    tmp = 0;
    while ~tmp
        tmp = input('Ready?[1/0]');
    end
    
end