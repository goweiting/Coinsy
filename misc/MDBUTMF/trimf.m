function [y]=trimf(x)
% Trimmmed median filter for Salt & pepper Noise
% Y     = output of trimmed median filter
% x     = input Matrix


% Code Developed BY : Suraj Kamya
% kamyasuraj@yahoo.com
% Visit to: kamyasuraj.blogspot.com

x=x(:); % column vecctor
N=[0 255]; % if pepper or salt
y=[]; % the median
for i=1:length(x)
    if x(i)~=N % Checking noisy pixel
        y=[y x(i)]; % Trimmed output
    end
end
y=median(y(:)); % Meadin of the required data
