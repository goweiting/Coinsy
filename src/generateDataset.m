function [X_train, X_vali, X_test, y_train, y_vali, y_test] = ...
                generateDataset(PROP, train, vali, test)
%% Use hold out validation technique to randomly generate the training, validation and testing set
%   Since the images are input, we will use create psuedo samples from the
%   subimages

%   INPUT:
%   - PROP - a struct have the following field:
%             1) 
%   - train,vali,test : are double from [0,1] that indicate the size of each
%               sets. Hence they must sum up to 1;

%%
if (train + vali + test) == 1;
    
    [~, num_imgs] = size(PROP);
    [~, num_features] = size(PROP{1}.Properties(1).Features);
    num_data = 0;
    
    % first, put all images together
    for im=1:num_img
        num_of_obj = PROP{im}.num_of_obj;
        num_data = num_data + num_of_obj; % increment counter
        
        for obj=1:num_of_obj % iterate through the data
            y = PROP{im}.Properties.Class
        end
        
    end
    
        
    
    
else
%% Error
    error('percentage must add up to 1!');
end
