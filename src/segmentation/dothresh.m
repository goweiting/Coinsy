function [thresh_imgs, thresh_vals] = dothresh(IMGS)
%% function to do thresholding

%%

sizeparam = 4;

if iscell(IMGS)
    [~, num_imgs] = size(IMGS);

    % Parameters
    thresh_vals = {};

    for k = 1:num_imgs
        % Generate historgram:
        hist = dohist(IMGS{k});
        % find the threshold for each images 
            % TODO: better method for finding threshold??
        thresh_vals{k} = findthresh(hist, sizeparam, 0); 

        % do thresholding on images
    %     thresh_imgs{n} = im2bw(IMGS{i}, thresh_vals{i});
        [m,n,chn] = size(IMGS{k});
        img = IMGS{k};
        imgX = zeros(size(img)); % preallocation of memory
        thresh = thresh_vals{k};

        for c=1:chn
            for i=1:m
                for j=1:n
                    if img(i,j,c) > thresh
                        imgX(i,j,c) = 1;
                    else
                        imgX(i,j,c) = 0;
                    end
                end
            end
        end

        imgX = logical(imgX);
        thresh_imgs{k} = imgX(:,:,1) || imgX(:,:,2) || imgX(:,:,3);
            
    end
    
%%     If not a cell array:
else
   
    % Generate historgram:
    hist = dohist(IMGS);
    % find the threshold for each images 
    % TODO: better method for finding threshold??
    thresh_vals = findthresh(hist, sizeparam, 0); 
    [m,n,chn] = size(IMGS);
    imgX = zeros(size(IMGS)); % preallocation of memory
    thresh = thresh_vals;

    for i=1:m
            for j=1:n
                for c=1:chn
                if IMGS(i,j,c) > thresh
                    imgX(i,j,c) = 1;
                else
                    imgX(i,j,c) = 0;
                end
            end
        end
    end

    thresh_imgs = max( max(imgX(:,:,1), imgX(:,:,2)), imgX(:,:,3));

end


end

