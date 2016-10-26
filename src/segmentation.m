%% SCRIPT FOR IMAGE SEGMENTATION
%% PRE-PROCESSING%%
fprintf('\t\tPREPROCESSING IMAGES\n');
%% NORMALISATION
%   Here, we normalise the images before extracting the background
disp(bar);

fprintf('\n>> Normalising the images\n');
for i = 1:num_img_bg
    fprintf('.');
    IMGS_BG{i} = normalise_RGB(IMGS_BG{i},0);
%     figure; % DEBUG
end
fprintf('\n%d images Normalised\n\n', i);

disp(bar);

%% IMAGE SEGMENTATION %%
fprintf('\t\tIMAGE SEGMENTATION\n');
fprintf('Approach:\n1) Generate background model\n2) Background subtraction\n3) Thresholding\n');
%% GENERATE BACKGROUND MODEL
disp(bar);

WINDOW_SIZE = 1;
fprintf('\n>> Generating Background Model With WINDOW_SIZE = %d\n', WINDOW_SIZE);
bg_model = bg_extract(IMGS_BG, WINDOW_SIZE);

fprintf('\n'); disp(bar);



imshow(bg_model);
export_fig('norm_1.png');
disp(bar);

WINDOW_SIZE = 3;
fprintf('\n>> Generating Background Model With WINDOW_SIZE = %d\n', WINDOW_SIZE);
bg_model = bg_extract(IMGS_BG, WINDOW_SIZE);

fprintf('\n'); disp(bar);
imshow(bg_model);
export_fig('norm_3.png');
disp(bar);

WINDOW_SIZE = 5;
fprintf('\n>> Generating Background Model With WINDOW_SIZE = %d\n', WINDOW_SIZE);
bg_model = bg_extract(IMGS_BG, WINDOW_SIZE);

fprintf('\n'); disp(bar);
imshow(bg_model);
export_fig('norm_5.png');


%% BACKGROUND SUBTRACTION
disp(bar);

fprintf('\n>> Subtracting bg_model from all IMGS\n');
IMGS_NORM   = IMGS_BG(1:9); % get all the normalised images,
[IMGS_BGREMOVE, ~] = bg_subtraction(IMGS_NORM, bg_model);

fprintf('\n'); disp(bar);

%% THRESHOLDING
% do the normal thresholding here, 
%   i.e. thresh(I_r - B_r) | ...| thresh(I_b - B_r)
disp(bar);

fprintf('\n>> Doing thresholding...');
sizeparam = 16;
[IMGS_THRESH, thresh_vals] = dothresh(IMGS_BGREMOVE, sizeparam);

fprintf('\nIMGS_THRESH and thresh_vals added\n\n'); disp(bar);

%% NOTE:
% AT this stage, we have threshold all our training set. 
% call another script for feature extraction

%% NEXT>> EXTRACT FEATURES