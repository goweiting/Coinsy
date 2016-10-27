%% SCRIPT FOR TRAINING MULTIVARATE GAUSSIAN CLASSIFIER
%   Assume you have done extract_features and manual_classification
%   DATA must be in your workspace
disp(bar);
fprintf('>> Traiing a multivarate gaussian classifier\n');
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

%% Do hold-out validation:
percent_train = .8;
percent_test = .2;
[X_train, X_valid, X_test, y_train, y_valid, y_test] = ...
    split_data(X, y, percent_train, 0, percent_test);

fprintf('Spliting the data into training and test dataset at %2f and %2f respectively\n', percent_train, percent_test);
tmp = input('Continue with parameter estimation? [1/0] ');
if ~tmp 
   disp(bar);
    return
end
disp(bar);
%% TRAINING THE CLASSIFIER:
% GROUP IN CLASS AND PARAMETER ESTIMATION:
classes      = unique(y);
num_class    = length(classes);
num_instance = length(X);

% Sort data into struct:
DATA_CLASS = {};

for i = 1:num_class % create a DATA_CLASS for each class
    fprintf('>> Training Class %d',i);
%     disp(i); %% DEBUGs
    logica_     = [y_train == classes(i)];
    prior_      = sum(logica_)/num_instance;
    data        = X_train(logica_, :);
    mean_       = mean(data,1); % take the mean along the cols
    cov_        = cov(data,0); % number of observations -1; Maximmum posterior
   
    % Regularise COV:
    reg = exp(-10);
    reg_term = eye(length(cov_)) * reg;
    cov_ = cov_ + reg_term; % add regularisation
%     disp(cov_);
    
    % store the parameters
    DATA_CLASS{i} = struct('Data', data, 'Prior', prior_, ...
                            'Mean', mean_, 'Cov', cov_);
    fprintf('\t\t\t\t     Done\n');
end

tmp = input('Do you want to test the classifier with X_test?? [1/0] ');
if ~tmp 
    disp(bar);
   return
end
disp(bar);
%% VALIDATION DATASET:
% [y_vali_pred, ~] = gaussian_clf(X_valid, DATA_CLASS);
% 
% % Generate Statistics:
% [cm_valid, per] = findConfusion(y_vali_pred, y_valid);
% imshow(cm_valid, [], 'InitialMagnification', 1600); colormap(bone);
% title('Confusion Matrix for Validation Set');

%% Testing
% p_limit = 0;
[y_test_pred, prob] = gaussian_clf(X_test, DATA_CLASS);

% Generate Statistics:
[cm_test, per] = findConfusion(y_test_pred, y_test, num_class); % change num_class to 11 if using unclassified class 11

disp(bar);
%%  Cross validate with training dataset
tmp = input('Do you want to train your classifier with the entire training set? [1/0] ');
if ~tmp 
    disp(bar);
   return
end
disp(bar);

% Setup
DATA_CLASS2 = {};
X_train = X; % use the whole dataset for training
y_train = y;
for i = 1:num_class % create a DATA_CLASS for each class
    fprintf('>> Training Class %d',i);
%     disp(i); %% DEBUGs
    logica_     = [y_train == classes(i)];
    prior_      = sum(logica_)/num_instance;
    data        = X_train(logica_, :);
    mean_       = mean(data,1); % take the mean along the cols
    cov_        = cov(data,0); % number of observations -1; Maximmum posterior
   
    % Regularise COV:
    reg = exp(-10);
    reg_term = eye(length(cov_)) * reg;
    cov_ = cov_ + reg_term; % add regularisation
%     disp(cov_);
    
    % store the parameters
    DATA_CLASS2{i} = struct('Data', data, 'Prior', prior_, ...
                            'Mean', mean_, 'Cov', cov_);
    fprintf('>>\t\t\t\t     Done\n');
end

%% Generate stats for testing against itself:
[pred, prob] = gaussian_clf(X_train, DATA_CLASS2);

% Generate Statistics:
[cm_test, per] = findConfusion(pred, y_train, num_class); % use num_class = 11 if using class 11 for unclassified 

disp(bar);

%%
% KEEP DATA_CLASS2 for classification testing
DATA_CLASS_MODEL = DATA_CLASS2;