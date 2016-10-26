%% Script for classification of subimages
%   USER CLASSIFY THE SUBIMAGES

%% Param
color1 = [1 .8 0];
color2 = [1 0 .25];
cmap = [0.80369089,  0.61814689,  0.46674357;
        0.81411766,  0.58274512,  0.54901962;
        0.58339103,  0.62000771,  0.79337179;
        0.83529413,  0.5584314 ,  0.77098041;
        0.77493273,  0.69831605,  0.54108421;
        0.72078433,  0.84784315,  0.30039217;
        0.96988851,  0.85064207,  0.19683199;
        0.93882353,  0.80156864,  0.4219608 ;
        0.83652442,  0.74771243,  0.61853136;
        0.7019608 ,  0.7019608 ,  0.7019608];
% cmap = {color1;color2,'y';'m';'b';'r';'c';'g';'w';'k'};
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
        disp(cmap(class,:));
        rectangle('Position', boundary, 'EdgeColor', cmap{class}, 'LineWidth', 2);
    end
    s = sprintf('./imgs/manual_classy/manual_clas_pic#%d.(%s).png',i,t);
    export_fig(s);
    tmp = 0;
    while ~tmp
        tmp = input('Ready?[1/0]');
    end
    
end