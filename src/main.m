%% This is the main code for the assignment:
clc;
start = 1;
bar = '=========================================================';
barbar = '---------------------------------------------------------';

while start
%  Part 1: Reading the image, query from the user

    disp(bar); disp(barbar);
    fprintf('This is the coinsy counter!\nYour current work directory is: \n\t');
    disp(pwd); disp(barbar);
    fprintf('To END: enter cltr + c\n');
    prompt_start = 'To START: enter your image file (rel/abs dir) below:\n>>  ';
    
    filename = input(prompt_start, 's'); 
    if isempty(filename)
        disp('Using trial image: practice/simpler/05.jpg');
        filename = '../practice/simpler/05.jpg';
    end
   
    % load the image into original_image
    original_image = imread(filename);
    
    % display image
    imshow(original_image);
    s = sprintf('is this the correct image? [1/0] ');
    yes = input(s);    
    if yes
        tmp = input('Continue? [1/0] ');
    else
        fprintf('Lets try again...\n');
        disp(bar);
        return
    end
    fprintf('Continuing...\n');
    
    disp(barbar); disp(bar); fprintf('\n\n')
    
%%  Part 2: Image segmentation.... ?
    
    disp(bar); disp(barbar);
    disp('NOW: Segmenting the image...');
    method = input('Which method should we use?\n[1] Morphological Gradient Edge Detection\n[2] Normalised Bg model\n>>  ');
    
    if method==1 % use morph edge detection 
        % Do median filtering first
        window_size = 5;
        fprintf('>> Filtering the image with median filter with window_size = %d\n',window_size);
        IMG = median_filter_iter(original_image, 5, 0, window_size);
        
        fprintf('\n Using Morphological Gradient Edge Detection...\n');
        % Apply morphological gradient edge detection to it
        IMGS_BGREMOVE_TEST{1} = edge_morph_disk(IMG);

        % save input
        s = sprintf('./imgs/testing/edges_morph.TEST.png');
        close all; 
        figure;
        imshow(IMGS_BGREMOVE_TEST{1})
        export_fig(s);
    %     close all; % user will close!
    
    elseif method ==2  % use normalised bg model
        try 
            IMGS_BGREMOVE_TEST{1} = bg_subtraction(original_image, bg_model);
        catch
            error('No bg_model present');
        end
        
    else return % end if user input is irrelevant
    end
    
    %% Both uses the same thresholding methdod:
    disp('NOW: Thresholding the image...');
    fprintf('\n Using findThresh...\n');
    
    % do thresholding on the image
    sizeparam = 16;
    [IMGS_THRESH_TEST, thresh_vals_TEST ] = dothresh(IMGS_BGREMOVE_TEST, sizeparam);
    fprintf('Selected sizeparam = %d\n', sizeparam);
    disp(thresh_vals_TEST{1});
    
    s = sprintf('./imgs/testing/edges_morph_thresh.TEST.png');
    close all; 
    figure;
    imshow(IMGS_THRESH_TEST{1})
    export_fig(s);
%     close all;
    
    fprintf('Done thresholding\n');
    tmp = input('Continue with feature extraction? [1/0] ');
    if ~tmp
        disp(bar);
        return
    end
    
    disp(barbar); disp(bar); fprintf('\n\n');

%% Part 3: Feature Extraction...?
    
    disp(bar); disp(barbar);
    disp('NOW: Extracting the features...');
    
    % call extract_features
    [L, NUM] = bwlabel(IMGS_THRESH_TEST{1}, 4);  fprintf('>> Calling bwlabel with size = 4\n');
    fprintf('>> Calling regionprops for: BoundingBox, Image, MajorAxisLength, MinorAxisLength, Area\n');
    
    imagery     = regionprops(L, 'BoundingBox','Image'); % this is the BW image!
    scalar      = regionprops(L, 'MajorAxisLength', 'MinorAxisLength', 'Area');
    
     % remove regions with small pixel area, which may be blobs:
    bad = [scalar.Area] <= 300;
    scalar(bad)     = []; % remove these instances 
    imagery(bad)    = [];
    fprintf('>> Prune - Area<=300: Number of subimages removed = %d\n', sum(bad));
    
    [num_subimages , ~] = size(imagery); % update the number of instances left!
    
    % grab the colored subimages, and calculate the complex moments,..etc, 
    % for ease of classification:
    fprintf('Extracting features...\n');
    num_instance = 1; % reset counter for each image
    for n=1:num_subimages

        org_img     = original_image; % get the original image
        boundary    = imagery(n).BoundingBox; % find the boundary
        subImg      = imcrop(org_img, boundary); % crop the original image according to boundary

        % calculate the moments by calling classification/getProperties
        TEST(n).Features         = getFeatures(imagery(n), scalar(n));
        TEST(n).ColoredImage     = subImg;
        TEST(n).BoundingBox      = imagery(n).BoundingBox;
        TEST(n).Image            = imagery(n).Image;
        TEST(n).MajorAxisLength  = scalar(n).MajorAxisLength;
        TEST(n).MinorAxisLength  = scalar(n).MinorAxisLength;
        TEST(n).ParentID         = i;
        TEST(n).Class            = 0; % set to 0 = unclassified
        
        fprintf('%d  ',num_instance); % display the instance number
        num_instance = num_instance + 1;
    end
    
    fprintf('\nTEST (contain all subimages) added\n\n');
    disp(bar);
    
    tmp = input('Continue? [1/0] ');
    if ~tmp
        disp(bar);
        return
    end
    
    disp(barbar); disp(bar); fprintf('\n\n');
%% Part 4: Classification

    disp(bar); disp(barbar);
    disp('NOW: Classifying the image...');
    
    % Since the DATA_CLASS is already trained (from previous samples)
    %     We are ready to classify
    
    try % ensure that the class information are present
        DATA_CLASS_MODEL;
        fprintf('>> DATA_CLASS_MODEL \t\t Checked\n');
    catch
        error('data_class is not present!');
    end
    
    X_test = [];
    y_test = [];
    % gather all the features in X_test:
    [~, num_instance] = size(TEST);
    for im=1:num_instance
        X_test = [X_test; TEST(im).Features];
    end
    
    % y_test_pred is a vector of classes predicted for each token
    [y_test_pred, prob] = gaussian_clf(X_test, DATA_CLASS_MODEL);
    
    % display the classifcation of each features detected

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
    labels = {'1 pound', '2 pound', '50p', '20p', '5p', '75p', '25p', '2p', 'battery', 'nut', 'unclass'};
    close all;

    % plot the bounding box
%     for i=1:length(y_test_pred)
%         original_image = insertText(original_image, boundary(1:2), labels{class});
%     end
    fig = imshow(original_image);
    hold on;
    for i=1:length(y_test_pred)
        boundary = TEST(i).BoundingBox;
        class    =  y_test_pred(i);
        fprintf('class = %d\n',class);
        rectangle('Position', boundary, 'EdgeColor', cmap(class,:), 'LineWidth', 1);
        
    end
    
    fprintf('# :\tColor\n1\tRed\n2\tYellow\n3\tDark Greent\n4\tGreen\n5\tCyan\n6\tBlue\n7\tPurple\n8\tPink\n9\tDark Purple\n10\tMaroon\n11\tUnclassified\n\n');
    
    % Save the figure
    s = sprintf('./imgs/testing/prediction.TEST.png',i,t);
    export_fig(s);
    
    % continue?
    fprintf('Classification Done!\n')
    tmp = input('Continue with counting? [1/0] ');
    if ~tmp
        disp(bar);
        return
    end
    
    
    disp(barbar); disp(bar); fprintf('\n\n');
    
%% Part 5: Coinsy Counter:
    
    disp(bar); disp(barbar);
    disp('NOW: Initialising the counter...');
    % counter starts at 0
    counter = 0;
    values = [1,2,.5,.2,.05,.75,.25,.2,0,0,0];
    for i=1:length(y_test_pred)
        class = y_test_pred(i);
        counter = counter + values(class);
    end

%%  Part 5: Summary Statistics:
    disp(bar); disp(barbar);
    disp('SUMMARY STATISTICS');

% Expect something like:
fprintf('number of 1 pound \t= %d\n', sum(y_test_pred == 1));
fprintf('number of 2 pound \t= %d\n', sum(y_test_pred == 2));
fprintf('number of 50 pence \t= %d\n', sum(y_test_pred == 3));
fprintf('number of 20 pence \t= %d\n', sum(y_test_pred == 4));
fprintf('number of 5 pence \t= %d\n', sum(y_test_pred == 5));
fprintf('number of 75 pence \t= %d\n', sum(y_test_pred == 6));
fprintf('number of 25 pence \t= %d\n', sum(y_test_pred == 7));
fprintf('number of 2 pence \t= %d\n', sum(y_test_pred == 8));
fprintf('number of AAA Battery \t= %d\n', sum(y_test_pred == 9));    
fprintf('number of Nut \t\t= %d\n', sum(y_test_pred == 10));    
disp(barbar);
fprintf('Total Amount in image = %.2f\n', counter);
    disp(barbar); disp(bar); fprintf('\n\n');

%% Next image?
    % single loop for now:
    prompt_end = ('Do you want to load another image? [y/n]');
    x = input(prompt_end, 's');
    switch x
        case 'y'
            start = 1;
        case 'n'
            start = 0;
        case 'Y'
            start = 1;
        case 'N'
            start = 0;
        otherwise
            start = 1;
    end
end
