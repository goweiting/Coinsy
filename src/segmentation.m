%% SCRIPT FOR IMAGE SEGMENTATION:

%% START CODE:
clc,clf,clear all;

% add all relevant folders && misc stuff
addpath('filters/', 'image_processing/', 'segmentation/', 'classification/', ...
    'object_recognition/', 'classification/COUNT/1POUND','classification/COUNT/20P/',...
    'classification/COUNT/25P/','classification/COUNT/2P/','classification/COUNT/2POUND/',...
    'classification/COUNT/50P/','classification/COUNT/5P/','classification/COUNT/75P/',...
    'classification/DONT_COUNT/AAA/','classification/DONT_COUNT/NUT/');

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

scalar = 1.8;

img2    = img2 * scalar;
img3    = img3 * scalar;
img4    = img4 * scalar;
img5    = img5 * scalar;
img6    = img6 * scalar;
img7    = img7 * scalar;
img8    = img8 * scalar;
img9    = img9 * scalar;
img10   = img10* scalar;


img11   = imread('../practice/harder/17.jpg');
img12   = imread('../practice/harder/18.jpg');
img13   = imread('../practice/harder/19.jpg');
img14   = imread('../practice/harder/20.jpg');
img15   = imread('../practice/harder/21.jpg');
IMGS    = {img2, img3, img4, img5, img6, img7, img8, img9, img10};
IMGS_BG = {img2, img3, img4, img5, img6, img7, img8, img9, img10, ... 
            img11, img12, img13, img14, img15 };
[~, num_img_bg]  = size(IMGS_BG);

%% PRE-PROCESSING%%
fprintf('\t\tPREPROCESSING IMAGES\n');
%% NORMALISATION
%   Here, we normalise the images before extracting the background
disp(bar);

fprintf('\n>> Normalising the images\n');
for i = 1:num_img_bg
    fprintf('.');
    IMGS_BG{i} = normalise_RGB(IMGS_BG{i}, 0);
%     figure; % DEBUG
end
fprintf('\n%d images Normalised\n\n', i);

disp(bar);

%% IMAGE SEGMENTATION %%
fprintf('\t\tIMAGE SEGMENTATION\n');
fprintf('Approach:\n1) Generate background model\n2) Background subtraction\n3) Thresholding\n');
%% GENERATE BACKGROUND MODEL
disp(bar);

WINDOW_SIZE = 7;
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