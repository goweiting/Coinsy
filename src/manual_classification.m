%% Script for classification of subimages
%   USER CLASSIFY THE SUBIMAGES

%% Param
% Color for each class
cmap = [0.80369089,  0.61814689,  0.46674357;
        0.81411766,  0.58274512,  0.54901962;
        0.58339103,  0.62000771,  0.79337179;
        0.83529413,  0.5584314 ,  0.77098041;
        0.77493273,  0.69831605,  0.54108421;
        0.72078433,  0.84784315,  0.30039217;
        0.96988851,  0.85064207,  0.19683199;
        0.93882353,  0.80156864,  0.4219608 ;
        0.83652442,  0.74771243,  0.61853136;
        0.7019608 ,  0.7019608 ,  0.7019608
        244/255, 66/255, 66/255]; % Class 11
total_instance = 0;
total_relevant = 0;
t = datetime('now'); % for image title


%%
[~, num_instance] = size(DATA);
for i=1:num_instance % for each datapoint:

    img_num     = DATA(i).ParentID;
    img_BIG     = PROP{img_num}.ORIGINAL; % original big image
    subimg      = DATA(i).ColoredImage;
    bw_subimg   = DATA(i).Image;

    fprintf('\n\n\n\nObject %d/%d\n', i , num_instance);
    close all; figure; % Close all opened windows

    % Plot the images
    subplot(1,2,1);
    imshow(subimg);
    subplot(1,2,2);
    imshow(bw_subimg);

    % call function to for classification
    [relevance, class] = user_classify();
    close all;
    % if user need help, display the bigger image with a bounding box for object:
    while class == 0
        fig = figure;
        imshow(img_BIG);
        hold on;
        rectangle('Position', DATA(i).BoundingBox,... % draw rectangle around img
            'EdgeColor', 'r', 'LineWidth',3);
        [relevance, class] = user_classify();
        close all;
    end

    DATA(i).Class = class; % store the class; irrelevant ones at 11

    % SAVE THE IMAGE
    imshow(subimg);
    s = sprintf('./imgs/CLASS_%d/%s_%d.png', class, t, num_instance);
    export_fig(s);
    close;

end

%% DISPLAY and drawings
close all; figure;
imshow(img_BIG);
titl = sprintf('Classification for picture %d (%s)',i,t);
title(titl);
hold on;
[~,num_imgs] = size(PROP); % num of images
>>>>>>> report

ID = [DATA.ParentID];
for i=1:num_imgs % draw the boundary box with differernt color for each image
    close all;

    list_ = ID == i; % logical
    data_class = DATA(list_);
    img_BIG = PROP{i}.ORIGINAL;
    img_BW = PROP{i}.THRESH;
    imshow(img_BW); hold on;
    for  n=1:sum(list_)  % draw the boundary on BW image
        boundary    = data_class(n).BoundingBox;
        class       = data_class(n).Class;
%         disp(cmap(class,:));
        rectangle('Position', boundary, 'EdgeColor', cmap(class,:), 'LineWidth', 2);
        s = sprintf('./imgs/manual_classy/manual_clas_pic#%d_BW.(%s).png',i,t);
        export_fig(s);
    end

    close all; % repeat for colored images
    imshow(img_BIG);
    for  n=1:sum(list_)  % draw the boundary on BW image
        boundary    = data_class(n).BoundingBox;
        class       = data_class(n).Class;
%         disp(cmap(class,:));
        rectangle('Position', boundary, 'EdgeColor', cmap(class,:), 'LineWidth', 2);
        s = sprintf('./imgs/manual_classy/manual_clas_pic#%d_BW.(%s).png',i,t);
        export_fig(s);
    end
end


%% Delete Class 11 instances
class_list  = [DATA.Class];
logica_     = [class_list == 11];
DATA(logica_) = [];
[~,init_size]   = size(class_list);
[~,after_size]  = size(DATA);
fprintf('Number of datapoints removed (class 11) = %d\n', init_size - after_size);
