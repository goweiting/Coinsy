%% START CODE:
clc,clf,clear all; close all;

% add all relevant folders && misc stuff
addpath('filters/', 'image_processing/', 'segmentation/', 'classification/', ...
            'dataset/', 'imgs/', '../misc/export_fig.package/'); 
addpath('../../../MATLAB/Add-Ons/altmany-export_fig-f0af704/');
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