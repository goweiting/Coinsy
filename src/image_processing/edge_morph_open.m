function edges_morph = edge_morph_open(img, SE, SIZE)
%% Given an image, use the OPEN operator to morph the img with 
%   a structuring elemet:
% INPUT:
%   img - a gray image
%   SE  - a struct element, if defined. Otherwise, if SE = 'disk' or
%   'nhood', it uses the SIZE to initialise the SE.
%   SIZE - is optional if SE is already initialised using strel

% INITIALISE THE SE
switch SE
    case 'disk'
        try 
            SE = strel('disk', SIZE);
        catch
            disp('SIZE is not defined, using default radius of 15')
            SE = strel('disk', 15);
        end
    case 'nhood'
        SE = strel(nhood);
end

% USING IMOPEN:
edges_morph = imopen(img, SE);
imshow([img edges_morph]);

end


