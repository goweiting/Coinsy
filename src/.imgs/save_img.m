function [] = save_img(RGB, mode, TITLE, filename, extension);
%% save_img(RGB, mode, title, filename, extension)
%   EXTENSION: '-png' OR '-pdf'

%% PARAM
    ITER = 4;
    SIZE_MF = 3;
    SIGMA_GAUSS = .9;
    SIZE_GAUSS = 3;
    dir = './imgs';
    pos = [704 1 663 659];
    clf;
    
%%
switch mode
    case 'meshc'
%         % DEcided that this function just output stuff, there's no need
%         to do any additional filter! the user should havae the
%         flexibility.

%         % Smooth the image
%         smoothed_surfc = median_filter_iter(double(RGB), ITER, 0, SIZE_MF);
%         figure; imshow(uint8(smoothed_surfc)); title('Smoothed with median filter');%%DEBUG
%         % should double smooth ??
%         smoothed_surfc = gaussian_filter_2d(smoothed_surfc, 0, SIZE_GAUSS, SIGMA_GAUSS); 
%         figure;imshow(uint8(smoothed_surfc)); title('Smoothed with gaussian'); %% DEBUG

        % convert to 2D if RGB
        if ndims(RGB) == 3
            GRAY = myrgb2gray_double(RGB);
            GRAY_T = cat(3, RGB(:,:,1)', RGB(:,:,2)', RGB(:,:,3)');
        else
            GRAY = RGB;
            GRAY_T = RGB';
        end
        
        % save the original for comparison
        figure; 
        imshow(uint8(GRAY_T)); 
        set(gcf, 'Position', pos);
        title('Original Image in Grayscale');
        fileDir = sprintf('%s/%s.original', dir, filename);
        export_fig(fileDir, extension);
        
        [xmax, ymax] = size(GRAY);
        GRAY_x = 10:5:xmax-10; % remove ugly bothers around the image!
        GRAY_y = 10:5:ymax-10;
        
        % subtract from mean for ease of visualisation
        GRAY_mesh = GRAY(GRAY_x, GRAY_y);
        GRAY_mesh_avg = mean(mean(GRAY_mesh));  % get average of pixels
        GRAY_mesh = abs(GRAY_mesh-GRAY_mesh_avg); % take absolute so that whatever that is 'out of the background' will be above
        figure;
        meshc(GRAY_mesh);
        title(TITLE);
        colormap(gray);colorbar; 
        view(90, 80);
        set(gcf,'Position',pos);
        fileDir = sprintf('%s/%s_mesh', dir, filename);
        export_fig(fileDir, extension);
        
    case 'hist'
        if ndims(RGB) == 3
        end
            % find histogram for each color and the plot it
            
end

end