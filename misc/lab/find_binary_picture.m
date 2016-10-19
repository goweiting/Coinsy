function [binary_pic0, binary_pic1] = find_binary_picture(img, threshold)
%% Returns the binary image for a given image. 
% If a specific threshold is defned, then use that threshold!
% otherwise use the findthresh.m function to get the threshold.
% DEPENDS ON:
%   *   findthresh.m
%   *   dohist.m
% PARAM:
%   Input: the original image     
%   Output: 

%% Code:
% image parameters
[m.n] = size(img);

% separate the image using the threshold!
    if (threshold > 0) % a threshold is selected
        binary_pic0_logic = img < threshold;
        binary_pic1_logic = img >= threshold;

        % apply it to the image:
        binary_pic0 = img & binary_pic0_logic;
        binary_pic1 = img & binary_pic1_logic;

        % display:
        imshow(binary_pic0); figure;
        imshow(binary_pic1);
    else
% use the dohist function to get the raw histogram before
% smoothing
        threshold = findthresh(dohist(img,0),6,1);

        binary_pic0_logic = img < threshold;
        binary_pic1_logic = img >= threshold;

        % apply it to the image:
        binary_pic0 = img & binary_pic0_logic;
        binary_pic1 = img & binary_pic1_logic;

        % display the images:
        imshow(binary_pic0); figure;
        imshow(binary_pic1);
    end
end