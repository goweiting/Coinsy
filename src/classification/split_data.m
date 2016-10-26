function [X_train, X_vali, X_test, y_train, y_vali, y_test] = ...
                split_data(X, y, train, vali, test)
%% SPLIT_DATA(X, y, train, vali, test);
%   Use hold out validation technique to randomly generate the training, validation and testing set
%   Since the images are input, we will use create psuedo samples from the
%   subimages

%   INPUT:
%   - train,vali,test : are double from [0,1] that indicate the size of each
%               sets. Hence they must sum up to 1;

%%
num_instances = length(X);

if length(X) ~= length(y)
    error('X and y does not have the same number of instances');
end
if (train + vali + test) ~= 1;
    error('train + vali + test ~= 1!!')
end

num_train = floor(num_instances * train);
num_vali = floor(num_instances * vali);
num_test = num_instances - num_train - num_vali;

X_train_idx = randperm(num_instances,num_train);
X_train     = X(X_train_idx, :);
y_train     = y(X_train_idx);
% remove these instances
X(X_train_idx,:)    = [];
y(X_train_idx)      = [];

X_vali_idx  = randperm(num_instances-num_train, num_vali);
X_vali      = X(X_vali_idx,:);
y_vali      = y(X_vali_idx,:);
% remove these instances
X(X_vali_idx,:)     = [];
y(X_vali_idx)       = [];

% the rest for test:
X_test  = X;
y_test = y;

end
