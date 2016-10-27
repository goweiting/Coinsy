%% Script for classification of subimages
%   USER CLASSIFY THE SUBIMAGES
clc;
disp(bar);
fprintf('>> Manual Classification of subimages\n');
%% Param
% Color for each class
cmap = [1   0   0;      % red - class 1
        1   1   0;      % yellow - class 2
        51/255, 102/255, 0; % dark green - class 3
        0   1   0;      % green - class 4
        0   1   1;      % cyan - class 5
        0   0   1;      % blue - class 6
        152/255, 51/255 1; % purple - class 7
        1   51/255  1;  % pink - class 8
        .5   0   .5;      % purple - class 9
        .5  0   0;      % Maroon - clas 10
        0   0   0];     % black - Class 11
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
    subplot(1,2,1);
    imshow(subimg);
    subplot(1,2,2);
    imshow(bw_subimg);
    % save image into the respective class folder (timestamped)
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

ID = [DATA.ParentID];
for i=1:num_imgs % draw the boundary box with differernt color for each image
    close all;

    list_ = ID == i; % logical
    data_ = DATA(list_);
    img_BIG = PROP{i}.ORIGINAL;
    img_BW = PROP{i}.THRESH;
    imshow(img_BW); hold on;
    
    for  n=1:sum(list_)  % draw the boundary on BW image
        boundary    = data_(n).BoundingBox;
        class       = data_(n).Class;
        rectangle('Position', boundary, 'EdgeColor', cmap(class,:), 'LineWidth', 2);
    end
    s = sprintf('./imgs/manual_classy/manual_clas_pic#%d_BW.(%s).png',i,t);
    export_fig(s);

    close all; % repeat for colored images
    imshow(img_BIG); hold on;
    for  n=1:sum(list_)  % draw the boundary on BW image
        boundary    = data_(n).BoundingBox;
        class       = data_(n).Class;
        rectangle('Position', boundary, 'EdgeColor', cmap(class,:), 'LineWidth', 2);
        s = sprintf('./imgs/manual_classy/manual_clas_pic#%d_BW.(%s).png',i,t);
        export_fig(s);
    end
end


%% Delete Class 11 instances - in black box in images
fprintF('Prune subimages which are marked for removal (irrelevant)\n');
class_list  = [DATA.Class];
logica_     = [class_list == 11];
DATA(logica_) = [];
[~,init_size]   = size(class_list);
[~,after_size]  = size(DATA);
fprintf('Number of datapoints removed (class 11) = %d\n', init_size - after_size);
disp(bar);
%% NEXT >> Training the classifier