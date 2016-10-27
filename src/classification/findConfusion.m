function[ CM, Per ] = findConfusion(result, test_class, num_class, p_limit)
%% findConfusion
% INPUT: [targets, output]
%   S = number of features ( in this case, 10)
%   Q = number of test data
%   result      :   Q-by-1 data each (i,j) indicates the ith input's class, 
%   test_class  :   Q-by-1 data each (i,j) indicates the class given to ith
%               input.
%   targets and output must be ordered the same way. 

% OUTPUT: [c. cm, ind, per]
%   cm  :   S-by-S confusion matrix, where (i,j) is the number of samples
%           whose target is the ith class that was classified as j
%   per :   S-by-4 matrix, where each row summarises four percentages
%           associated with the ith class:


%% setup:
[Q,S] = size(result); % Q = number of observation
[~,S1] = size(test_class);

% check for number of test-case
if S ~= S1
    error('test_class and results doesnt match in size');
end

%% create the confusion matrix
% Row = actual
% column = predicted
cm = zeros(num_class, num_class); % dont need to show cm for class 11

% iterate through all the test data to add data into the confusion matrix
for q=(1:Q)
    predictedClass = test_class(q,1);
    actualClass = result(q,1);
    
    if predictedClass == actualClass 
        % if the classifier successfully classsfied the datapoint
       cm(actualClass,actualClass) = ...
           cm(actualClass,actualClass) + 1;
    else
        % classifier classifies the point wrongly.
        cm(actualClass, predictedClass) = ...
            cm(actualClass,predictedClass) + 1;
    end
end

%% manipulate the cm to get per:
per = zeros(num_class,4); % ignore the unclassified class here
% each row corresponds to each class
%         per(i,1) false negative rate
%                   = (false negatives)
%         per(i,2) false positive rate
%                   = (false positives)
%         per(i,3) true positive rate
%                   = (true positives)
%         per(i,4) true negative rate
%                   = (true negatives)

% for each class find the FN, FP, TP, TN respectively.
for s=(1:num_class)
    % generate the data;
    TP = cm(s,s);
    FP = sum(cm(:,s)) - TP;
    FN = sum(cm(s,:)) - TP; 
    TN = sum(sum(cm)) - TP - FN - FP;

    % store the values
    per(s,1) = FN;
    per(s,2) = FP;
    per(s,3) = TP;
    per(s,4) = TN;
end

CM = cm;
Per = per;

%% 
figure; imshow(CM, [], 'InitialMagnification', 1600); colormap(bone);
title('Confusion Matrix for Testing Set');

fprintf('Done!\n\nThe confusion matrix is:\n(rows = actual class; columns = predicted class)\n');
disp(CM);
fprintf('\nThe classification results for each class are:\n   (FN    FP    TP   TN)\n');
disp(per);

disp('========================================================');
fprintf('Summary:\nClassification using full gaussian model\n');
FN = sum(per(:,1));
FP = sum(per(:,2));
TP = sum(per(:,3));
TN = sum(per(:,4));
incorrect = FP + FN;
correct = TP;
acc_score = TP/ Q; % Q = number of obervation

fprintf('Number Incorrect = %d\n', incorrect);
fprintf('Number Correct = %d\n', correct);
fprintf('Number Unclassified (lesser than p = %.2f) = %d\n',p_limit, Per(11,1) );
fprintf('Accuracy = %3f percent\n\n', acc_score);
disp('========================================================');

end
