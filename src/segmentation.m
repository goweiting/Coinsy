%% SCRIPT FOR IMAGE SEGMENTATION:
%   Here, we attempt to use gradient magnitude for segmentation:
%   Gradient magnitude and direction tells us where the edges are.
%   first, we find the gradient in each direction (x,y) and then find the
%   zero-crossings of pixels
%   Reference: http://homepages.inf.ed.ac.uk/rbf/CVonline/LOCAL_COPIES/MORSE/edges.pdf
%   Problem:
%   - Sensitive to noise
%   - two pixel thick edges 

%   Functions used:
%   -   




%% START CODE:
clc,clf,clear all; close all;

% add all relevant folders && misc stuff
addpath('filters/', 'image_processing/', 'segmentation/', 'classification/', ...
    'object_recognition/', 'dataset/'); %,...
%     'classification/COUNT/1POUND','classification/COUNT/20P/',...
%     'classification/COUNT/25P/','classification/COUNT/2P/','classification/COUNT/2POUND/',...
%     'classification/COUNT/50P/','classification/COUNT/5P/','classification/COUNT/75P/',...
%     'classification/DONT_COUNT/AAA/','classification/DONT_COUNT/NUT/');

bar = '=========================================================';
barbar = '---------------------------------------------------------';

% add all given images for traiing
% ? SHOULD we add the harder ones too?
img2    = imread('../practice/simpler/02.jpg');
img3    = imread('../practice/simpler/03.jpg');
img4    = imread('../practice/simpler/04.jpg');
img5    = imread('../practice/simpler/05.jpg');
img6    = imread('../practice/simpler/06.jpg');
img7    = imread('../practice/simpler/07.jpg');
img8    = imread('../practice/simpler/08.jpg');
img9    = imread('../practice/simpler/09.jpg');
img10   = imread('../practice/simpler/10.jpg');
IMGS    = {img2, img3, img4, img5, img6, img7, img8, img9, img10};

img11   = imread('../practice/harder/17.jpg');
img12   = imread('../practice/harder/18.jpg');
img13   = imread('../practice/harder/19.jpg');
img14   = imread('../practice/harder/20.jpg');
img15   = imread('../practice/harder/21.jpg');

IMGS_BG = {img2, img3, img4, img5, img6, img7, img8, img9, img10, ... 
            img11, img12, img13, img14, img15 };
[~, num_img_bg]  = size(IMGS_BG);

%% PRE-PROCESSING%%
fprintf('\t\tPREPROCESSING IMAGES\n');

% RGB = img4;
% RED = RGB(:,:,1); GREEN = RGB(:,:,2); BLUE = RGB(:,:,3);
% 
% % find gradient magnitude and plot:
% % [RED_gx, RED_gy]        = imgradientxy(RED);
% % [GREEN_gx, GREEN_gy]    = imgradientxy(GREEN);
% % [BLUE_gx, BLUE_gy]      = imgradientxy(BLUE);
% % [RED_gm ,~] = imgradient(RED_gx,RED_gy);
% % [BLUE_gm, ~] = imgradient(BLUE_gx, BLUE_gy);
% % [GREEN_gm, ~] = imgradient(GREEN_gx, GREEN_gy);
% % 
% % RGB_gm = cat(3,RED_gm, BLUE_gm, GREEN_gm);
% 
% GRAY = rgb2gray(RGB);
% [gx,gy] = imgradientxy(GRAY);
% gmag = imgradient(gx,gy);


%% TRYING NORMALISING = BLUE CHANNEL:

%% NORMALISATION
%   Here, we normalise the images before extracting the background
disp(bar);

fprintf('\n>> Normalising the images\n');
for i = 1:num_img_bg
    fprintf('.');
    IMGS_BG{i} = IMGS_BG{i}(:,:,3);
%     figure; % DEBUG
end
fprintf('\n%d images Normalised\n\n', i);

disp(bar);

%% IMAGE SEGMENTATION %%
fprintf('\t\tIMAGE SEGMENTATION\n');
fprintf('Approach:\n1) Generate background model\n2) Background subtraction\n3) Thresholding\n');
%% GENERATE BACKGROUND MODEL
disp(bar);

WINDOW_SIZE = 1;
fprintf('\n>> Generating Background Model With WINDOW_SIZE = %d\n', WINDOW_SIZE);
bg_model = bg_extract(IMGS_BG, WINDOW_SIZE);

fprintf('\n'); disp(bar);

%% BACKGROUND SUBTRACTION
disp(bar);

fprintf('\n>> Subtracting bg_model from all IMGS\n');
IMGS_NORM   = IMGS_BG(1:9); % get all the normalised images,
[IMG_BGREMOVE, ~] = bg_subtraction(IMGS_NORM, bg_model);

fprintf('\n'); disp(bar);

%% THRESHOLDING
% do the normal thresholding here, 
%   i.e. thresh(I_r - B_r) | ...| thresh(I_b - B_r)
disp(bar);

fprintf('\n>> Doing thresholding...');
sizeparam = 16;
[IMG_THRESH, thresh_vals] = dothresh(IMG_BGREMOVE, sizeparam);

fprintf('\nimg_thresh,thresh_vals added\n\n'); disp(bar);

%% NOTE:
% AT this stage, we have threshold all our training set. 
% call another script for feature extraction

%% 