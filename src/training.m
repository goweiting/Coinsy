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
setup % import images
% START TRAINING:
image_processing; 
extract_features;  % OUTPUT DATA!

%% Init Manual Classification
man_class = input('do you want to manually classify these images now? [0/1]');
if man_class
    manual_classification;
end

%%
