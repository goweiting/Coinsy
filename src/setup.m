%% START CODE:
clc,clf,clear all; close all;

% add all relevant folders && misc stuff
addpath('filters/', 'image_processing/', 'classification/', ...
            'dataset/', 'imgs/', 'features'); 
addpath('../misc/export_fig.package/');

bar = '=========================================================';
barbar = '---------------------------------------------------------';

disp(bar);
fprintf('\t\tIMPORTING IMAGES\n');
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
% IMGS    = {img2, img3, img4, img5, img6, img7, img8, img9, img10, ... 
%             img11, img12, img13, img14, img15 };
[~, num_img_bg]  = size(IMGS_BG);
fprintf('\t\t\t\t\t\t    done\n');
%%
tmp = input('Continue? [1/0] ');
if ~tmp 
   return
end
disp(bar);