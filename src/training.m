%% MASTER SCRIPT USE FOR TRAINING
% Steps:
%   1.  setup
%       a. load images and IMGS_BG (for bg modelling), IMGS (all simpler images)
% 
%   2.  image_processing
%       a.  normalisation           (normalise_rgb)
%       b.  background model        (bg_extract)
%       c.  background subtraction  (bg_subtraction)
%       d.  thresholding            (dothresh)
% 
%   3.  extract_features
%       a.  regionprops             
%       b.  getFeatures
%           -   rawmoment,
%           -   centralmoment,            
%           -   complexmoment, 
%           -   SI_momment,
%           -   humomentinvariant
% 
%   4.  Classification
%       a.  manual_classifcation
%           -   user_classify
%       b.  trainclf_loglikelihood
%           -   split_data
%           -   gaussianDistr, gaussian_clf, logdet
%           -   findConfusion
%%
clear all; close all; clc;
setup; % import images

% START TRAINING:
%% Image processing using 2 different methods:
%%
method = input('[1] Gradient Magnitude method, [2] normalsied background? [1,2]\n');
if method == 1
    gradmag_edge
elseif method == 2
    image_processing;
else
    return;
end

%% Extract features from IMGS_THRESH
%% 
% IMG_THRESH must be present in the workspace!
extract_features;   % call extract_features to get subimages 
                    % and then extract features for each subimages

%% Init Manual Classification
%%
man_class = input('do you want to manually classify these images now? [0/1]');
if man_class
    manual_classification;
end

%%  Fit the multivarate gaussian classifier
trainmultivarate;

%% END
disp(bar);
fprintf('\nEND\n');
disp(bar);