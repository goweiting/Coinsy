function [new_img, bg_model] = bg_subtraction(img, bg_model)
%% BG_SUBTRACTION(IMG, BG_MODEL)
%   returns a new image after subtracting it with the bg_model
%   Given a cell array of img, bg_model models after these img and return a
%   cell array of img with their background removed using the inferred
%   bg_model

%   INPUT:
%   - IMG:  a cell array or just an image. If it is just an image, a
%   bg_model must be given
%   - bg_model : optional if you want the algorithm to infer the bg model
%   from the img. in this case, img must be a cell array of image
%   N.B, if bg_model is given and img is cell, no bg_model is inferred, and
%   this will be just a simple straightforward bg subtraction algorithm.

%   OUTPUT:
%   - new_img : a cell array of image if input is cell array
%   - bg_model : if bg_model is inferred, otherwise just the bg_model

%%
% No bg_model given; img is cell array of images
if iscell(img)
    
    [~, num_img] = size(img);
    new_img = img; % memory allocation
    
    switch nargin
        case 1
            disp('extracting bg_model from cell array of images');
            bg_model = bg_extract(img);
    
            % carry out subtraction:
            for i=1:num_img
                new_img{i} = abs(img{i} - bg_model); % take abs, avoid negative
            end

        case 2
            disp('subtracting all images with given bg_model')
            % carry out subtraction:
            for i=1:num_img
                new_img{i} = abs(img{i} - bg_model);
            end
    end
else
    % subtract bg from img;
    new_img = abs(img - bg_model);
end

disp('done');

end 
    