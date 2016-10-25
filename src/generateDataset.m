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
    % first, put all images together
    
    
    
    
else
%% Error
    error('percentage must add up to 1!');
end
