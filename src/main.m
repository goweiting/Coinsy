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
    prompt_start = 'To START: enter your image file (rel/abs dir) below:\n';
    
    filename = input(prompt_start, 's'); 
    if isempty(filename)
        disp('Using trial image: practice/simpler/05.jpg');
        filename = '../practice/simpler/05.jpg';
    end
   
    % load the image into original_image
    original_image = imread(filename);
    
    % display image
    imshow(original_image);
    s = sprintf('is this the correct image? [0/1] \n');
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
    fprintf('\n Using Morphological Gradient Edge Detection...\n');
    
    % Apply morphological gradient edge detection to it
    edges_morph_TEST{1} = edge_morph_disk(original_image);
    
    % save input
    s = sprintf('./imgs/testing/edges_morph.TEST.png');
    close all; 
    figure;
    imshow(edges_morph_TEST{1})
    export_fig(s);
%     close all; % user will close!
    
    disp('NOW: Thresholding the image...');
    fprintf('\n Using findThresh...\n');
    
    % dothresholding on the image
    [IMGS_THRESH, thresh_vals ] = dothresh(edges_morph_TEST{1}, 16);
    disp(thresh_vals);
    
    s = sprintf('./imgs/testing/edges_morph_thresh.TEST.png');
    close all; 
    figure;
    imshow(IMGS_THRESH)
    export_fig(s);
%     close all;
    
    tmp = input('Continue? [1/0] ');
    if ~tmp
        disp(bar);
        return
    end
    
    disp(barbar); disp(bar); fprintf('\n\n');

%% Part 3: Feature Extraction...?
    
    disp(bar); disp(barbar);
    disp('NOW: Extracting the features...');
    
    % call extract_features
    extract_features; % will output all the features
    
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
    
    %       gather all the features in X_test:
    [~, num_instance] = size(DATA);
    for im=1:num_instance
        X_test = [X; DATA(im).Features];
    end
    
    % y_test_pred is a vector of classes predicted for each token
    [y_test_pred, prob] = gaussian_clf(X_test, DATA_CLASS);
    
    % display the classifcation of each features detected
    imshow(original_image);
    hold on;
    for i=1:length(y_test_pred);
        boundary = DATA.BoundingBox;
        class    =  y_test_pred;
        rectangle('Position', boundary, 'EdgeColor', cmap(class,:), 'LineWidth', 2);
    end
    
    % Save the figure
    s = sprintf('./imgs/testing/prediction.TEST.png',i,t);
    export_fig(s);
    
    % continue?
    fprintf('Classification Done!\n')
    tmp = input('Continue? [1/0] ');
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
    
    fprintf('Total Amount in image = %f', counter);
  
    
    disp(barbar); disp(bar); fprintf('\n\n');

%%  Part 5: Summary Statistics:
    disp(bar); disp(barbar);
    disp('SUMMARY STATISTICS');

% Expect something like:
fprintf('number of 1 pound = %d\n', sum(y_test_pred == 1));
fprintf('number of 2 pound = %d\n', sum(y_test_pred == 2));
fprintf('number of 50 pence = %d\n', sum(y_test_pred == 3));
fprintf('number of 20 pence = %d\n', sum(y_test_pred == 4));
fprintf('number of 5 pence = %d\n', sum(y_test_pred == 5));
fprintf('number of 75 pence = %d\n', sum(y_test_pred == 6));
fprintf('number of 25 pence = %d\n', sum(y_test_pred == 7));
fprintf('number of 2 pence = %d\n', sum(y_test_pred == 8));
fprintf('number of AAA Battery = %d\n', sum(y_test_pred == 9));    
fprintf('number of Nut = %d\n', sum(y_test_pred == 10));    
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
