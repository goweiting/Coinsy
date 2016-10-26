function img_ = generateImage(img, num)
%% GENERATEIMAGE(IMG, NUM)
%   Given an image, generate a couple of the same image.
%   INPUT:
%   - img : should be given as a struct so that the class it belongs to is
%   naturally embedded into the data structure.
% 
%   OUTPUT:
%   - img_ : will be a struct it self, containing `num` copies of
%   transformed img