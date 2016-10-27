function p = gaussianDistr(mean_, cov_, prior, data)
%% GAUSSIANDISTR(MEAN,COV,X)
%   using log posterior probability:
%   ln P(C|x) = (-.5)(x-mu)'(inv(cov))(x-mu) - .5(ln(det(cov)) + ln(P(C))
% 
%   INPUT:
%       mean = scalar; mean of gaussian distribution
%       cov  = D-by-D matrix; covariance of ditribution
%       x    = D dimension vector to calculate the pr.
%   
%   OUTPUT:
%       p    = probability of x being classified using this gaussian model

%% generate Probability;

% diff = data - mean_;
% dist = diff*cov_*diff';
% n = length(data);
% wgt = 1/sqrt(det(cov_));
% p = prior * ( 1 / (2*pi)^(n/2) ) * wgt * exp(-0.5*dist);
% disp(p); %% DEBUG
% % 
% 
[A,D] = size(cov_);
mean_ = mean_'; % assume data and mean is presented as row vector
data  = data';

logDet = (-.5) * logdet(cov_); 
firstPart = (-.5) * ((data - mean_)' / cov_) * (data - mean_);
prior = log(prior); 

% calculate the probability using the formula:
p = firstPart + logDet + prior;

end
