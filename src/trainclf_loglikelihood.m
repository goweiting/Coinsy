%% SCRIPT FOR TRAINING MULTIVARATE GAUSSIAN CLASSIFIER
%   Assume you have done extract_features and manual_classification
%   PROP must be in your workspace

%% COMPACT ALL YOUR DATA:
[~, num_imgs] = size(PROP);
[~, num_features] = size(PROP{1}.Properties(1).Features);
num_data = 0;
X = []; % Feature
y = []; % classes


% first, put all images together matrix
for im=1:num_imgs
    num_of_obj = PROP{im}.num_of_obj;
    num_data = num_data + num_of_obj; % count number of data 
    y = [y PROP{im}.Properties.Class]; %put them together
    
    for obj=1:num_of_obj % iterate through all the subimages
        feat = PROP{im}.Properties(obj).Features; % row vector
        X = [X; feat];
    end
end

y = reshape(y, [],1); % convert into col vector


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASS 1 is missing (NO POUND COIN DETECTED!)
% CREATE BOGUS DATA:
DATA = [X y];
[row, col] = size(DATA);
for w=1:4
    y(row+w) = 1;
    X(row+w,:) = [rand(1,col-1)]; % randomly give some data!
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


DATA = [X y];
[row, col] = size(DATA);
%% Do hold-out validation:
% 50% for training, 25% for validation 25% for test
[X_train, X_valid, X_test, y_train, y_valid, y_test] = ...
    split_data(X, y, .5, .25, .25);

%% TRAINING THE CLASSIFIER:
% GROUP IN CLASS AND PARAMETER ESTIMATION:
classes     = unique(y);
num_class   = length(classes);
num_instance = length(DATA);

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
    
    % store
    DATA_CLASS{i} = struct('Data', data, 'Prior', prior_, ...
                            'Mean', mean_, 'Cov', cov_);
end
%% VALIDATION DATASET:
[y_vali_pred, ~] = gaussian_clf(X_valid, DATA_CLASS);

% Generate Statistics:
[cm_valid, per] = findConfusion(y_vali_pred, y_valid);
imshow(cm_valid, [], 'InitialMagnification', 1600); colormap(bone);
title('Confusion Matrix for Validation Set');


fprintf('Done!\n\nThe confusion matrix is:\n(rows = actual class; columns = predicted class)\n');
disp(cm_valid);
fprintf('\nThe classification results for each class are:\n   (FN    FP    TP   TN)\n');
disp(per);

disp('========================================================');
fprintf('Summary:\nClassification using full gaussian model\n');
FN = sum(per(:,1));
FP = sum(per(:,2));
TP = sum(per(:,3));
TN = sum(per(:,4));
incorrect = FP + FN;
correct = TP + TN;
acc_valid = correct / (correct + incorrect) * 100;

fprintf('Number of Features\t\t= %d\n', size(X,1));
fprintf('Number of Training Data \t= %d\n', length(X_train));
fprintf('Number of Validation Data \t= %d\n', length(X_valid));
fprintf('Accuracy = %8f percent (8 sf).\n\n', acc_valid);
disp('========================================================');

% CAN USE VALIDATION SET TO TWEAK THE FEATURES! (HYPER-PARAM)

%% Testing
[y_test_pred,~] = gaussian_clf(X_test,DATA_CLASS);

% Generate Statistics:
[cm_test, per] = findConfusion(y_test_pred, y_test);
figure; imshow(cm_test, [], 'InitialMagnification', 1600); colormap(bone);
title('Confusion Matrix for Testing Set');

fprintf('Done!\n\nThe confusion matrix is:\n(rows = actual class; columns = predicted class)\n');
disp(cm_test);
fprintf('\nThe classification results for each class are:\n   (FN    FP    TP   TN)\n');
disp(per);

disp('========================================================');
fprintf('Summary:\nClassification using full gaussian model\n');
FN = sum(per(:,1));
FP = sum(per(:,2));
TP = sum(per(:,3));
TN = sum(per(:,4));
incorrect = FP + FN;
correct = TP + TN;
acc_test = correct / (correct + incorrect) * 100;

fprintf('Number of Features\t\t= %d\n', size(X,1));
fprintf('Number of Training Data \t= %d\n', length(X_train));
fprintf('Number of Test Data \t= %d\n', length(X_test));
fprintf('Accuracy = %8f percent (8 sf).\n\n', acc_test);
disp('========================================================');
%%
% What is worth validating? What hyper param?
figure;
ax1 = subplot(1,2,1);
imshow(cm_valid, winter); 
s = sprintf('Left:Validation Set (Acc=%4f)',acc_valid);
title(s);

ax2 = subplot(1,2,2);
imshow(cm_test, winter); 
s = sprintf('Right:Test Set(Acc=%4f)', acc_test);
title(s);