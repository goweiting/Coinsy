%% SCRIPT FOR TRAINING CLASSIFIER:
clc,clf,clear all;

% add all relevant folders
addpath('filters/', 'image_processing/', 'segmentation/'); 

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
img = {img2, img3, img4, img5, img6, img7, img8, img9, img10};
[~,num_img] = size(img);

%% NORMALISATION
fprintf('Normalising the images');
for i=1:num_img
    fprintf('.');
    img{i} = normalise_RGB(img{i}, 0);
end


%% GENERATE BACKGROUND MODEL
fprintf('\n\nGenerating Background Model...\n');
bg_model = bg_extract(img,3);

%% Subtract all images with the background model
img_bgremove = bg_subtraction(img, bg_model);