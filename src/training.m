%% SCRIPT FOR TRAINING CLASSIFIER:
clc,clf,clear all;

% add all relevant folders && misc stuff
addpath('filters/', 'image_processing/', 'segmentation/'); 
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

img11   = imread('../practice/harder/17.jpg');
img12   = imread('../practice/harder/18.jpg');
img13   = imread('../practice/harder/19.jpg');
img14   = imread('../practice/harder/20.jpg');
img15   = imread('../practice/harder/21.jpg');
BG_IMGS = {img2, img3, img4, img5, img6, img7, img8, img9, img10, ... 
            img11, img12, img13, img14, img15 };
[~, num_bg_img]  = size(BG_IMGS);


%% NORMALISATION
%   Here, we normalise the images before extracting the background
disp(bar);

fprintf('\nNormalising the images\n');
for i = 1:num_bg_img
    fprintf('.');
    BG_IMGS{i} = normalise_RGB(BG_IMGS{i}, 0);
%     figure; % DEBUG
end
fprintf('\n%d images Normalised\n\n', i);

disp(bar);

%% GENERATE BACKGROUND MODEL
disp(bar);

WINDOW_SIZE = 1;
fprintf('\nGenerating Background Model With WINDOW_SIZE = %d\n', WINDOW_SIZE);
bg_model = bg_extract(BG_IMGS, WINDOW_SIZE);

fprintf('\n'); disp(bar);

%% Subtract all images with the background model
disp(bar);

fprintf('\nSubtracting bg_model from all IMGS\n');
IMGS    = BG_IMGS(1:9); % get all the normalised images,
[img_bgremove, ~] = bg_subtraction(IMGS, bg_model);

fprintf('\n'); disp(bar);

%%  Thresholding
disp(bar);
fprintf('\nDoing thresholding...');
[thresh_imgs, thresh_vals] = dothresh(img_bgremove);
fprintf('\n'); disp(bar);

%%