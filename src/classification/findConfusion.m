function[ CM, Per ] = findConfusion(result, test_class)
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
cm = zeros(10,10);

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
per = zeros(10,4);
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
for s=(1:10)
    % generate the data;
    TP = cm(s,s);
    FP = sum(cm(:,s)) - TP; % sum of the column belonging to class s, minus Tp
    FN = sum(cm(s,:)) - TP; % sum of the row belong to class s, minus TP
    TN = sum(sum(cm)) - TP - FN - FP;
%     allNegative = FN + TN;
%     allPositive = TP + FP;
    % store the values
    per(s,1) = FN;
    per(s,2) = FP;
    per(s,3) = TP;
    per(s,4) = TN;
end

CM = cm;
Per = per;

% RETURN AS TABLES:
% rowNames = {'No_1','No_2','No_3','No_4','No_5','No_6','No_7','No_8',...
%                 'No_9','No_0'};
% CM = array2table(cm, 'VariableNames', rowNames, 'RowNames', rowNames);
% headings = {'FN', 'FP', 'TP', 'TN'};
% Per = array2table(per, 'VariableNames', headings, 'RowNames', rowNames);

end
