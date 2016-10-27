function [prediction, prob_all] = gaussian_clf(X_test, DATA_CLASS, p_limit)
%% GAUSSIAN_CLF(X_TEST, MEAN, COVARIANCE)
%   Given a the features of some images (X_test), we use a gaussian model
%    to find the most probable class (i.e. highest probability);
%
%   INPUT:
%   - DATA_CLASS is a cell array of struct where each cell gives us the
%   information of the class. The number of class = length of DATA_CLASS
%
%   OUTPUT:
%   - predictions : a list of classes for each instances in X_test

%%

num_class   = length(DATA_CLASS);
num_sample  = length(X_test);

prediction  = zeros(num_sample,1);
prob_all    = zeros(num_sample, num_class);

for n=1:num_sample
    for i=1:num_class
%         fprintf('%d,%d',n,i); %%DEBUG
        prior_  = DATA_CLASS{i}.Prior;
        mean_   = DATA_CLASS{i}.Mean;
        cov_    = DATA_CLASS{i}.Cov;
        data    = X_test(n,:);
        p = gaussianDistr(mean_, cov_, prior_, data);
%         disp(p);
        prob_all(n,i) = p;

    end

    [probs, prediction(n)] = max(prob_all(n,:));

    % toggle the use of p_limit
    if nargin == 3
        % If probability is larger than the confidence interval, thrash it!
        for i = 1:num_sample
            if probs < p_limit
                prediction(n) = 11; % set to unclassified
%                 fprintf('x');
            end
        end
    end


end

end
