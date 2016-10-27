%% SCRIPT FOR TRAINING MULTIVARATE GAUSSIAN CLASSIFIER
%   Assume you have done extract_features and manual_classification
%   PROP must be in your workspace

%% COMPACT ALL YOUR DATA:
[~, num_instance] = size(DATA);
[~, num_feature] = size(DATA(1).Features);

num_data = 0;
X = []; % Feature
y = []; % classes


% first, put all images together matrix
for im=1:num_instance
    X = [X; DATA(im).Features];
    y = [y; DATA(im).Class];
end
% y = reshape(y, [],1); % convert into col vector


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASS 1 is missing (NO POUND COIN DETECTED!)
% CREATE BOGUS DATA:
for w=1:4
    y(num_instance+w) = 1;
    X(num_instance+w,:) = [rand(1,num_feature)]; % randomly give some data!
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Do hold-out validation:
% 50% for training, 25% for validation 25% for test
[X_train, X_valid, X_test, y_train, y_valid, y_test] = ...
    split_data(X, y, .5, 0, .5);

%% TRAINING THE CLASSIFIER:
% GROUP IN CLASS AND PARAMETER ESTIMATION:
classes      = unique(y);
num_class    = length(classes);
num_instance = length(X);

% Sort data into struct:
DATA_CLASS = {};

for i = 1:num_class % create a DATA_CLASS for each class
%     disp(i); %% DEBUG
    logica_     = [y_train == classes(i)];
    prior_      = sum(logica_)/num_instance;
    data        = X_train(logica_, :);
    mean_       = mean(data,1); % take the mean along the cols
    cov_        = cov(data,0); % number of observations -1; Maximmum posterior
   
    % Regularise COV:
    reg = exp(-10);
    reg_term = eye(length(cov_)) * reg;
    cov_ = cov_ + reg_term; % add regularisation
    disp(cov_);
    
    % store the parameters
    DATA_CLASS{i} = struct('Data', data, 'Prior', prior_, ...
                            'Mean', mean_, 'Cov', cov_);
end

%% VALIDATION DATASET:
% [y_vali_pred, ~] = gaussian_clf(X_valid, DATA_CLASS);
% 
% % Generate Statistics:
% [cm_valid, per] = findConfusion(y_vali_pred, y_valid);
% imshow(cm_valid, [], 'InitialMagnification', 1600); colormap(bone);
% title('Confusion Matrix for Validation Set');

%% Testing
p_limit = 0;
[y_test_pred,~] = gaussian_clf(X_test, DATA_CLASS, p_limit);

% Generate Statistics:
[cm_test, per] = findConfusion(y_test_pred, y_test, 11, p_limit);
%%