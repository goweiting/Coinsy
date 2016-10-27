%% MORPHOLOGICAL GRADIENT EDGE DETECTION
% source : http://www.vlsi.uwindsor.ca/presentations/2007/13-Neil.pdf#15
%   do Edge finding by subtracting opened img with the closed image
%   following thresholding to detect edges
%%
% setup ; % load all the images
%%
disp(bar);
fprintf('\t\tIMAGE SEGMENTATION\n');
fprintf('Approach:\n0) Use median filter to conv with images1) Find Dilation and Erosion of images 2) Subtract Dilation from Erosion to get rid of background; edges retrieved\n');
%%
for i=1:9
    % Use median filtering
    IMG = IMGS{i};
    window_size = 5;
    fprintf('>> Filtering the image with median filter with window_size = %d\n',window_size);
    IMG = median_filter_iter(IMG, 5, 0, window_size);
    
    % performs edge detection using morphology with size of 3;
    fprintf('>> Finding Edges for imag %d\n',i);
    IMGS_BGREMOVE{i} = edge_morph_disk(IMGS{i});

    % For printing images    
    s = sprintf('./imgs/morph_thresh/edges_morph_medfilt.%d.png',i);
    close all; 
    figure;
    imshow(IMGS_BGREMOVE{i})
    export_fig(s);
    close all;
end

fprintf('\t\tdone\n');
tmp = input('Continue? [1/0] ');
if ~tmp
    disp(bar);
    return
end
disp(bar);

%% Thresholding to obtain BW images
disp(bar);
fprintf('>> Thresholding images now to obtain BW image\n');
%%
% use standard thresholding technique to threhsold images
sizeparam = 16;
[IMGS_THRESH, thresh_vals ] = dothresh(IMGS_BGREMOVE, sizeparam);
fprintf('Selected sizeparam = %d\n', sizeparam);

for i=1:9
    % store images
    s = sprintf('./imgs/morph_thresh/edges_morph_thresh_medfilt.%d.png',i);
    close all; 
    figure;
    imshow(IMGS_THRESH{i})
    export_fig(s);
    close all;
end

fprintf('Completed thresh holding edge morphed images');
fprintf('\nIMGS_THRESH and thresh_vals added\n\n');
fprintf('\t\t\t\t\t\t    done\n');
tmp = input('Continue? [1/0] ');
if ~tmp
    disp(bar);
    return
else
    disp(bar);
end

disp(bar);
%%
% Next >> Feature Extraction
